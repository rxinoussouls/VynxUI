--- VideoFrame is not working with custom video on exploits

local Creator = require("../modules/Creator")
local New = Creator.New

local Element = {}

local function ParseAspectRatio(aspectRatio)
    if type(aspectRatio) == "string" then
        local width, height = aspectRatio:match("(%d+):(%d+)")
        if width and height then
            return tonumber(width) / tonumber(height)
        end
    elseif type(aspectRatio) == "number" then
        return aspectRatio
    end
    return nil
end


function Element:New(Config)
    local VideoModule = {
        __type = "Video",
        Video = Config.Video or "",
        AspectRatio = Config.AspectRatio or "16:9",
        Radius = Config.Radius or Config.Window.ElementConfig.UICorner,
        ElementFrame = nil,
    }
    
    local MainVideo
    
    if VideoModule.Video then
        local BGVideo
        if string.find(VideoModule.Video, "http") then
            local folder = Config.Window.Folder or "Temp"
            if makefolder and isfolder then
                if not isfolder(folder) then
                    makefolder(folder)
                end
                if not isfolder(folder .. "/assets") then
                    makefolder(folder .. "/assets")
                end
            end
            local videoPath = folder .. "/assets/." .. Creator.SanitizeFilename(VideoModule.Video) .. ".webm"
            if not isfile or not isfile(videoPath) then
                local success, result = pcall(function()
                    local response = game.HttpGet and game:HttpGet(VideoModule.Video) or nil
                    if not response and Creator.Request then
                        local requestResponse = Creator.Request({
                            Url = VideoModule.Video,
                            Method = "GET",
                            Headers = { ["User-Agent"] = "Roblox/Exploit" },
                        })
                        response = requestResponse and requestResponse.Body
                    end
                    if response and writefile then
                        writefile(videoPath, response)
                    end
                end)
                if not success then
                    warn("[ Window.Background ] Failed to download video: " .. tostring(result))
                    return
                end
            end
            
            local success, customAsset = pcall(function()
                return typeof(getcustomasset) == "function" and getcustomasset(videoPath) or videoPath
            end)
            if not success then
                warn("[ WindUI.Video ] Failed to load custom asset: " .. tostring(customAsset))
            end
            BGVideo = customAsset
        else
            BGVideo = VideoModule.Video
        end
        
        MainVideo = New("VideoFrame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1,0,1,0),
            Video = BGVideo,
            Looped = false,
            Volume = 0,
            Parent = Config.Parent
        }, {
            New("UICorner", {
                CornerRadius = UDim.new(0,VideoModule.Radius)
            }),
        })
        VideoModule.ElementFrame = MainVideo
        MainVideo:Play()
        
        
        local aspectRatio = ParseAspectRatio(VideoModule.AspectRatio)
        local aspectRatioConstraint = nil
        
        if aspectRatio then
            aspectRatioConstraint = New("UIAspectRatioConstraint", {
                Parent = MainVideo,
                AspectRatio = aspectRatio,
                AspectType = "ScaleWithParentSize",
                DominantAxis = "Width"
            })
        end
    end
    
    
    function VideoModule:Destroy()
        if MainVideo then MainVideo:Destroy() end
    end
    
    return VideoModule.__type, VideoModule
end

return Element
