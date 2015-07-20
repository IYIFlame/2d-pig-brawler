-- make pigs and projectiles bounce off of screen walls >:D
require "pigeh_unit_locomotion"
require "utils"
io.stdout:setvbuf("no")

function love.load()
	love.physics.setMeter(32)
	world = love.physics.newWorld(0, 9.81*32, true)

	Tileset = love.graphics.newImage( 'images/tileset.png' )
	tilesetW, tilesetH = Tileset:getWidth(), Tileset:getHeight()
	background = Utils.getNewQuad( 0, 0, 256, 256 )
	backgroundW, backgroundH = 256, 256

	pigeh = Pigeh_unit_locomotion:new()
	pigeh:init( Tileset, tilesetW, tilesetH )
end

function love.update(dt)
	pigeh:update( dt )
end

function love.keypressed(key, isrepeat)
	if key == "w" then
		pigeh:jump()
	elseif key == " " then
		pigeh:throw_bacon()
	elseif key == "d" then
		pigeh:turn( 1 )
	elseif key == "a" then
		pigeh:turn( -1 )
	elseif key == "escape" then
		love.event.quit()
	end
end

function love.joystickpressed( joystick, button )
	if button == 2 then
		pigeh:jump()
	elseif button == 1 then
		pigeh:throw_bacon()
	elseif button == 4 then
		pigeh:turn( 1 )
	elseif button == 3 then
		pigeh:turn( -1 )
	elseif button == 14 then
		love.event.quit()
	end 
	print(button)
end

function love.draw()
	for i = 1, love.window.getWidth() / backgroundW do
		for j = 1, love.window.getHeight() / backgroundH do
			love.graphics.draw(Tileset, background, (i-1)*backgroundW, (j-1)*backgroundH )
		end
	end

	pigeh:draw()
end