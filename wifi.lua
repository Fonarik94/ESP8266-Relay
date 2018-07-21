function wifi_sta_config()
    wifi.setmode(wifi.STATION);
    wifi.sta.sethostname("Sonoff")
    wifi.sta.config({ssid = "Fonarik", pwd = "Gerasimenko09", save = true});
    wifi.sta.autoconnect(1);
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
           do_broker_connect()   
            TIMER_connect:stop()
            indicator("ok")
    end
end
