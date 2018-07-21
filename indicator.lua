function indicator(status)
    print("indicator update " .. status)
    
    if(status == "wifi_connecting") then
        pwm.setup(LED_green, 200, 0); 
        duty = 1023
        step = 20
        dir = true
        pwm.setduty(LED_green, duty);
        TIMER_indicator:alarm(50, tmr.ALARM_AUTO, function()
            if dir then
                duty = duty - step
                if duty <= 500 then dir = false end
            else
                duty = duty + step
                if duty >= 1000 then dir = true end
            end
            pwm.setduty(LED_green, duty)
        end)
    elseif(status == "mqtt_connecting") then
        TIMER_indicator:alarm(250, tmr.ALARM_AUTO, function()
        if (gpio.read(LED_green)) == 0 then
            gpio.write(LED_green, gpio.HIGH)
            gpio.write(LED_red, gpio.LOW)
        elseif(gpio.read(LED_green)== 1) then
            gpio.write(LED_green, gpio.LOW)
            gpio.write(LED_red, gpio.HIGH)
        end
        end)

    elseif(status == "ok") then
       TIMER_indicator:stop()
       pwm.setduty(LED_green, 1023)
       pwm.stop(LED_green)
       gpio.write(LED_green, gpio.HIGH)
    end
end