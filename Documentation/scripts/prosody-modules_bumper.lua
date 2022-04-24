#!/usr/bin/env luajit
--[[
if type(arg) ~= "table" then
	error"Something wrong with Lua installation (unable to handle arguments)"
end

local p = require"posix";
local uid = p.getuid();

local cmd = {};
table.insert(cmd,arg[-1])
arg[-1]=nil

for _,opt in pairs(arg) do
	table.insert(cmd,opt);
end
cmd=table.concat(cmd," ")

if tonumber(uid) ~= 250 then
	assert(not(arg[#arg]:match("under_sudo_portage")),"Broken Gentoo installation (portage not UID=250)")
	local exitcode=os.execute("sudo -u portage "..cmd.." #under_sudo_portage")
	os.exit(exitcode);
end
]]
local cURL = require"cURL";
local html = require"htmlparser"
--local lfs  = require"lfs"

htmlparser_looplimit = 5000

math.randomseed(tonumber(math.randomseed(os.time()) or os.time())+os.time()); -- randomize

--[[
local st;
local env_filename = os.tmpname();

st = os.execute("emerge --info > "..env_filename)
assert(st==0,"emerge --info failed")
local env_fd=io.open(env_filename)
local op,pt;
for line in env_fd:lines() do
	local mop=line:match([=[location: (/.*mva)]=]);
	local mpt=line:match([=[PORTAGE_TMPDIR=['"](/.*)['"]--------]=]);
	if mop then
		op=mop;
	elseif mpt then
		pt=mpt;
	end
end
env_fd:close();
os.remove(env_filename)

]]

local function pq(qs)
  local res = io.popen("portageq "..tostring(qs).." 2>/dev/null"):read("*l")
  return (res and #res>0) and res or nil
end

local op = pq"get_repo_path / mva" -- TODO: unhardcode current repo name
local pt = pq"envvar PORTAGE_TMPDIR"

assert(op~=nil,"Unable to get overlay path")
assert(pt~=nil,"Unable to get PORTAGE_TMPDIR path")

local UAs = {
  "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:37.0) Gecko/20130101 Firefox/37.0"; -- Firefox 37, Windows 7, 64bit
  "Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:37.0) Gecko/20130101 Firefox/37.0"; -- Firefox 37, Ubuntu 12, 32bit
  "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.22 (KHTML, like Gecko) Chrome/41.0.2272.118 Safari/537.22"; -- Chrome 34, Windows 7, 64bit
  "Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.22 (KHTML, like Gecko) Chrome/43.0.2357.10 Safari/537.22"; -- Chrome 34, Windows XP
  "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/537.22 (KHTML, like Gecko) Chrome/42.0.2311.82 Safari/537.22"; -- Chrome 25, Mac OS 10.7
  "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.22 (KHTML, like Gecko) Chrome/43.0.2537.10 Safari/537.22"; -- Chrome 25, Linux, 64bit
  "Mozilla/5.0 (X11; Linux i686) AppleWebKit/537.22 (KHTML, like Gecko) Chrome/43.0.2537.10 Safari/537.22"; -- Chrome 25, Linux, 32bit
  "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0)"; -- Internet Explorer 9, Windows 7, 64bit
  "Mozilla/5.0 (compatible; MSIE 11.0; Windows NT 8.1; WOW64; Trident/7.0)"; -- Internet Explorer 11, Windows 8.1, 64bit
  "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/536.26.17 (KHTML, like Gecko) Version/6.0.2 Safari/536.26.17"; -- Safari, Mac OS 10.8
}

local headers = {
	"Accept: text/*",
	"Accept-Language: ru,en",
	"Accept-Charset: utf-8,cp1251,koi8-r,iso-8859-5,*",
	"Cache-Control: no-cache"
}

local modules = {}
local e_p = op.."/net-im/prosody-modules/prosody-modules-9999.ebuild";
local md_p = op.."/net-im/prosody-modules/metadata.xml";
local function ebuild(ph)
	return os.execute("sudo -u portage ebuild "..e_p.." "..ph.." >/dev/null");
end

assert(ebuild"clean unpack","Failed to fetch modules")
--for mod in lfs.dir(pt.."/portage/net-im/prosody-modules-9999/work/prosody-modules-9999") do
for mod in io.popen([[sudo -u portage find ]]..pt..[[/portage/net-im/prosody-modules-9999/work/prosody-modules-9999 -maxdepth 1 -mindepth 1 -type d -name 'mod_*']]):lines() do
	table.insert(modules,mod:match("mod_(.*)"));
end
table.sort(modules);
assert(ebuild"clean","Failed to cleanup modules")

local function wrap(str, limit, indent, indent1)
	local indent = indent or ""
	local indent1 = indent1 or indent
	local limit = limit or 72
	local here = 1-#indent1
	return indent1..str:gsub("(%s+)()(%S+)()",
		function(sp, st, word, fi)
			if fi-here > limit then
				here = st - #indent
				return "\n"..indent..word
			end
		end)
end

local eol="\n"
local temp_fd,err=io.tmpfile();
assert(temp_fd,err);

local function manage_ebuild()
local eb_fd,err=io.open(e_p);
assert(eb_fd,err);
local inside=false;
for line in eb_fd:lines() do
	if line:match([[^PROSODY_MODULES="$]]) then
		temp_fd:write(line);
		temp_fd:write(eol)
		inside=true;
	elseif inside and (line:match([[^"$]])) then
		inside=false;
		temp_fd:write("\t");
		temp_fd:write((wrap(table.concat(modules," ")):gsub(eol,eol.."\t")));
		temp_fd:write(eol);
		temp_fd:write(line);
		temp_fd:write(eol);
	elseif inside and (line:match("^\t")) then
		local nop;
	else
		temp_fd:write(line);
		temp_fd:write(eol);
	end
end

temp_fd:flush();
assert(temp_fd:seek("set")==0,"WARNING: OS is broken!")
eb_fd:close();

local eb_fd,err=io.open(e_p,"w+");
assert(eb_fd,err);

for line in temp_fd:lines() do
	eb_fd:write(line..eol)
end
assert(temp_fd:seek("set")==0,"WARNING: OS is broken!")
eb_fd:close();
end
manage_ebuild();

local c = cURL.easy_init()
c:setopt_httpheader(headers)
c:setopt_cookiefile("")
c:setopt_followlocation(1)

local function get_flag_desc(flag)
	local buf,desc="","";
	local base_url="https://modules.prosody.im/mod_"..flag..".html";

	c:setopt_useragent(UAs[math.random(1,#UAs)]);
	c:setopt_url(base_url);
	c:setopt_writefunction(function(result) buf=buf..result; return true; end);
	c:perform();

	local dom=html.parse(buf)('div.container.container-fluid div.col-md-8 p');

	if #dom>0 then
		desc=dom[1]:getcontent();
		if desc:match("^NOTE: ") then
			desc=dom[2]:getcontent();
		end
	end

	desc=desc:gsub("</?[^>]*>","")

--	desc=desc and desc:gsub([=[(href=["'])(mod_[^"']+.html)(["'])]=],"%1https://modules.prosody.im/%2%3")

	desc=desc and desc.." (info: https://modules.prosody.im/mod_"..flag..")"

	return desc or "No documentation yet :("
end

local function manage_metadata()
local md_fd,err=io.open(md_p);
assert(md_fd,err);
local inside=false;
for line in md_fd:lines() do
	if line:match([[<use>]]) then
		temp_fd:write(line);
		temp_fd:write(eol)
		inside=true;
	elseif inside and (line:match([[</use>]])) then
		inside=false;
		for _,mod in ipairs(modules) do
			temp_fd:write("    <flag name='prosody_modules_"..mod.."'>"..get_flag_desc(mod).."</flag>");
			temp_fd:write(eol);
		end
--		temp_fd:write((wrap(table.concat(modules," ")):gsub(eol,eol.."\t")));
		temp_fd:write(eol);
		temp_fd:write(line);
		temp_fd:write(eol);
	elseif inside and (line:match("<flag name='prosody_modules_")) then
		local nop;
	else
		temp_fd:write(line);
		temp_fd:write(eol);
	end
end

temp_fd:flush();
assert(temp_fd:seek("set")==0,"WARNING: OS is broken!")
md_fd:close();

local md_fd,err=io.open(md_p,"w+");
assert(md_fd,err);

for line in temp_fd:lines() do
	md_fd:write(line..eol)
end
assert(temp_fd:seek("set")==0,"WARNING: OS is broken!")
md_fd:close();
end
manage_metadata();

c:close();
os.exit(0);
