local Drawings = {};
local Thing, Channel = create_comm_channel();
Channel.Event:Connect(function(Func,ID,Index,Value)
    if Func == "new" then
        pcall(function()
            Drawings[ID] = Drawing.new(Index);
        end);
    elseif Func == "remove" then
        pcall(function()
            Drawings[ID]:Remove();
        end)
    else
        local Type = Drawings[ID];
        if Type then
            pcall(function()
                Type[Index] = Value;
            end);
        end;
    end;
end);
