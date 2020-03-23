prospector.register_help({
                            Name = "list",
                            Usage = ".prs list <> | <searchpattern>",
                            Description = "Shows you a list of all successfully found Nodes.",
                            Parameter = "<> | <searchpattern>" .. prospector.green .. "." ..
                                        "\n" .. prospector.orange .. "<>" ..
                                        prospector.green.. " - Shows you the entire Nodelist with Index." ..
                                        "\n" .. prospector.orange .. "<searchpattern>" ..
                                        prospector.green .. " - Shows you a filtered Nodelist of <searchpattern> with Index."
                        }
                       )

prospector["list"] = function(pattern)

    if(pattern[2] == "" or pattern[2] == nil) then
        prospector.print(prospector.green .. "Show the Nodelist:\n")
        if(prospector.pnodelist ~= nil) then
            for idx,entry in pairs(prospector.pnodelist)
            do
                prospector.print(prospector.yellow .. idx .. ": " ..
                prospector.orange .. entry .. prospector.green .."\n")

            end -- for _,key

        else
            prospector.print(prospector.red .. "Empty Nodelist.")
            return

        end -- if(prospector.pnodelist ~= nil

    else
        prospector.print(prospector.green .. "Show the Nodelist only with: " ..
        prospector.orange .. pattern[2] .. prospector.green .. ".\n")
        local count = 0
        if(prospector.pnodelist ~= nil) then
            for idx,entry in ipairs(prospector.pnodelist)
            do
                local hit = string.find(entry, pattern[2])
                if(hit ~= nil) then
                    prospector.print(prospector.yellow .. idx .. prospector.green .. ": " ..
                    prospector.orange .. entry .. prospector.green .."\n")
                    count = count + 1

                end

            end -- for _,key

        else
            prospector.print(prospector.red .. "Empty Nodelist.")
            return
        end

        if(count > 0) then
            prospector.print(prospector.green .. "Found " .. prospector.yellow .. count ..
            prospector.green .. " Nodes.\n")

        else
            prospector.print(prospector.light_red .. "No Nodes found.\n")

        end -- if(count >

    end -- if(pattern == ""

end -- function(show_nodelist
