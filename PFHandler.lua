-- // Pop a band 😊
local Drawings = {};
local Thing, Channel = create_comm_channel();
Channel.Event:Connect(function(Func,ID,Index,Value)
    if Func == "new" then
        local Passed, Statement = pcall(function()
            Drawings[ID] = Drawing.new(Index);
        end);
    elseif Func == "remove" then
        local Passed, Statement = pcall(function()
            Drawings[ID]:Remove();
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
