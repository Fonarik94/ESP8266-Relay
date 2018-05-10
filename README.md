<b>ESP8266-Relay</b><br>
This project can be used for control relay over wifi, mqtt, and web interface.
Also it can be used as custom firmware for wifi relay <b>Sonoff</b>.<br>
<b>How to setup</b><br>
For launch this app in ESP8266 MCU you first need to flash <a href="https://nodemcu.readthedocs.io/en/master/">Nodemcu</a> firmware with folowinging modules:
file,gpio,mqtt,net,node,pwm,sjson,tmr,uart,wifi. You need to <a href="https://nodemcu-build.com/">build</a> custom firmware.
In <b>init.lua</b> file, in few first rows, need set up correct pins. You need to use ESPlorer for upload files into flash memory of ESP8266.
Optional, after uploading lua files, you can compile it to *.lc, and change file names in <b>dofile</b> from <b>*.lua</b> to <b>*.lc</b>.
It can save about 10% of memory usage. Also, you can compress html files with <b>gzip</b>, and upload new file <b>*.html.gz</b> instead of <b>*.html</b> without any changes in code.<br>
<b>How to use</b><br>
After first launch you need to connect to WIFI netwotk called <b>NODE SETUP</b>, open page <a href="http://10.1.1.1">http://10.1.1.1</a> and click <b>Settings</b>.<br>
Then fill input fields with correct walues, click <b>Save</b>. Module will try to connect to wifi network, and mqtt server. If connection was success, led indicator will turn off. <br>
When device can't connect to wifi network for 20 seconds, NODE SETUP network will be launched automaticaly.<br>
In list of parameters you can find "Domoticz IDX". It value using with Domoticz home automation system.<br>
About indication:<br>
Device status can viewed with led indicator<br>
Fade in/out : wifi connecting, or wifi AP is launched;<br>
Fast blinking : connecting to mqtt broker;<br>
Off : connecting success;<br>

