if(prop.domoticz_idx~=nil) then MQTT_json = '{ "idx" : '.. prop.domoticz_idx ..', "command": "udevice", "nvalue": ' end
m = mqtt.Client(prop.mqtt_client_id, 120, prop.mqtt_user, prop.mqtt_pass)
m:lwt("/lwt", "offline", 0, 0)

function send_status()
    if not pcall(function() 
            m:publish("domoticz/in", MQTT_json .. LED_status ..'}', 0, 0) 
            m:publish(prop.mqtt_topic, LED_status,0,0)
        end)
    then
        indicator("mqtt_connecting")
        do_broker_connect()
        end
end

function do_broker_connect()
    --connecting to broker
    local status, err = pcall(function() m:connect(prop.mqtt_broker_ip, prop.mqtt_broker_port, 0, mqtt_connected, mqtt_connection_error)end)
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
        set_led(1)
        elseif data == "off"  then
        set_led(0)
        end
    print(data)
    end
end

function mqtt_connected(client)
    print("MQTT Connected")
    indicator("ok")
    gpio.write(LED_pin, gpio.HIGH)
    client:subscribe(prop.mqtt_topic, 0, function(client) print("Subscribe succsess") end)
    send_status()
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
