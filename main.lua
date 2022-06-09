-- [Settings] --

-- BackgroundColour
bgRed = 46/255
bgGreen = 52/255
bgBlue = 64/255
bgAlpha = 100/100
modifyBGColour = true

-- Stats and Fonts
printStatistics = true
printDebugs = true
customFont = true

-- Custom Font
titleFontSize = 20
bodyFontSize = 15

-- Preload Common Assets --
assetsDirectory = "assets/"
imagesDirectory = assetsDirectory.."images/"
fontsDirectory = assetsDirectory.."fonts/"
librariesDirectory = assetsDirectory.."libraries/"
mapsDirectory = assetsDirectory.."maps/"
audioDirectory = assetsDirectory.."audio/"

-- Library Imports --
tween = require(librariesDirectory.."tween")

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

images = {}
images.logo = love.graphics.newImage(imagesDirectory.."totallyCoolBump.png")
logoWidth = images.logo:getWidth()
logoHeight = images.logo:getHeight()

sounds = {}
sounds.click = love.audio.newSource(audioDirectory.."ui/".."click.wav", "static")
sounds.titleBGM = love.audio.newSource(audioDirectory.."bgms/".."title.mp3", "stream")
sounds.titleBGM:setLooping(true)
sounds.titleBGM:play()

currentTitle = love.window.getTitle()
states = {}
states["Menu"] = Menu
-- More menu subCode here
states["Start"] = Start
-- More start subCode here
states["Saves"] = Saves
-- More save subCode here
states["Settings"] = Settings
-- More settings subCode here
states["Exit"] = Exit
-- More exit subCode here
currentState = Menu

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
local buttonClicked = false

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
	if currentState == Menu then
		love.window.setTitle(currentTitle.." / Title Screen")

		buttonFont = love.graphics.newFont(32)

		table.insert(buttons, newButton(
			"Start Game",
			function()
				if not buttonClicked then
					buttonClicked = true
					if printDebugs then
						print("Starting Game...")
					end
					-- Tweening stuff before current state change!
					tween(4, nil, {y=1000}, 'linear')
					currentState = Start
					sounds.click:play()
					-- Clear canvas and show loading screen
				end
			end))
		table.insert(buttons, newButton(
			"Load Game",
			function()
				if not buttonClicked then
					buttonClicked = true
					if printDebugs then
						print("Loading Game...")
					end
					currentState = Saves
					sounds.click:play()
					-- Clear canvas and show saves screen
				end
			end))
		table.insert(buttons, newButton(
			"Settings",
			function()
				if not buttonClicked then
				buttonClicked = true
				if printDebugs then
					print("Opening Settings...")
				end
				currentState = Settings
				sounds.click:play()
				-- Clear canvas and show settings screen
				end
			end))
		table.insert(buttons, newButton(
			"Exit",
			function()
			if not buttonClicked then
				-- Clear canvas and show goodbye message, 
				-- than quit session
				buttonClicked = true
				if printDebugs then
					print("Closing Game...")
				end
				currentState = Exit
				sounds.click:play()
				love.event.quit(0)
			end
		end))
	elseif currentState	== Saves then
		table.insert(buttons, newButton(
			"Exit",
			function()
			if not buttonClicked then
				buttonClicked = true
				if printDebugs then
					print("Going back to Menu...")
				end
				currentState = Menu
				sounds.click:play()
				love.event.quit(0)
			end
		end))
	end
end

function love.update(dt)
	if states[currentState] ~= nil then
		states[currentState]:update(dt)
	end
end

function love.draw()
	if modifyBGColour then
		love.graphics.setBackgroundColor(bgRed, bgGreen, bgBlue, bgAlpha)
	end

	-- Show Quick Info
	printStats()

	-- Draw Images
	love.graphics.draw(images.logo, width / 4, height / 4) -- change size and positioning please

	-- Insert Buttons
	buttonConfiguration()
end
