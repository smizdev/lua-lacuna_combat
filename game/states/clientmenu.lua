local game = require(select('1', ...):match(".-game%.")..'init')

--
-- Define class
--
local ClientMenu = game.lib.upperclass:define("ClientMenu", game.classes.Gamestate)

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
-- Class Constructor
--
function private:__construct()    
end

function public:enter(RUNTIME)    
    self.runtime = RUNTIME
end

function public:draw()
    love.graphics.print("-=Client Menu=-", 0, 0)    
    love.graphics.print("1.) Connect To Server", 0, 15)    
    love.graphics.print("2.) Ship Builder", 0, 30)    
end

function public:keypressed(KEY, IS_REPEAT)     
    if KEY == "1" then
        self.runtime.gamestateManager:push(self.runtime.gamestates.clientLobby, self.runtime, "127.0.0.1", 6000)
    end
    
    if KEY == "2" then
        self.runtime.gamestateManager:push(self.runtime.gamestates.clientShipBuilder, self.runtime)
    end
end

--
-- Compile class
--
return game.lib.upperclass:compile(ClientMenu)