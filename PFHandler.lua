-- // Pop a band 😊
local Drawings = {};
local Thing, Channel = create_comm_channel();
Channel.Event:Connect(function(Func,ID,Index,Value)
    if Func == "remove" then
        local Passed, Statement = pcall(function()
            Drawings[ID]:Remove();
        end);
        if not Passed then
            print("Failed to remove drawing.");
        end;
    elseif Func == "new" then
        local Passed, Statement = pcall(function()
            Drawings[ID] = Drawing.new(Index);
        end);
        if not Passed then
            print("Failed to create drawing.");
        end;
    else
        local Type = Drawings[ID];
        if Type then
            local Passed, Statement = pcall(function()
                Type[Index] = value;
            end);
            if not Passed then
                print("Failed to modify drawing.");
            end;
        end;
    end;
end);
