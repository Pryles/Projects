local Services = setmetatable({}, {
	__index = function(self, Name)
		return rawset(self, Name, game:GetService(Name))[Name]
	end,
})

local Listen = require(script.Listen)

local Values = {
	{"Coins", "IntValue", 15},
	{"Gems", "IntValue", 0}
}

local function PlayerAdded(Client: Player & {any})
	warn(`Client {Client.DisplayName} successfully added`)
	
	local Leaderboard = Instance.new("Folder", Client)
	Leaderboard.Name = "leaderstats"
	
	local Data = Listen.Load(Client)
	
	for Index, Value in Values do
		local Individual = Instance.new(Value[2], Leaderboard)
		Individual.Name = Value[1]
		Individual.Value = (Data ~= nil and Data[Individual.Name]) or Value[3]
	end
end

local function PlayerRemoved(Client: Player & {[any]: any})
	warn(`Client {Client.DisplayName} successfully removed`)
	
	local Individual = {}
	
	for _, Value in Client.leaderstats:GetChildren() do
		Individual[Value.Name] = Value.Value
	end 
	
	Listen.Save(Client, Individual)
end

local function BindToClose()
	for _, Player in Services.Players:GetPlayers() do
		local Individual = {}
		
		for _, Value in Player.leaderstats:GetChildren() do
			Individual[Value.Name] = Value.Value
		end
		
		Listen.Save(Player, Individual)
	end
end

Listen.PlayerAdded:Connect(PlayerAdded)
Listen.PlayerRemoved:Connect(PlayerRemoved)
