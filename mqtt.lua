CLIENT_id = prop.mqtt_client_id
MQTT_usr = prop.mqtt_user
MQTT_pas = prop.mqtt_pass
MQTT_broker_ip = prop.mqtt_broker_ip
MQTT_broker_port =  prop.mqtt_broker_port
MQTT_topic = prop.mqtt_topic
IDX = prop.domoticz_idx
if(IDX~=nil) then MQTT_json = '{ "idx" : '.. IDX ..', "command": "udevice", "nvalue": ' end
m = mqtt.Client(CLIENT_id, 120, MQTT_usr, MQTT_pas)
m:lwt("/lwt", "offline", 0, 0)

function send_status()
    if not pcall(function() 
        m:publish("domoticz/in", MQTT_json .. LED_status ..'}', 0, 0) end)
    then
        TIMER_blink:alarm(100, tmr.ALARM_AUTO, blink) -- start blinking
        do_broker_connect()
        end
end

function do_broker_connect()
    --connecting to broker
    local status, err = pcall(function() m:connect(MQTT_broker_ip, MQTT_broker_port, 0, mqtt_connected, mqtt_connection_error)end)
    if status then
        if err~=nil then
        print("Error: " .. err.code)
        end
    end
end

function mqtt_offline(client)
   print("MQTT Offline")
   TIMER_blink:alarm(100, tmr.ALARM_AUTO, blink) -- start blinking
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
    TIMER_blink:stop()
    gpio.write(LED_pin, gpio.HIGH)
    client:subscribe(MQTT_topic, 0, function(client) print("Subscribe succsess") end)
    send_status()
    --TIMER_status:alarm(10*1000, tmr.ALARM_AUTO, function() send_status() end )
end

function mqtt_connection_error(client, reason)
    TIMER_blink:alarm(100, tmr.ALARM_AUTO, blink) -- start blinking
    print('MQTT error reason: '..reason)
    tmr.create():alarm(5 * 1000, tmr.ALARM_SINGLE, do_broker_connect)
end

--on connect to broker
m:on("connect", mqtt_connected)
--on broker offline
m:on("offline", mqtt_offline)
--on publish receive event
m:on("message", mqtt_message_received)
