---
-- @description Shows how to read 8 GPIO pins/buttons via I2C with the MCP23008 I/O expander.
-- Tested on NodeMCU 0.9.5 build 20150213. 
-- Original work 
--@circuit
--  Connect GPIO0 of the ESP8266-01 module to the SCL pin of the MCP23017. 
--  Connect GPIO2 of the ESP8266-01 module to the SDA pin of the MCP23017.
--  Use 3.3V for VCC.
--  Connect switches or buttons to the GPIOs of the MCP23008 and GND.
--  Connect two 4.7k pull-up resistors on SDA and SCL
--  We will enable the internal pull up resistors for the GPIOS of the MCP23008.
-- @author Miguel (AllAboutEE)
--      GitHub: https://github.com/AllAboutEE 
--      YouTube: https://www.youtube.com/user/AllAboutEE
--      Website: http://AllAboutEE.com
--
-- Modify for mcp23017
-- https://github.com/bigjohnson/esp8266-mcp23017-lua-module/new/master
---------------------------------------------------------------------------------------------

require ("mcp23017")

-- ESP-01 GPIO Mapping as per GPIO Table in https://github.com/nodemcu/nodemcu-firmware
gpio0, gpio2 = 3, 4

-- Setup the MCP23017
mcp23017.begin(0x0,gpio2,gpio0,i2c.SLOW)

mcp23017.writeIODIRB(0xff)
mcp23017.writeGPPUB(0xff)

---
-- @name showButtons
-- @description Shows the state of each GPIO pin
-- @return void
---------------------------------------------------------
function showButtons()

    local gpio = mcp23017.readGPIO() -- read the GPIO/buttons states

    -- get/extract the state of one pin at a time
    for pin=0,7 do

        local pinState = bit.band(bit.rshift(gpio,pin),0x1) -- extract one pin state

        -- change to string state (HIGH, LOW) instead of 1 or 0 respectively
        if(pinState == mcp23017.HIGH) then
            pinState = "HIGH"
        else
            pinState = "LOW"
        end

        print("Pin ".. pin .. ": ".. pinState)
    end
    print("\r\n")
end

tmr.alarm(0,2000,1,showButtons) -- run showButtons() every 2 seconds



