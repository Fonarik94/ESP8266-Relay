
function httpsrv()
dofile('httpServer.lc');
httpServer:listen(80);
httpServer:use('/', function(req, res)
    if(req.query.set == 'on')then
        set_led(1);
    elseif(req.query.set == 'off')then
        set_led(0);
    end
    res:sendFile('index.html')
    collectgarbage()
    end)
    
    httpServer:use('/status', function(req, res)
        res:send(LED_status);
        collectgarbage()
    end)

    httpServer:use('/settings', function(req, res)
        if(req.method == "GET") then
            res:sendFile('settings.html')
        end
        collectgarbage()
    end)
    
    httpServer:use('/settings.json', function(req, res)
        res:type('application/json; charset=UTF-8')
        local json=sjson.encoder(prop):read()
        res:send(json)
        json = nil
        collectgarbage()
    end)
    
    httpServer:use('/save', function(req, res)
        local result = res:redirect('/settings')
        print(result)
        local body=string.gsub(req.source, ".+[\n+]", "")
        
        parse_body(body)
        body = nil
            collectgarbage()
        end)

    httpServer:use('/system', function(req, res)
        if(req.method == "POST") then
            local body=string.gsub(req.source, ".+[\n+]", "")
            if(body == "system_action=reboot") then
                res:send("Device restarting...")
                node.restart()
                elseif(body == "system_action=factory_reset") then
                    res:send("Factory reset ok")
                    file.remove("config.prop")
                    prop = nil
                    initial_setup()
                end
         end
         end)
end
