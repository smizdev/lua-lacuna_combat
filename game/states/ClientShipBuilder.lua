local game = require(select('1', ...):match(".-game%.")..'init')

--
-- Define class
--
local ClientShipBuilder = game.lib.upperclass:define("ClientShipBuilder", game.classes.Gamestate)

--
-- Holds a reference to our runtime which we need for various sub-systems
-- the runtime object is obtained through the enter() method
--
property : runtime {
    nil;
    get='public';
    set='private';
}

--
-- Returns the space scene
--
property : scene {
    nil;
    get='public';
    set='private';
    type='table';
}

--
-- Class COnstructor
--
function private:__construct()
    -- Create new scene
    self.scene = game.classes.SceneGraph()
    
    -- Create a blank ship
    local shipx, shipy = self.camera:worldCoords(love.graphics.getWidth()/2, love.graphics.getHeight()/2)
    local ship = game.entities.Ship(shipx, shipy)
    self.scene:appendChild(ship)
    
end

-- 
-- Gamestate Enter
--
function public:enter(RUNTIME)    
    self.runtime = RUNTIME
end

--
-- Gamestate update
--
function public:update(DT)
    if love.keyboard.isDown("left") then
        self.camera.x = self.camera.x - 150 * DT
    end
    if love.keyboard.isDown("right") then
        self.camera.x = self.camera.x + 150 * DT
    end
    if love.keyboard.isDown("up") then
        self.camera.y = self.camera.y - 150 * DT
    end
    if love.keyboard.isDown("down") then
        self.camera.y = self.camera.y + 150 * DT
    end 
end

--
-- Gamestate Draw
--
function public:draw()   
    self.camera:attach()
    
    -- Draw the ship principle grid position
    self:drawShipPrincipleGridPosition()  
    
    for x, _ in pairs(self.ship.hullBlocks) do
        for y, _ in pairs(self.ship.hullBlocks[x]) do
            local gridx, gridy = self.ship:getGridCoordinates(x, y)
            love.graphics.circle("fill", gridx or 0, gridy or 0, 5)
        end
    end
    
    self.camera:detach()  
    
    local gpx, gpy = self.ship:getGridPosition(self.camera:worldCoords(love.mouse.getX(), love.mouse.getY()))    
    love.graphics.print(gpx..":"..gpy, love.mouse.getX()+10, love.mouse.getY()+20)
    local gcx, gcy = self.ship:getGridCoordinates(gpx, gpy)
    love.graphics.print(gcx..":"..gcy, love.mouse.getX()+10, love.mouse.getY()+35)
    
    love.graphics.print(tostring(self.ship:checkHullGridPlacement(gpx, gpy)), 0, 0)
end

--
-- Draws the ship principle grid poisiotn
--
function public:drawShipPrincipleGridPosition()
    -- Draw the ship principle grid position
    local spgpx, spgpy = self.ship.principleGridPosition.x, self.ship.principleGridPosition.y
    love.graphics.rectangle("line", spgpx - game.BLOCK_WIDTH/2,  spgpy - game.BLOCK_HEIGHT/2, game.BLOCK_WIDTH, game.BLOCK_HEIGHT)    
end

--
-- Gamestate Keypressed
--
function public:keypressed(KEY, IS_REPEAT) 
    if KEY == '1' then
        self.ship.rotation = self.ship.rotation - math.rad(1)
    end
    
    if KEY == '2' then
        self.ship.rotation = self.ship.rotation + math.rad(1)
    end
end

--
-- Gamestate mousepressed
--
function public:mousepressed(X, T, BUTTON)
   if BUTTON == 'wu' then
        if self.camera.scale < 6 then
            self.camera.scale = self.camera.scale + 0.2
        end
   end
   
    if BUTTON == 'wd' then
        if self.camera.scale > .4 then
            self.camera.scale = self.camera.scale - 0.2
        end    
    end
end

--
-- Compile Class
--
return game.lib.upperclass:compile(ClientShipBuilder)