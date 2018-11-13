local prospector = {}

prospector.you = nil -- Player
prospector.searchRadius = 100
prospector.maxRadius = 300
prospector.current_Node = ""
prospector.last_pos = ""
prospector.pnodelist = {}
prospector.nodestring = ""           -- String to load
prospector.storage = minetest.get_mod_storage()

-- Colors for Chat
prospector.green = minetest.get_color_escape_sequence('#00FF00')
prospector.red = minetest.get_color_escape_sequence('#FF0000')
prospector.orange = minetest.get_color_escape_sequence('#FF6700')
prospector.blue = minetest.get_color_escape_sequence('#0000FF')
prospector.yellow = minetest.get_color_escape_sequence('#FFFF00')
prospector.purple = minetest.get_color_escape_sequence('#FF00FF')
prospector.pink = minetest.get_color_escape_sequence('#FFAAFF')
prospector.white = minetest.get_color_escape_sequence('#FFFFFF')
prospector.black = minetest.get_color_escape_sequence('#000000')
prospector.grey = minetest.get_color_escape_sequence('#888888')
prospector.light_blue = minetest.get_color_escape_sequence('#8888FF')
prospector.light_green = minetest.get_color_escape_sequence('#88FF88')
prospector.light_red = minetest.get_color_escape_sequence('#FF8888')

--[[
   ****************************************************************
   *******        Functions for Prospector                   ******
   ****************************************************************
--]]

