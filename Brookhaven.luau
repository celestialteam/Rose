local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local RFWindow = Rayfield:CreateWindow({
   Name = "Rosé [Brookhaven] DEV",
   Icon = 0,
   LoadingTitle = "Rosé",
   LoadingSubtitle = "Brookhaven",
   ShowText = "Rayfield",
   Theme = "Default",

   ToggleUIKeybind = "K",

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,

   ConfigurationSaving = {
      Enabled = true,
      FolderName = "Roseff",
      FileName = "Brookhaven"
   },
   KeySystem = false
})

local Tabs = {
    ["Player"] = RFWindow:CreateTab("Player", 4483362458),
    ["Players"] = RFWindow:CreateTab("Players", 4483362458)
}

-- services
local Players = game:GetService("Players")

local LPlayer = Players.LocalPlayer

do -- Player
    Tabs.Player:CreateSlider({
        Name = "Walk Speed",
        Range = {8, 100},
        Increment = 4,
        Suffix = "",
        CurrentValue = 16,
        Flag = "PlayerSliderWalkSpeed", 
        Callback = function(v)
            local char = LPlayer.Character
            
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                hum.WalkSpeed = v
            end
        end,
    })

    Tabs.Player:CreateSlider({
        Name = "Jump Power",
        Range = {50, 100},
        Increment = 3,
        Suffix = "",
        CurrentValue = 50,
        Flag = "PlayerSliderJumpPower", 
        Callback = function(v)
            local char = LPlayer.Character
            
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                hum.UseJumpPower = true
                hum.JumpPower = v
            end
        end,
    })
end

do -- Players
    local player: Player = nil
    local PlayerDropdown = Tabs.Players:CreateDropdown({
        Name = "Player",
        Options = {"___"},
        CurrentOption = {"___"},
        MultipleOptions = false,
        Callback = function(p)p=p[1]
            player = Players:FindFirstChild(p) or p
        end
    })

    Tabs.Players:CreateSection("Actions")

    function Bring(player: Player, pos: CFrame)
        if not LPlayer.Character or not player or not player.Character then return end
        local couch = LPlayer.Backpack:FindFirstChild("Couch")

        if not couch then
            LPlayer.Character:PivotTo(CFrame.new(-86, 19, -129))
            repeat task.wait() until LPlayer.Character.Humanoid.Sit == true
            couch = LPlayer.Backpack:FindFirstChild("Couch")
        end

        if couch then
            local original: CFrame = player.Character:GetPivot()

            couch.Parent = LPlayer.Character
            repeat 
                LPlayer.Character:PivotTo(player.Character:GetPivot() * CFrame.new(0, -5, 0))
                task.wait() 
            until player.Character:FindFirstChildOfClass("Humanoid").Sit == true
            LPlayer.Character:PivotTo(pos)
            task.wait(1)
            couch.Parent = LPlayer.Backpack
            LPlayer.Character.HumanoidRootPart.Anchored = true
            task.wait(.5)
            LPlayer.Character.HumanoidRootPart.Anchored = false
            LPlayer.Character:PivotTo(original)
        end
    end

    local Actions = {
        Kill = function(player: Player)
            Bring(player, CFrame.new(1265, -320, 9147))
        end,
        Jail = function(player: Player)
            Bring(player, CFrame.new(-17, -9, 5))
        end,
        Bring = function(player: Player)
            if not LPlayer.Character then return end
            Bring(player, LPlayer.Character:GetPivot())
        end,
        ["Bring (null zone)"] = function(player: Player)
            if not LPlayer.Character then return end
            Bring(player, CFrame.new(1e9, 1e9, 1e9))
        end,
        ["Goto"] = function(player: Player)
            if not player or not player.Character or not LPlayer.Character then return end
            LPlayer.Character:PivotTo(player.Character:GetPivot())
        end
    }


    for name, callback in Actions do
        Tabs.Players:CreateButton({
            Name = name,
            Callback = function()
                if player == "[ Everyone ]" then
                    for _, p: Player in Players:GetPlayers() do
                        if p.Character and p.Name ~= LPlayer.Name then
                            callback(p)
                        end
                    end
                else
                    callback(player)
                end
            end
        })
    end

    function ref()
        local players = {"[ Everyone ]"}
        for i, v in Players:GetPlayers() do if v.Name == LPlayer.Name then continue end table.insert(players, v.Name) end
        PlayerDropdown:Refresh(players)
    end

    ref()
    Players.PlayerAdded:Connect(ref)
    Players.PlayerRemoving:Connect(ref)
end
