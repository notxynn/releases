local realDrawings = {}
local newID, newChannel = create_comm_channel()
newChannel.Event:Connect(function(method, drawingID, index, value)
    if method == "remove" then
        pcall(function()
            realDrawings[drawingID]:Remove()
        end)
    elseif method == "new" then
        pcall(function()
            realDrawings[drawingID] = Drawing.new(index)
        end)
    else
        local shape = realDrawings[drawingID]

        if shape then
            pcall(function()
                shape[index] = value
            end)
        end
    end
end)
