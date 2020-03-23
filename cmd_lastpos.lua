prospector.register_help({
                            Name = "lastpos",
                            Usage = ".prs lastpos <> | -s",
                            Description = "Shows or sends the last Position to Distancer.",
                            Parameter = "<> | -s" .. prospector.green .. "." ..
                                        "\n" .. prospector.orange .. "<>" ..
                                        prospector.green.. " - Shows the last Position." ..
                                        "\n" .. prospector.orange .. "-s" ..
                                        prospector.green .. " - Sends the last Position to Distancer's Waypoint."
                        }
                       )

prospector["lastpos"] = function(cmd)

    if(cmd[2] == nil or cmd[2] == "") then
        if(prospector.last_pos ~= "") then
            prospector.print(prospector.green .. "The last found was at: " ..
            prospector.orange .. prospector.last_pos ..
            prospector.green .. ".\n")
            prospector.print(prospector.green .. "This is "..
            prospector.yellow .. prospector.calc_distance() ..
            prospector.green .. " Nodes far away.\n")
        else
            prospector.print(prospector.red .. "There is no last Found set.\n")

        end -- if(prospector.last_pos ~= nil

    elseif(cmd[2] == "-s") then -- Sends the last Position to distancer
        local version = dst.ver + (dst.rev / 10)
        
        if(version >= 2.7) then
            local mylastpos = prospector.last_pos
            if(mylastpos == "") then
                mylastpos = "0,0,0"

            end -- if(mylastpos ==

            dst.send_pos(minetest.localplayer:get_name(), mylastpos)

        else
            prospector.print(prospector.orange .. "No Distancer found or Version < 2.7.\n")

        end -- if(version
    else
        prospector.print(prospector.red .. "Unknown Option " .. prospector.orange .. cmd[2] .. prospector.green .. " for .prs lastpos.")
        prospector.print(prospector.red .. "Try .prs help lastpos")
        
    end -- if(cmd[2]
--[[
        if(prospector.distancer_channel ~= nil) then
            if(prospector.distancer_channel:is_writeable()) then
                prospector.distancer_channel:send_all("POS:" .. prospector.last_pos)
                prospector.print(prospector.green .. "Position: " ..
                prospector.orange .. prospector.last_pos .. prospector.green .. " send to Distancer.\n")

            else
                prospector.print(prospector.red .. "Modchannel not writeable.\n")

            end -- if(prospector.distancer_channel:is_writeable

        else
            prospector.print(prospector.red .. "No Modchannel open.\n")
            prospector.distancer_channel = minetest.mod_channel_join(prospector.distancer_channelname)

        end -- if(prospector.distancer_channel
]]--



end -- prospector.pnode_lastpos
