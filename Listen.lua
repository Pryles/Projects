--[[
	Credits: Pry#1826
	
	This is made for educational purposes only

	A demon recreation of the PlayerAdded / PlayerRemoving event(s)
]]--

local Services = setmetatable({}, {
	__index = function(self, Name)
		return rawset(self, Name, game:GetService(Name))[Name]
	end,
})

local Listen = {}

Listen.__index = Listen

Listen.New = function()
	local self = setmetatable({}, Listen)
	
	self.Connections = {}

	function self:Connect(cb)
		table.insert(self.Connections, cb)
	end

	function self:Fire(...)
		-- gotta wrap this in a coroutine so it doesn't yield
		for _, callbacks in ipairs(self.Connections) do
			callbacks(...)
		end
	end

	return self
end

Listen.PlayerAdded = Listen.New()
Listen.PlayerRemoved = Listen.New()

Services.Players.ChildAdded:Connect(function(Child)
	Listen.PlayerAdded:Fire(Child)
end)

Services.Players.ChildRemoved:Connect(function(Child)
	Listen.PlayerRemoved:Fire(Child)
end)

return Listen
