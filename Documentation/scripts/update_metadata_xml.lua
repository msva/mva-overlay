xml=require"slaxdom"
mva_email="mva@gentoo.org"

for i=1,#arg do
	metadata_xml=arg[i]

	if not metadata_xml then
		-- actually, can should never happen, but let's keep it in case if universe will brake
		print("pass metadata.xml as argument(s)")
		os.exit(1)
	end

	f,err=io.open(metadata_xml,"rb");
	if not f then
		print(err); os.exit(1)
	end
	s=f:read("*a");

	s = s:gsub("(<!)(DOCTYPE[^>]*)(>)","%1--%2--%3")
				:gsub("\n","")
				:gsub("\t"," ")
				:gsub("  *"," ")

	metadata = xml:dom(s,{
					simple=true,
					stripWhitespace=true
				})

	local function strip_ws(ot,cn,ct)
		return ot
			..cn
				:gsub(
					"[\n][ ]*",
					""
				)
			..ct
	end

	local indent=2

	local function ifindent(indent, str)
		if indent then
			return str
		else
			return ""
		end
	end

	local m_k=metadata.kids
	for i=1,#m_k do
		if m_k[i].name == "pkgmetadata" then
			local pm_k=m_k[i].kids
			for ii=1,#pm_k do
				if pm_k[ii].name == "maintainer"
					 and pm_k[ii].attr and #pm_k[ii].attr>0
					 and pm_k[ii].attr[1].name == "type"
					 and pm_k[ii].attr[1].value == "person"
				then -- TODO: unhardcode attr position (make proper search, move to external function)
					local mnt_k=pm_k[ii].kids
					local name_i,email_i=0,0
					for iii=1,#mnt_k do
						if mnt_k[iii].name == "name" then
							name_i=iii;
						elseif mnt_k[iii].name == "email" then
							email_i=iii;
						elseif mnt_k[iii].name == "description" then
							mnt_k[iii]={}
						end -- if(mnt_k)
					end -- for(iii)
					if email_i>0 and name_i>0 then
						if mnt_k[name_i].kids[1].value:match("Misbakh") then
							mnt_k[email_i].kids[1].value=mva_email
						end -- if(mva)
					end -- email/name_i>0
				end -- if(pm_k)
			end -- for(ii)
		end -- if(m_k)
	end -- for(i)

--[[
--]]
	f,err=io.open(metadata_xml,"w+");
	if not f then
		print(err); os.exit(1)
	end
	f:write((
--]]
--print((
		xml:xml(
			metadata,
			{
				indent=indent,
				sort=true,
				omit
			}
		):gsub(
			"(<!)%-%-(DOCTYPE)([^>]+)%-%-(>)",
			"%1%2%3%4"
		):gsub(
			"(<flag[^>]*>)(.-)(</flag>)",
			strip_ws
		):gsub(
			"(<maintainer[^<]+)(.*)(\n[^<]*</maintainer>)",
			strip_ws
		):gsub(
			"(/email>)(<name)",
			"%1"..(ifindent(indent,"\n"))..(" "):rep((indent or 0)*2).."%2"
		)
	))
	f:close();
end
