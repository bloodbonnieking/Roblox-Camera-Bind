--!native

local CameraModule = {}
local RunService = game:GetService("RunService")
if not RunService:IsClient() then
	error("Module must be required on client.", 2)
end
local CurrentCamera = workspace.CurrentCamera
local plr = game.Players.LocalPlayer
local Connection



local function TweenCam(target)
	local ts = game:GetService("TweenService")
	local ti = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
	local tg = {CFrame = target.CFrame}
	local tc = ts:Create(CurrentCamera, ti, tg)
	tc:Play()
	tc.Completed:Wait()
end

local function Bind(target, performance)

	CurrentCamera.CameraType = Enum.CameraType.Scriptable


	if performance == false then
		Connection = RunService.RenderStepped:Connect(function()
			CurrentCamera.CFrame = target.CFrame
		end)

	else

		Connection = RunService.Heartbeat:Connect(function()
			CurrentCamera.CFrame = target.CFrame
		end)
	end
end

function CameraModule:BindCamera(Target: Part, Performance: boolean?, Tween: boolean?)

	if typeof(Target) ~= "Instance" and not Target:IsA("Part") then error(`BindCamera expects Target to be a Part, got {tostring(Target)}`, 2) end
	if typeof(Performance) ~= "boolean" then Performance = false end
	if typeof(Tween) ~= "boolean" then Tween = false end

	if Connection then
		Connection:Disconnect()
		Connection = nil
	end
	if not Tween then
		CurrentCamera.CFrame = Target.CFrame
	else
		TweenCam(Target)
	end
	Bind(Target, Performance)
end

function CameraModule:SetCameraToPart(Target: Part, Tween: boolean?)

	if typeof(Target) ~= "Instance" and not Target:IsA("Part") then error(`SetCameraToPart expects Target to be a Part, got {tostring(Target)}`, 2) end
	if typeof(Tween) ~= "boolean" then Tween = false end

	if Connection then
		Connection:Disconnect()
		Connection = nil
	end
	CurrentCamera.CameraType = Enum.CameraType.Scriptable
	if not Tween then
		CurrentCamera.CFrame = Target.CFrame
	else
		TweenCam(Target)
	end
end

function CameraModule:Unbind()
	if Connection then
		Connection:Disconnect()
		Connection = nil
	end

	CurrentCamera.CameraSubject = plr.Character.Humanoid
	CurrentCamera.CFrame = plr.Character.Head.CFrame
	CurrentCamera.CameraType = Enum.CameraType.Custom
end

return CameraModule