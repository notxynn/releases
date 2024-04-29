-- // Pop a band 😊
local Drawings = {};
local Thing, Channel = create_comm_channel();
Channel.Event:Connect(function(Func,ID,Index,Value)
    if Func == "remove" then
        pcall(function()
            Drawings[ID]:Remove()
        end)
    elseif Func == "new" then
        pcall(function()
            Drawings[ID] = Drawing.new(Index)
        end)
    else
        local Type = Drawings[ID];
        if Type then
            local Passed, Statement = pcall(function()
                Type[Index] = value;
            end);
        end;
    end;
end);
