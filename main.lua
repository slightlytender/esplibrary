local ESP = {}
ESP.Types = {}

-- Create a new ESP type
function ESP:CreateType(typeName)
    if self.Types[typeName] then
        return self.Types[typeName]  -- Return existing type if it exists
    end

    local espType = {
        Enabled = true,
        Color = Color3.fromRGB(255,255,255),  -- Default color: white
        OutlineColor = Color3.fromRGB(0,0,0),
        Size = 12,  -- Default text size
        Objects = {}  -- Table to hold ESP objects
    }

    function espType:Toggle(state)
        self.Enabled = state
        for _, obj in pairs(self.Objects) do
            obj.Text.Visible = state
        end
    end

    function espType:SetColor(color)
        self.Color = color
        for _, obj in pairs(self.Objects) do
            obj.Text.Color = color
        end
    end

    function espType:Add(object, customText)
        if not object then return end

        local espData = {
            Text = Drawing.new("Text"),
            Object = object,
        }

        espData.Text.Visible = self.Enabled
        espData.Text.Color = self.Color
        espData.Text.OutlineColor = self.OutlineColor
        espData.Text.Size = self.Size
        espData.Text.Center = true
        espData.Text.Outline = true

        -- Register ESP object
        self.Objects[object] = espData

        -- Update ESP position and text
        game:GetService("RunService").RenderStepped:Connect(function()
            if not object or not object.Parent then
                espData.Text:Remove()
                self.Objects[object] = nil
            else
                local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(object.Position)
                espData.Text.Visible = onScreen and self.Enabled
                if onScreen then
                    espData.Text.Position = Vector2.new(screenPos.X, screenPos.Y)
                    espData.Text.Text = customText or object.Name  -- Display custom text or object name
                end
            end
        end)
    end

    function espType:Remove(object)
        if self.Objects[object] then
            self.Objects[object].Text:Remove()
            self.Objects[object] = nil
        end
    end

    self.Types[typeName] = espType  -- Store the new type
    return espType  -- Return the new ESP type
end

return ESP
