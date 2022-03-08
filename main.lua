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

		--love.graphics.print("Character Information: ",sysInfoTitle,0,142)
		--love.graphics.print("CharPositionX: "..player.x,0,157)
		--love.graphics.print("CharPositionY: "..player.y,0,172)
		--love.graphics.print("CharSpeed: "..player.speed,0,187)
		--love.graphics.print("CharControl: ".."TO BE DETERMINED.",0,202)
		--love.graphics.print("Audio Control: ".."TO BE DETERMINED.",0,217)
	end
end

buttonHEIGHT = 64
local function newButton(text, fn)
	return {
		text = text,
		fn = fn,
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
		local bX = (wW * 0.5) - (buttonWidth * 0.5)
		local bY = (wH * 0.5) - (buttonHEIGHT * 0.5) + cursorY

		love.graphics.setColor(0.4, 0.4, 0.5, 1.0)
		love.graphics.rectangle(
			"fill", 
			--bX,
			--bY,
			(wW * 0.5) - (buttonWidth * 0.5),
			(wH * 0.5) - (totalHeight * 0.5)
				+ cursorY,
			buttonWidth,
			buttonHEIGHT
		)

		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.print(
			button.text,
			buttonFont,
			bX,
			bY
			)

		cursorY = cursorY + (buttonHEIGHT + margin)
	end
end

-- Base Functions --
function love.load()
	buttonFont = love.graphics.newFont(32)

	table.insert(buttons, newButton(
		"Start Game",
		function()
			print("Starting Game...")
		end))

	table.insert(buttons, newButton(
		"Load Game",
		function()
			print("Loading Game...")
		end))

		table.insert(buttons, newButton(
		"Settings",
		function()
			print("Opening Settings...")
		end))

		table.insert(buttons, newButton(
		"Exit",
		function()
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
