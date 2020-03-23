prospector.register_help({
                            Name = "radius",
                            Usage = ".prs radius <> | <radius>",
                            Description = "Set's or shows you the the Radius for the command .prs search.",
                            Parameter = "<> | <radius>" .. prospector.green .. "." ..
                                        "\n" .. prospector.orange .. "<>" ..
                                        prospector.green.. " - Shows you the current Radius." ..
                                        "\n" .. prospector.orange .. "<radius>" ..
                                        prospector.green .. " - set's a new valid Radius."
                        }
                       )


prospector["radius"] = function(cmd)
    if(cmd[2] == nil or cmd[2] == "") then
        if(prospector.searchRadius ~= nil or prospector.searchRadius ~= "") then
            prospector.print(prospector.green .. "Current Radius is set to: " ..
            prospector.orange .. prospector.searchRadius ..
            prospector.green .. ".\n")
            return
        else
            prospector.print(prospector.red .. "Illegal Radiusnumber set. Set a new Number.\n")
            return

        end -- if(prospector.searchRadius ~= nil

    end -- if(cmd == nil

    local radius = tonumber(cmd[2]:trim())
    prospector.print(prospector.green .. " Current Radius = " ..
    prospector.orange .. prospector.searchRadius ..
    prospector.green .. ".\n")
    prospector.print(prospector.green .. " Max Radius = " ..
    prospector.red .. prospector.maxRadius ..
    prospector.green .. ".\n")

    if(radius ~= nil and radius > 0 and radius <= prospector.maxRadius) then
        prospector.searchRadius = radius
        prospector.print(prospector.green .. " New Radius set to " ..
        prospector.yellow .. prospector.searchRadius ..
        prospector.green ..".\n")

    else
        prospector.print(prospector.red .. "Illegal Radiusnumber.\n")

    end -- if(radius ~= nil

end -- prospector.pnode_setradius
