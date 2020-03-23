prospector.register_help({
                            Name = "set",
                            Usage = ".prs set <> | <Node> | <-i> index",
                            Description = "Set's a new Node for search.",
                            Parameter = "<> | <Node> | <-i> index" .. prospector.green .. "." ..
                                        "\n" .. prospector.orange .. "<>" ..
                                        prospector.green.. " - shows the current Node for search." ..
                                        "\n" .. prospector.orange .. "<Node>" ..
                                        prospector.green .. " - set's a new Node." ..
                                        "\n" .. prospector.orange .. "<-i> index" ..
                                        prospector.green .. " - set's a new Node for search from the Nodelist with the Indexnumber."

                        }
                       )

prospector["set"]= function(command)

    -- No Node or Index given
    if(command[2] == nil or command[2] == "") then
        prospector.set_node("")
        return

    end -- if(command[1] == nil

    -- Command Index found
    if(command[2] == "-i") then
        local idx = tonumber(command[3])

        if(idx ~= nil) then
            local node = prospector.pnodelist[idx]
            if(node ~= nil or node ~= "") then
                prospector.set_node(node)
            return

            else -- No Node at this Index found.
                prospector.print(prospector.red .. "Wrong Indexnumber.\n")
                return

            end -- if(node ~= nil

        else -- Illegal Index found, should not happen
            prospector.print(prospector.red .. "Illegal Indexnumber entered.")
            return

        end -- if(idx ~nil)

    end -- if(command[1]

    -- No empty Param, no Index found, so it's a Node and set it
    prospector.set_node(command[2])

end -- prospector.pnode_set
