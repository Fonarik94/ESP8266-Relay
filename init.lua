node.setcpufreq(node.CPU160MHZ);
Relay_pin = 6 --GPIO 12
LED_green = 7 --GPIO 13
LED_red = 2 --GPIO4
sensor_pin = 5
ds18b20.setup(sensor_pin)
Relay_status = 0 
Relay_idx = 13
Temp_idx = 50
BUTTON_pin = 3
TIMER_status = tmr.create();
--TIMER_blink = tmr.create();
TIMER_connect = tmr.create();
TIMER_indicator = tmr.create();
WIFI_tmr = tmr.create()
gpio.write(Relay_pin, gpio.LOW)
gpio.mode(Relay_pin, gpio.OUTPUT)
gpio.mode(LED_green, gpio.OUTPUT)
gpio.mode(BUTTON_pin, gpio.INT)
gpio.write(LED_red, gpio.HIGH)
gpio.mode(LED_red, gpio.OUTPUT)


function set_relay(status)
    if status == 0 then
        gpio.write(Relay_pin, gpio.LOW)
        gpio.write(LED_red, gpio.HIGH)
        Relay_status = 0
        elseif status == 1 then
        gpio.write(Relay_pin, gpio.HIGH)
        gpio.write(LED_red, gpio.LOW)
        Relay_status = 1
    end 
        send_status(Relay_idx, Relay_status)
end
function button_released(level)
    print("level: " .. level)
    if Relay_status == 0 then
        set_relay(1) 
        elseif Relay_status == 1 then
        set_relay(0)
        end
end
function blink()
    if gpio.read(LED_pin)==0 then
       gpio.write(LED_pin, gpio.HIGH)
       else 
        gpio.write(LED_pin, gpio.LOW)
    end
end


function initial_setup() 
    dofile("indicator.lc")
    indicator("wifi_connecting")
    dofile("wifi.lc")
    wifi_sta_config()
    wifi_connect()
    dofile("mqtt.lc")

    TIMER_status:alarm(3000, tmr.ALARM_AUTO, function() dofile("ds18b20.lc"); send_temp(); end)
end

initial_setup()

gpio.trig(BUTTON_pin, "up", button_released)
