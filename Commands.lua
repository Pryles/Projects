--[[
  @Author: Pry

  @Roblox: iPryle
  @Note: This is made for education purposes only.
]]--

--[[
  Type: ModuleScript
  Path: StarterPlayer.StarterPlayerScripts
]]

local Players = game:GetService("Players")

local Commands = {
	List = {}
}

Commands.__index = Commands

type Command<string> = {["Name"]: string, ["Description"]: string, ["Command"]: string, ["Callback"]: (any?) -> any?}

function Commands.new(Command: Command<string>)
	local self = setmetatable({
		["Name"] = Command.Name,
		["Description"] = Command.Description,
		["Command"] = Command.Command,
		["Callback"] = Command.Callback
	}, Commands)
	
	Commands.List[self.Command] = self
	
	return self
end

function Commands:Call(...)
	self["Callback"](...)
end

Commands.new({Name = "Disconnect", Description = "Disconnects a Client from the Server.", Command = "!Disconnect", Callback = function(Data, TextChannel)
	local Text = Data.Text

	local Split = string.split(Text, " ")	
	local Client = Split[2]

	if (Players:FindFirstChild(Client) ~= nil) then
		return Players[Client]:Kick("Disconnected from the Server.")
	else
		TextChannel:DisplaySystemMessage("Client not found, retry again.")
	end
end,})


return Commands

--[[
  Type: LocalScript
  Path: StarterPlayer.StarterPlayerScripts
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local Players = game:GetService("Players")

local TextChannel = TextChatService.TextChannel

local Modules = ReplicatedStorage.Modules
local Module = require(Modules.Commands)

TextChatService.OnIncomingMessage = function(Data)
	local Split = string.split(Data.Text, " ")
	
	for Command, Metatable in Module.List do	
		if (string.lower(Command) ~= string.lower(Split[1])) then
			continue
		end
		
		Metatable:Call(Data, TextChannel)
	end
end
