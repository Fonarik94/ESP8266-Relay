LED_pin = 0 --on board red led
LED_indicator = 4 --indicator pin
LED_status = 0 
BUTTON_pin = 3 --on board flash button
TIMER_blink = tmr.create();
TIMER_connect = tmr.create();
TIMER_status = tmr.create();
TIMER_indicator = tmr.create();
WIFI_tmr = tmr.create()
gpio.write(LED_pin, gpio.HIGH)
gpio.mode(LED_pin, gpio.OUTPUT)
gpio.mode(LED_indicator, gpio.OUTPUT)
gpio.mode(BUTTON_pin, gpio.INT)
dofile("http.lua");
dofile("wifi.lua");
dofile('propParser.lua');

function indicator(status)
    print("indicator update " .. status)
    
    if(status == "wifi_connecting") then
        pwm.setup(LED_indicator, 200, 0); 
        duty = 1023
        step = 20
        dir = true
        pwm.setduty(LED_indicator, duty);
        TIMER_indicator:alarm(50, tmr.ALARM_AUTO, function()
            if dir then
                duty = duty - step
                if duty <= 500 then dir = false end
            else
                duty = duty + step
                if duty >= 1000 then dir = true end
            end
            pwm.setduty(LED_indicator, duty)
        end)
    elseif(status == "mqtt_connecting") then
        TIMER_indicator:alarm(250, tmr.ALARM_AUTO, function()
        if (gpio.read(LED_indicator)) == 0 then
            gpio.write(LED_indicator, gpio.HIGH)
        elseif(gpio.read(LED_indicator)== 1) then
            gpio.write(LED_indicator, gpio.LOW)
        end
        end)

    elseif(status == "ok") then
       TIMER_indicator:stop()
       pwm.setduty(LED_indicator, 1023)
       pwm.stop(LED_indicator)
       gpio.write(LED_indicator, gpio.HIGH)
    end
end

function set_led(status)
    if status == 0 then
        gpio.write(LED_pin, gpio.HIGH)
        LED_status = 0
        elseif status==1 then
        gpio.write(LED_pin, gpio.LOW)
        LED_status = 1
    end
    if(prop.mqtt_use == "on") then 
        send_status()
    end    
end 

function button_released(level)
    print("level: " .. level)
    if LED_status == 0 then
        set_led(1) 
        elseif LED_status == 1 then
        set_led(0)
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
indicator("wifi_connecting")
    if not parse_props() then
        wifi_start_ap()
        else
            if(prop.mqtt_use == "on") then               
                dofile("mqtt.lua");
            end
        wifi_sta_config()
        wifi_connect()
    end
end

initial_setup()
--TIMER_blink:alarm(100, tmr.ALARM_AUTO, blink) -- start blinking

gpio.trig(BUTTON_pin, "up", button_released);
httpsrv();
