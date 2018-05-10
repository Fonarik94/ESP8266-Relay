function wifi_sta_config()
    local ssid, pass, host = "random", "", "Relay-ESP8266"
    if(prop.wifi_ssid ~= nil) then
        ssid = prop.wifi_ssid
    end
    if(prop.wifi_password ~= nil) then
        pass = prop.wifi_password
    end
    if(prop.host_name ~=nil) then
        host = prop.host_name
    end
    --wifi.setmode(wifi.STATION);
    wifi.sta.sethostname(host)
    wifi.sta.config({ssid = ssid, pwd = pass, save = true});
    wifi.sta.autoconnect(1);
    WIFI_tmr:alarm(10*1500, tmr.ALARM_SINGLE, function() wifi_start_ap() end)
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
        TIMER_connect:alarm(2000, tmr.ALARM_AUTO, wifi_connect) 
      else
            wifi.setmode(wifi.STATION);
            WIFI_tmr:stop()
            print(wifi.sta.getip())
            if(prop.mqtt_use == "on") then
                do_broker_connect()
            end    
            TIMER_connect:stop()
            indicator("ok")
    end
end

function wifi_start_ap()  

        wifi.setmode(wifi.STATIONAP, false)
        wifi.ap.setip({ip="10.1.1.1", netmask="255.255.255.0", gateway="10.1.1.1"})
        wifi.ap.dhcp.config({start = "10.1.1.10"})
        wifi.ap.dhcp.start()
        wifi.ap.config({ssid="NODE SETUP",auth=wifi.OPEN})
        print("AP Started")
        print(wifi.ap.getip())
end
