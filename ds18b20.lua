function send_temp()
ds18b20.setup(sensor_pin)
    ds18b20.read(
        function(ind,rom,res,temp,tdec,par)
            send_status(Temp_idx, temp)
        end,{})
end