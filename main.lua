-- [Settings] --

-- BackgroundColour
bgRed = 46/255
bgGreen = 52/255
bgBlue = 64/255
bgAlpha = 100/100
modifyBGColour = true

-- Collisions
showCollision = true

-- Stats and Fonts
printStatistics = true
customFont = true

-- Custom Font
titleFontSize = 18
bodyFontSize = 15

-- Preload Common Assets --
assetsDirectory = "assets/"
imagesDirectory = assetsDirectory.."images/"
fontsDirectory = assetsDirectory.."fonts/"
librariesDirectory = assetsDirectory.."libraries/"
mapsDirectory = assetsDirectory.."maps/"
audioDirectory = assetsDirectory.."audio/"

-- Library Imports --
anim8 = require(librariesDirectory.."anim8")
love.graphics.setDefaultFilter("nearest", "nearest")

sti = require(librariesDirectory.."sti")
--gameMap = sti(mapsDirectory.."testmap.lua")

camera = require(librariesDirectory.."camera")
cam = camera()

wf = require(librariesDirectory.."windfield")
--world = wf.newWorld(0, 0)

-- Variables --
if customFont then
	getDPIScale = love.graphics.getDPIScale()
	sysInfoTitle = love.graphics.newFont(fontsDirectory.."VCR_OSD_MONO.ttf", titleFontSize, "normal", getDPIScale)
	sysInfoBody = love.graphics.newFont(fontsDirectory.."VCR_OSD_MONO.ttf", bodyFontSize, "normal", getDPIScale)
	love.graphics.setFont(sysInfoBody)
else
	getDPIScale = love.graphics.getDPIScale()
	sysInfoTitle = love.graphics.newFont(titleFontSize, "normal", getDPIScale)
	sysInfoBody = love.graphics.newFont(bodyFontSize, "normal", getDPIScale)
	love.graphics.setFont(sysInfoBody)
end

-- Custom Functions --
function printStats()
	if printStatistics then
		width, height = love.window.getMode()
		love.graphics.print("System Information:",sysInfoTitle,0,0)
		love.graphics.print("currentOS: "..love.system.getOS(),0,20)
		love.graphics.print("osPowerInfo: "..love.system.getPowerInfo(),0,35)
		love.graphics.print("osDate : "..os.date(),0,80)
		love.graphics.print("osTime : "..os.time(),0,95)
		love.graphics.print("cpuThreads: "..love.system.getProcessorCount(),0,50)
		love.graphics.print("cpuFrameTime: "..os.clock(),0,65)
		love.graphics.print("Resolution: "..width.." x "..height,0,110)
		love.graphics.print("CurrentFPS: "..tostring(love.timer.getFPS()),0,127)

		love.graphics.print("Cursor Information: ",sysInfoTitle,0,142)
		love.graphics.print("CursorPos : "..love.mouse.getPosition(),0,157)
	end
end

buttonHEIGHT = 64
local function newButton(text, fn)
	return {
		text = text,
		fn = fn,

		now = false,
		last = false
	}
end

local buttons = {}
local buttonFont = nil

local function buttonConfiguration()
	local wW = love.graphics.getWidth()
	local wH = love.graphics.getHeight()
	
	local buttonWidth = wW * (1/3)
	local margin = 16

	local totalHeight = (buttonHEIGHT + margin) * #buttons
	local cursorY = 0

	for i, button in ipairs(buttons) do
		button.last = button.now

		local bX = (wW * 0.5) - (buttonWidth * 0.5)
		local bY = (wH * 0.5) - (totalHeight * 0.5) + cursorY

		local color = {0.4, 0.4, 0.5, 1.0}

		local mX, mY = love.mouse.getPosition()

		local hot = mX > bX and mX < bX + buttonWidth and
					mY > bY and mY < bY + buttonHEIGHT

		if hot then
			color = {0.8, 0.8, 0.9, 1.0}
		end

		button.now = love.mouse.isDown(1)
		if button.now and not button.last and hot then
			button.fn()
		end

		love.graphics.setColor(unpack(color))
		love.graphics.rectangle(
			"fill", 
			bX,
			bY,
			buttonWidth,
			buttonHEIGHT
		)

		love.graphics.setColor(1, 1, 1, 1)

		local textW = buttonFont:getWidth(button.text)
		local textH = buttonFont:getHeight(button.text)
		love.graphics.print(
			button.text,
			buttonFont,
			(wW * 0.5) - textW * 0.5,
			bY + textH * 0.5
			)

		cursorY = cursorY + (buttonHEIGHT + margin)
	end
end

-- Base Functions --
function love.load()
	currentTitle = love.window.getTitle()
	love.window.setTitle(currentTitle.." - Title Screen")

	buttonFont = love.graphics.newFont(32)

	table.insert(buttons, newButton(
		"Start Game",
		function()
			print("Starting Game...")
			-- Clear canvas and show loading screen
		end))
	table.insert(buttons, newButton(
		"Load Game",
		function()
			print("Loading Game...")
			-- Clear canvas and show saves screen
		end))
	table.insert(buttons, newButton(
		"Settings",
		function()
			print("Opening Settings...")
			-- Clear canvas and show settings screen
		end))
	table.insert(buttons, newButton(
		"Exit",
		function()
			-- Clear canvas and show goodbye message, 
			-- than quit session
			love.event.quit(0)
		end))

end

function love.update(dt)
	-- Code Here
end

function love.draw()
	if modifyBGColour then
		love.graphics.setBackgroundColor(bgRed, bgGreen, bgBlue, bgAlpha)
	end

	-- Show Quick Info
	printStats()

	-- Insert Buttons
	buttonConfiguration()
end
