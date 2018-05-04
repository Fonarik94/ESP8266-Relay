LED_pin = 0 --on board red led
LED_status = 0 
BUTTON_pin = 3 --on board flash button
TIMER_blink = tmr.create();
TIMER_connect = tmr.create();
TIMER_status = tmr.create();
WIFI_tmr = tmr.create()
gpio.mode(LED_pin, gpio.OUTPUT)
gpio.mode(BUTTON_pin, gpio.INT)
dofile("http.lua");


function set_led(status)
    if status == 0 then
        gpio.write(LED_pin, gpio.HIGH)
        LED_status = 0
        elseif status==1 then
        gpio.write(LED_pin, gpio.LOW)
        LED_status = 1
    end
    send_status()    
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

function wifi_sta_config()
    wifi.sta.sethostname('Relay-ESP8266')
    wifi.setmode(wifi.STATION);
    wifi.sta.config({ssid = "Fonarik", pwd = "Gerasimenko09", save = true});
    wifi.sta.autoconnect(1);
    WIFI_tmr:alarm(10*1000, tmr.ALARM_SINGLE, function() wifi_start_ap() end)
    wifi.sta.connect();
    
end

function wifi_connect()

    if(wifi.sta.status()~=5) then
      if (wifi.sta.status()==0) then 
        print("Station iddle")
      elseif (wifi.sta.status()==1) then 
        print("Station connecting")
      elseif (wifi.sta.status()==2) then
        print("Station wrong password")
      elseif (wifi.sta.status()==3) then
        print("Station no AP found")
      elseif (wifi.sta.status()==4) then
        print("Station connect fail")
      end
      TIMER_connect:alarm(1000, tmr.ALARM_AUTO, wifi_connect) 
      else
            WIFI_tmr:stop()
            print(wifi.sta.getip())
           -- do_broker_connect()
            gpio.write(LED_pin, gpio.HIGH)
            TIMER_connect:stop()
    end
end

function wifi_start_ap()  
        wifi.setmode(wifi.STATIONAP, false)
        wifi.ap.dhcp.config({start = "10.1.1.100"})
        wifi.ap.dhcp.start()
        wifi.ap.config({ssid="NODE SETUP", pwd="12345678"})
        print("AP Started")
        print(wifi.ap.getip())
end

function initial_setup() 
    dofile('propParser.lua');
    if not parse_props() then
        wifi_start_ap()
        else
            wifi_sta_config()
            wifi_connect()
            if(prop.mqtt_use == "on") then               
                dofile("mqtt.lua");
            end
    end
end

initial_setup()
TIMER_blink:alarm(100, tmr.ALARM_AUTO, blink) -- start blinking

gpio.trig(BUTTON_pin, "up", button_released);
httpsrv();
