--Create Spacedust effects to help achieve sense of speed!
--Roblox API
local RunServices = game:GetService("RunService")

--Utility
local RNG = Random.new(tick())

--Instance
local Camera = game.Workspace.CurrentCamera
local Character --The source of velocity
local dustInstances = {}
local EffectUpdate --Connection of updateJob to HeartbeatEvent from RunServices

--Parameter
local NUMBER_OF_DUST = 16 --Default Set to 16
local SPEED_FACTOR = -0.25 --Negitave for opposite direction of the velocity

--Local Functions
local function UpdateMotion(dust, Character)
	dust.CFrame *= CFrame.new((Character.CFrame:VectorToObjectSpace(Character.AssemblyLinearVelocity)) * SPEED_FACTOR)
end

local function Respawn(dust)
	--The Area Bound for Respawning the particle
	local SpawnAreaBound = CFrame.new(
		--Preset for 16:9 AspectRatio
		Vector3.new(RNG:NextNumber(-36, 36),RNG:NextNumber(-20, 20),-30) * RNG:NextNumber(0.1, 8))
	--Offset the area by Camera CFrame
	local SpawnCFrame = Camera.CFrame * SpawnAreaBound
		
	dust.CFrame = SpawnCFrame
	dust.Trail:Clear()
end

local module = {}

function module:SetupSpacedust(newCharacter)
	--Initial folder for spacedustes
	if not workspace:FindFirstChild("Spacedust") then
		local newFolder = Instance.new("Folder")
		newFolder.Name = "Spacedust"
		newFolder.Parent = workspace
	end
	
	Character = newCharacter

	for i = 1, NUMBER_OF_DUST, 1 do
		local newDust = script.Assets.Dust:Clone()
		newDust.Parent = workspace.Spacedust
		Respawn(newDust)
		dustInstances[i] = newDust
	end

end

function module:UpdateJob()
	for i = 1, (#dustInstances), 1 do
		local dustPos = dustInstances[i].Position
		local vector, onScreen = CFrame:WorldToViewportPoint(dustPos)

		if (not onScreen) or vector.Z > 300 then
			Respawn(dustInstances[i])
		else
			UpdateMotion(dustInstances[i],Character)
		end
	end
end

function module:Start()
	EffectUpdate = RunServices.Heartbeat:Connect(function()
		self:Update()
	end)
end

function module:Stop()
	if EffectUpdate then
		EffectUpdate:Disconnect()
	end
	
	for i = 1, #dustInstances, 1 do
		dustInstances[i]:Destroy()
	end
end

return module
