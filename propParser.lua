prop = {}
function parse_props()
    prop_file = file.open("config.prop", "r")
    local result = false;
    if prop_file then
        repeat line=prop_file:readline()
            if (line~=nil) then
            line=string.sub(line, 0, -2)
               for key, value in string.gmatch(line, "(%S+)=(%S+)") do
                prop[key]=value
               end                    
            end
            until line==nil
            prop_file:close()
            prop_file=nil
            result = true
     else
        result = false
    end
        return result
end

function parse_body(body)
    if (body~=nil) then
        file.remove("config.prop");
        cfg = file.open("config.prop", "w")
        for kv in string.gmatch(body, "[^&]+") do
            kv = urlDecode(kv)
            for key, value in string.gmatch(kv, "(%S+)=(%S+)") do
                prop[key]=value
                cfg:writeline(key..'='..value)
                print(key.." == ".. value)
            end
        end
    end
    cfg:close()
    cfg=nil
    parse_props()
end
