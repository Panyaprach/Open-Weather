local json = require("json")
local widget = require("widget")
local cx, cy, sunriseTime, sunsetTime
local name, temp, main, desc, icon
local resp, imgIcon, proviceId, id, allPlace
local background, date, currentTime
local tab , l_temp, h_temp, hum, pressu, bgIdex

proviceId = {"1151254","1153671","1609350","2643743","1835848","3530597","4219762","4104031","4125402"}
id = 1 
--[[
local function changeBg( event )
	bgIdex = (bgIdex % 6) +1
	if event.phase == "ended" then
	print (bgIdex.."bg.jpg")
		if background then
			background:removeSelf()
			background = nil
		end
		background = display.newImage("icon/"..bgIdex.."bg.jpg", cx, cy)
		background.alpha = 0.8
	end
end
]]
local function auTo_Time( )
	currentTime.text = os.date("%H:%M")
end
local function networkResponse( event )
	if not event.isError then
		resp = json.decode(event.response)
		name.text = resp["name"]
		temp.text = resp["main"]["temp"].."°C"
		main.text = resp["weather"][1]["main"]
		desc.text = resp["weather"][1]["description"]
		l_temp.text = "L : "..resp["main"]["temp_min"].." °C"
		h_temp.text = "H : "..resp["main"]["temp_max"].." °C"
		icon = resp["weather"][1]["icon"]
		hum.text = "Humidity : "..resp["main"]["humidity"]
		pressu.text = "Pressure : "..resp["main"]["pressure"]
		local pos_x = 0
		if icon == "01n" or icon == "01d" then
			pos_x = 15
		end
		if imgIcon then
			imgIcon:removeSelf()
			imgIcon = nil
		end
		imgIcon = display.newImage("icon/"..icon..".png", cx - pos_x, cy - 95)
		imgIcon.xScale = 1.3
		imgIcon.yScale = 1.3
	end
end

local function loadWeather()
	local LoadId = proviceId[id]
	network.request(
	"http://api.openweathermap.org/data/2.5/weather?id="..LoadId.."&appid=ce7e84f7f44f4182839513d2fb4fa9f7&units=metric",
	"GET",
	networkResponse
	)
end

local function nameListener( event )
	if event.phase == "ended" then
		id = (id % #proviceId) +1 --#porviceId = member in array proviceId
		loadWeather()
	end
end

display.setDefault("background",0,0,0)
bgIdex = 1
cx = display.contentCenterX
cy = display.contentCenterY
background = display.newImage("icon/1bg.jpg", cx, cy)
background.alpha = 0.8
tab = display.newRect(cx,-30,display.contentWidth,30)
tab:setFillColor(0,0,0,.75)
display.newText("10%", cx+65 , -30, "Kristen ITC", 15)
local bat = display.newImage("icon/bate.png",cx+100, -30)
bat.xScale = 0.9
bat.yScale = 0.9
local sig = display.newImage("icon/Signal.png",cx+35, -32)
sig.xScale = 0.75
sig.yScale = 0.75
currentTime = display.newText(""..os.date("%H:%M"),cx+138, -30,"Kristen ITC",15)
--display.newImage("icon/Sun.png",cx,cy)
name = display.newText("Place",cx, 50, "Kristen ITC",40)
temp = display.newText("Temp",cx - 80, cy + 110, "Kristen ITC",30)
main = display.newText("Main",cx, cy + 20, "Kristen ITC",30)
desc = display.newText("Desc",cx, 300, "Kristen ITC",18)
l_temp = display.newText("L : ",cx - 80,cy + 140, "Kristen ITC", 15)
h_temp = display.newText("H : ",cx - 80,cy + 160, "Kristen ITC", 15)
hum = display.newText("Humidity : ",cx + 80,cy + 150, "Kristen ITC", 15)
pressu = display.newText("Pressure : ",cx + 80,cy + 120, "Kristen ITC", 15)
--name:addEventListener("touch", nameListener)

local btn = widget.newButton({
	x = cx,y = cy+220,
	width = 70 , height = 30,
	shape = "roundedRect",
	fillColor = {default={0,0,0,0.4},over={0,0,0,0.7}},
	strokeColor = { default={1,1,1}, over={0,0,0,0.5} },
    strokeWidth = 2, cornerRadius = 10,
	label = "Change" , font =  "Kristen ITC", fontSize = 15,
	labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
	onEvent = nameListener
})
--[[local btnBg = widget.newButton({
	x = cx-100,y = cy+220,
	width = 70 , height = 30,
	shape = "roundedRect",
	fillColor = {default={0,0,0,0.4},over={0,0,0,0.7}},
	strokeColor = { default={1,1,1}, over={0,0,0,0.5} },
    strokeWidth = 2, cornerRadius = 10,
	label = "Theme" , font =  "Kristen ITC", fontSize = 15,
	labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
	onEvent = changeBg
})--]]
timer.performWithDelay(100, auTo_Time, 0)
loadWeather()
