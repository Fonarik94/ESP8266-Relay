<b>ESP8266-Relay</b><br>
This project can be used for control relay over with mqtt over wifi with Domoticz home automation system.
As extra feature, it can periodicly send temperature data from DS18B20 sensor to Domoticz.
Also it can be used as custom firmware for wifi relay <b>Sonoff Basic</b>.<br>
<b>How to setup</b><br>
For launch this app in ESP8266 MCU you first need to flash <a href="https://nodemcu.readthedocs.io/en/master/">Nodemcu</a> firmware with folowinging modules:
file,gpio,mqtt,net,node,pwm,tmr,uart,wifi. You need to <a href="https://nodemcu-build.com/">build</a> custom firmware.
In <b>init.lua</b> file, in few first rows, need set up correct pins. You need to use ESPlorer for upload files into flash memory of ESP8266.
Optional, after uploading lua files, you can compile it to *.lc, and change file names in <b>dofile</b> section from <b>*.lua</b> to <b>*.lc</b>.
It can save about 10% of memory usage.
<b>How to use</b><br>
After launch, device will connect to wifi network and MQTT brocker. Led indicatror will blink smoothly while wifi connecting, and fast blink while MQTT connecting.<br>
About indication:<br>
Device status can viewed with led indicator<br>
Fade in/out : wifi connecting;<br>
Fast blinking : connecting to mqtt broker;<br>
Off : connecting success;<br>
