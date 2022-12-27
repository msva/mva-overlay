xml=require"slaxdom"
mva_email="mva@gentoo.org"

local indent = 2
local char = "[a-zA-Z0-9().,-]"

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

	s = s
			:gsub("(<!)(DOCTYPE[^>]*)(>)","%1--%2--%3") -- Workaround for SLAXML bug as it doesn't currently support DOCTYPE
		-- pre-strip whitespaces in 3 steps:
			:gsub("\n","") -- TEMP (remove someday): pre-strip newlines (SLAXML skips it inside text-contained tags)
			:gsub("\t"," ") -- substitute tabs with spaces
			:gsub("  *"," ") -- substitute many spaces in a row with one

	metadata = xml:dom(s,{
					simple=true, -- simpler structure (no kids made from whitespaces)
					stripWhitespace=true -- strip other whitespaces
				})

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
					local desc_i,name_i,email_i=0,0,0
					for iii=1,#mnt_k do -- http://www.gentoo.org/dtd/metadata.dtd
						if mnt_k[iii].name == "name" then
							name_i=iii;
						elseif mnt_k[iii].name == "email" then
							email_i=iii;
						elseif mnt_k[iii].name == "description" then
							desc_i=iii;
						end -- if(mnt_k)
					end -- for(iii)
					if email_i>0 and name_i>0 then
						if mnt_k[name_i].kids[1].value:match("Misbakh%-Solov[a-z]*v") then -- since there is another devs and maintainers called Vadim, search me by last name (pattern here is because there was two notations)
							mnt_k[email_i].kids[1].value=mva_email
							if desc_i>0 then
								mnt_k[desc_i].kids[1].value="Also, you can find me on IRC (Libera.Chat) as mva, or in Telegram as @mva_name"
							end -- if(desc)
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
--[[
print((
--]]
		xml:xml(
			metadata,
			{
				indent=indent,
				sort=true,
				omit
			}
		)
		:gsub(  -- workaround over slaxml bug of not handling DOCTYPE
			"(<!)%-%-(DOCTYPE)([^>]+)%-%-(>)",
			"%1%2%3%4"
		)
		:gsub( -- strip indentation inside text-containing nodes
			"(>)[\n]*[ ]*("..char..")",
			"%1%2"
		)
		:gsub( -- same
			"("..char..")[\n]*[ ]*(</)",
			"%1%2"
		)
		:gsub( -- same, but handle the case of ending by <pkg/>
			"(</pkg>)[\n]*[ ]*(</)",
			"%1%2"
		)
		:gsub( -- add space right before <pkg/>
			"("..char..")[\n]*[ ]*(<pkg>[^<]*</pkg>)",
			"%1 %2"
		)
		:gsub( -- and after
			"(<pkg>[^<]*</pkg>)("..(char:gsub(".,",""))..")",
			"%1 %2"
		)
	))
	f:close();
end
