prospector.register_help({
                            Name = "search",
                            Usage = ".prs search <> | <Node> | <-i> index",
                            Description = "Shows you the given Node in a Radius of <.set_radius>.",
                            Parameter = "<> | <Node> | <-i> index" .. prospector.green .. "." ..
                                        "\n" .. prospector.orange .. "<>" ..
                                        prospector.green.. " - searches for a certain node, set with set_node." ..
                                        "\n" .. prospector.orange .. "<Node>" ..
                                        prospector.green .. " - search for <Node>." ..
                                        "\n" .. prospector.orange .. "<-i> index" ..
                                        prospector.green .. " - searches for Node with the Indexnumber in the Nodelist."

                        })

prospector["search"] = function(cmd)
    if(cmd[2] == "" or cmd[2] == nil) then
        if(prospector.current_Node == "" or prospector.current_Node == nil) then
            prospector.print(prospector.green .. "There is no searching Node set. Use command set_node <Nodename>.\n")
            return

        else
            prospector.search_node(prospector.current_Node)
            return

        end --if(prospector.current_Node
    end

    if(cmd[2] == "-i") then -- command Index found
        local idx = tonumber(cmd[3])
        if(idx ~= nil) then -- valid Index
            local node = prospector.pnodelist[idx]
            if(node ~= nil or node ~= "") then -- valid Node found
                prospector.search_node(node)
                return

            else

                prospector.print(prospector.red .. "No Node found at Index " ..
                prospector.yellow .. idx ..
                prospector.red .. ".\n")
                return

            end -- if( node ~=

        else
            prospector.print(prospector.red .. "Invalid Indexnumber.\n")
            return

        end --(if(idx ~=

    end -- if(command[1]

    -- Param isn't empty and not the Command -i, so it's a Node
    prospector.search_node(cmd[2])

end -- prospector.pnode_search