function prospector.show_nodelist(pattern)
    if(pattern == "") then
        prospector.print(prospector.green .. "Show the Nodelist:\n")
        for idx,entry in pairs(prospector.pnodelist) 
        do
            prospector.print(prospector.yellow .. idx .. ": " .. prospector.orange .. entry .. prospector.green .."\n")
            
        end -- for _,key
        
    else
        prospector.print(prospector.green .. "Show the Nodelist only with: " .. prospector.orange .. pattern .. prospector.green .. ".\n")
        local count = 0
        for idx,entry in pairs(prospector.pnodelist) 
        do
            local hit = string.find(entry, pattern)
            if(hit ~= nil) then
                prospector.print(prospector.yellow .. idx .. prospector.green .. ": " .. prospector.orange .. entry .. prospector.green .."\n")
                count = count + 1
                
            end
            
        end -- for _,key
        
        if(count > 0) then
            prospector.print(prospector.green .. "Found " .. prospector.yellow .. count .. prospector.green .. " Nodes.\n")
        
        else
            prospector.print(prospector.light_red .. "No Nodes found.\n")
            
        end -- if(count >
        
    end -- if(pattern == ""

end -- function(show_nodelist

function prospector.check_node(node)
    for _,entry in pairs(prospector.pnodelist)
    do
        if(entry == node) then
            return
            
        end
        
    end -- for
    
    prospector.add_node(node)
    prospector.print(prospector.green .. "Node: " .. prospector.orange .. node .. prospector.green .. " added to Nodelist.\n")
    table.sort(prospector.pnodelist)
    prospector.nodestring = minetest.serialize(prospector.pnodelist)
    prospector.storage:set_string("nodes", prospector.nodestring) -- Saves the Table
    
end -- function check_node

function prospector.add_node(node)
    table.insert(prospector.pnodelist, node)
    
end -- function add_node

function prospector.search_node(node)
    if(node == "") then 
        prospector.print(prospector.green .. " No Nodename given!\n")
                                            
    else
        prospector.print(prospector.green .. "Searching for " .. prospector.yellow .. node .. prospector.green .. ".\n")
        local nodes = {}
        nodes = minetest.find_node_near(prospector.you:get_pos(), prospector.searchRadius, node)
                                            
        if(nodes ~= nil) then
            prospector.print(prospector.green .. "Found at ".. prospector.orange .. minetest.pos_to_string(nodes) .. prospector.green .. ".\n")
            prospector.last_pos = minetest.pos_to_string(nodes)
            prospector.print(prospector.green .. "This is ".. prospector.yellow .. prospector.calc_distance() .. prospector.green .. " Nodes far away.\n")
            prospector.check_node(node)
            
            --prospector.print(prospector.grey .. dump(nodes))
                                            
        else
            prospector.print(prospector.yellow .. node .. prospector.green .. " not found.\n")
        
        end -- if(nodes
                
    end -- if(node == "")
    
end -- function search_node()

function prospector.calc_distance()
    return math.floor(vector.distance(prospector.you:get_pos(), minetest.string_to_pos(prospector.last_pos)))

end -- function calc_distance

function prospector.split(parameter)
        local cmd = {}
        for word in string.gmatch(parameter, "[%w%-%:]+") do
            table.insert(cmd, word)
            
        end -- for word
        
        return cmd
        
end -- function prospector.split

function prospector.set_node(node)
    if(node == nil or node == "") then -- No Node is given
        if(prospector.current_Node == "") then -- No current_Node is set
            prospector.print(prospector.red .. "There is no searching Node set. Use command set_node <Nodename>.\n")
            return
        else -- No Node is give, current_Node is set
            prospector.print(prospector.green .. "Current node is set to: " .. prospector.orange .. prospector.current_Node .. prospector.green ..".\n")
            return
          
        end -- if(prospector.current_Node
          
    end -- if(node == nil
    

    if(prospector.current_Node == "") then -- Node is given, but no current_Node set
        prospector.print(prospector.light_red .. "Old node wasn't set.\n")
    
    else -- Node is given and current_Node is a Node
        prospector.print(prospector.green .. "Old node was set to: " .. prospector.orange .. prospector.current_Node .. prospector.green ..".\n")
                        
    end
    
    prospector.current_Node = node
    prospector.print(prospector.green .. "Current node set to: " .. prospector.orange .. prospector.current_Node .. prospector.green ..".\n")

end -- function set_node

function prospector.print(text)
    minetest.display_chat_message(text)
    
end -- function prospector.print(

--[[
   ****************************************************************
   *******        Main for Prospector                        ******
   ****************************************************************
--]]

-- Get yourself
minetest.register_on_connect(function()
    prospector.you = minetest.localplayer               
end)

prospector.nodestring = prospector.storage:get_string("nodes") -- Get the Nodelist as String
if(prospector.nodestring ~= nil) then
    prospector.pnodelist = minetest.deserialize(prospector.nodestring) -- and write it to the list.
    prospector.print(prospector.green .. "Nodelist loaded.\n")
    
else
    prospector.nodelist = ""
    prospector.print(prospector.green .. "No Nodelist found.\n")
    
end


--[[
   ****************************************************************
   *******        Registered Chatcommands                    ******
   ****************************************************************
--]]

minetest.register_chatcommand("last_pos", {

    params = "<>",
    description = "Shows you the last Position of a found Node.\nUsage:\n<> shows you the last Position.\n",
    func = function()
        
        if(prospector.prospector.last_pos ~= "") then
            prospector.print(prospector.green .. "The last found was at: " .. prospector.orange .. prospector.prospector.last_pos .. prospector.green .. ".\n")
            prospector.print(prospector.green .. "This is ".. prospector.yellow .. prospector.calc_distance() .. prospector.green .. " Nodes far away.\n")
        else
            prospector.print(prospector.green .. "There is no last Found set.\n")
                                          
        end
                                          
                                            
    end -- function
                                            
}) -- chatcommand prospector.last_pos

minetest.register_chatcommand("show_nodelist", {

    params = "<> | <searchpattern>",
    description = "Shows you all successfully found Nodes.\nUsage:\n<> Shows you the whole Nodelist with Index.\n<searchpattern> Shows you a filtered Nodelist with <searchpattern>.\n",
    func = function(param)
        if(param == nil) then param = "" end
        prospector.show_nodelist(param)
                                            
    end -- function
                                            
}) -- chatcommand search_for

minetest.register_chatcommand("search_node", {

    params = "<> | <Node> | <-i> index",
    description = "Shows you the given Nodes in a Radius of <.set_radius>.\nUsage:\n<> searches for the set node with command .set_node\n<Node> search for <Node>\n<-i> index searches for Node in the Nodelist.\n",
    func = function(param)

        local parameter = param:lower()
        if(parameter == "" or parameter == nil) then
            if(prospector.current_Node == "") then
                prospector.print(prospector.green .. "There is no searching Node set. Use command set_node <Nodename>.\n")
                return                            
                                        
            else
                prospector.search_node(prospector.current_Node)
                return                  
                                        
            end --if(prospector.current_Node
        end
         
        local command = prospector.split(parameter)
        if(command[1] == "-i") then -- command Index found
            local idx = tonumber(command[2])
            if(idx ~= nil) then -- valid Index
                local node = prospector.pnodelist[idx]
                if(node ~= nil or node ~= "") then -- valid Node found
                    prospector.search_node(node)
                    return
                                        
                else
                    prospector.print(prospector.red .. "No Node found at Index " .. prospector.yellow .. idx .. prospector.red .. ".\n")
                    return
                                        
                end -- if( node ~=
                                        
            else
                prospector.print(prospector.red .. "Invalid Indexnumber.\n")
                return
                                        
            end --(if(idx ~=
                                        
        end -- if(command[1]
        
        -- Param isn't empty and not the Command -i, so it's a Node
        prospector.search_node(parameter)
        
    end -- function
                                            
}) -- chatcommand search

minetest.register_chatcommand("set_radius", {

    params = "<> | <radius>",
    description = "Set's or shows you the the Radius for the command .search_for.\nUsage:\n<> Shows you the current Radius.\n<radius> set's a new Radius if valid.\n",
    func = function(param)
        
        if(param == nil) then
                prospector.print(prospector.red .. "Illegal Radius.\n")
                return
        end
                                            
        local radius = tonumber(param:trim())
        prospector.print(prospector.green .. " Current Radius = " .. prospector.orange .. prospector.searchRadius .. prospector.green .. ".\n")
        prospector.print(prospector.green .. " Max Radius = " .. prospector.red .. prospector.maxRadius .. prospector.green .. ".\n")
                                            
        if(radius ~= nil and radius > 0 and radius <= prospector.maxRadius) then
            prospector.searchRadius = radius
            prospector.print(prospector.green .. " New Radius set to " .. prospector.yellow .. prospector.searchRadius .. prospector.green ..".\n")
                                            
        else
            prospector.print(prospector.red .. "Illegal Radiusnumber.\n")
                                            
        end
    
    end -- function
                                        
}) -- chatcommand set_radius
    
minetest.register_chatcommand("set_node", {
        
    params = "<> | <Node> | <-i> index",
    description = "Set's a new Node for search.\nUsage:\n<> shows the current Node for search.\n<Node> set's a new Node.\n<-i> index set's a new Node for search from the Nodelist.\n",
    func = function(param)
                      
        local parameter = param:lower()
        local command = {}
        
        command = prospector.split(parameter)
                                                                                
        -- No Node or Index given
        if(command[1] == nil or command[1] == "") then
            prospector.set_node("")
            return
                                          
        end -- if(command[1] == nil
        
        -- Command Index found
        if(command[1] == "-i") then
            local idx = tonumber(command[2])
                                 
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
        prospector.set_node(command[1]) 
                                
    end

}) -- chatcommand set_node

minetest.register_chatcommand("who_is", {

    params = "<>",
    description = "Shows you all online Playernames.\nUsage:\n<> shows you all Playernames.\n",
    func = function()
    
        local online = minetest.get_player_names()
        if(online == nil) then 
                prospector.print(prospector.green .. "No Player is online?\n")
                return
                                        
        else
            table.sort(online)
    
        end
                                            
        prospector.print(prospector.green .. "Player now online:\n")
                                        
        for pl, name in pairs(online) do
            prospector.print(prospector.green .. pl .. ": " .. prospector.orange .. name .. "\n")
        
        end -- for
    end -- function
                                            
}) -- chatcommand search

