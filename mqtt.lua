MQTT_json = '{ "idx" : 13, "nvalue": '
m = mqtt.Client('Sonoff', 120, 'mqtusr', 'Gerasimenkomqt')
function send_status(idx, value)
        if (idx == 50) then
            m:publish("domoticz/in", '{ "idx" : '..idx..', "svalue" : "'..value..'" }', 1, 0)
        else
        m:publish("domoticz/in", '{ "idx" : '..idx..', "nvalue" : '..value..'}', 1, 0)
        end
end

function do_broker_connect()
    --connecting to broker
    local status, err = pcall(function() m:connect("domoticz", 1883, 0, mqtt_connected, mqtt_connection_error)end)
    if status then
        if err~=nil then
        print("Error: " .. err.code)
        end
    end
end

function mqtt_offline(client)
   print("MQTT Offline")
   indicator("mqtt_connecting")
   tmr.create():alarm(5 * 1000, tmr.ALARM_SINGLE, do_broker_connect)
end

function mqtt_message_received(client, topic, data)
    print(topic .. ":")
    if data ~= nil then
        if data == "on" then
        set_relay(1)
        elseif data == "off"  then
        set_relay(0)
        end
    print(data)
    end
end

function mqtt_connected(client)
    print("MQTT Connected")
    indicator("ok")
    client:subscribe("relays/relay_1", 1, function(client) 
        print("Subscribe succsess")
        send_status(Relay_idx, Relay_status)
        
        end)
    
end

function mqtt_connection_error(client, reason)
   indicator("mqtt_connecting")
    print('MQTT error reason: '..reason)
    tmr.create():alarm(5 * 1000, tmr.ALARM_SINGLE, do_broker_connect)
end

--on connect to broker
m:on("connect", mqtt_connected)
--on broker offline
m:on("offline", mqtt_offline)
--on publish receive event
m:on("message", mqtt_message_received)
