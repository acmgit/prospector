--[[
   ****************************************************************
   *******                    Prospector                     ******
   *******    A CS-Mod to search for Nodes in Minetest       ******
   *******                  License: GPL 3.0                 ******
   *******                     by A.C.M.                     ******
   ****************************************************************
--]]

local prospector = {}

prospector.version = 1
prospector.revision = 3

prospector.you = nil -- Player
prospector.searchRadius = 100
prospector.maxRadius = 300
prospector.current_Node = ""
prospector.last_pos = ""
prospector.pnodelist = {}
prospector.nodestring = ""           -- String to load
prospector.storage = minetest.get_mod_storage()
prospector.marker = nil

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
        if(prospector.pnodelist ~= nil) then
            for idx,entry in pairs(prospector.pnodelist) 
            do
                prospector.print(prospector.yellow .. idx .. ": " .. prospector.orange .. entry .. prospector.green .."\n")
            
            end -- for _,key
        else
            prospector.print(prospector.red .. "Empty Nodelist.\n")
            return
            
        end -- if(prospector.nodelist ~= nil
            
    else
        prospector.print(prospector.green .. "Show the Nodelist only with: " .. prospector.orange .. pattern .. prospector.green .. ".\n")
        local count = 0
        if(prospector.pnodelist ~= nil) then
            for idx,entry in pairs(prospector.pnodelist) 
            do
                local hit = string.find(entry, pattern)
                if(hit ~= nil) then
                    prospector.print(prospector.yellow .. idx .. prospector.green .. ": " .. prospector.orange .. entry .. prospector.green .."\n")
                    count = count + 1
                
                end -- if(hit ~= nil
            
            end -- for _,key
            
        else
            prospector.print(prospector.red .. "Emtpy Nodelist.\n")
            return
            
        end -- if(prospector.nodelist ~= nil
            
        if(count > 0) then
            prospector.print(prospector.green .. "Found " .. prospector.yellow .. count .. prospector.green .. " Nodes.\n")
        
        else
            prospector.print(prospector.light_red .. "No Nodes found.\n")
            
        end -- if(count >
        
    end -- if(pattern == ""

end -- function(show_nodelist

function prospector.check_node(node)
    if(prospector.pnodelist ~= nil) then
        for _,entry in pairs(prospector.pnodelist)
        do
            if(entry == node) then
                return
            
            end
        
        end -- for
        
    end -- if(prospector.pnodelist
        
    prospector.add_node(node)
    prospector.print(prospector.green .. "Node: " .. prospector.orange .. node .. prospector.green .. " added to Nodelist.\n")
    table.sort(prospector.pnodelist)
    prospector.nodestring = minetest.serialize(prospector.pnodelist)
    prospector.storage:set_string("nodes", prospector.nodestring) -- Saves the Table
    
end -- function check_node

function prospector.add_node(node)
    if(prospector.pnodelist == nil) then
        prospector.pnodelist = {}
        table.insert(prospector.pnodelist, node)
        
    else
        table.insert(prospector.pnodelist, node)
        
    end -- if(prospector.pnodelist == nil
    
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

function prospector.calc_distance_pos(pos_1, pos_2)
    local distance = {}
    
    if(pos_1 ~= nil and pos_2 ~= nil) then
        distance.x = pos_1.x - pos_2.x
        distance.y = pos_1.y - pos_2.y
        distance.z = pos_1.z - pos_2.z
        distance = prospector.convert_position(distance)
        
    end -- if(pos_1 ~= nil
    
    
    return distance
    
end -- function calc_distance_pos

function prospector.split(parameter)
        local cmd = {}
        for word in string.gmatch(parameter, "[%w%-%:%_]+") do
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

function prospector.convert_position(pos)
    
    if(pos ~= nil) then

        pos.x = tonumber(string.format("%.1f",pos.x))
        pos.y = tonumber(string.format("%.1f",pos.y))
        pos.z = tonumber(string.format("%.1f",pos.z))
        return pos
        
    end -- if(prospector.marker ~= nil
    
    return nil
end -- function convert_position

function prospector.pnode_lastpos()
    if(prospector.last_pos ~= "") then
        prospector.print(prospector.green .. "The last found was at: " .. prospector.orange .. prospector.last_pos .. prospector.green .. ".\n")
        prospector.print(prospector.green .. "This is ".. prospector.yellow .. prospector.calc_distance() .. prospector.green .. " Nodes far away.\n")
    else
        prospector.print(prospector.red .. "There is no last Found set.\n")
                                          
    end -- if(prospcetor.last_pos
                                        
end -- prospector.lastpos

function prospector.pnode_search(parameter)
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
    
end -- prospector.search_node

function prospector.pnode_setradius(parameter)
    local radius = tonumber(parameter:trim()) or 0
    
    if(radius < 0 or radius > prospector.maxRadius) then
        prospector.print(prospector.red .. "Illegal Radiusnumber: " .. prospector.orange .. radius .. prospector.red .. ".\n")
        prospector.print(prospector.green .. "Min. Radius: " .. prospector.orange .. "1" .. prospector.green .. ".")
        prospector.print(prospector.green .. "Max. Radius: " .. prospector.orange .. prospector.maxRadius .. prospector.green .. ".")
        return
            
    end -- if(radius < 0
        
    if(radius > 0) then
        prospector.print(prospector.green .. " Current Radius = " .. prospector.orange .. prospector.searchRadius .. prospector.green .. ".\n")
        prospector.searchRadius = radius
        prospector.print(prospector.green .. " New Radius set to " .. prospector.yellow .. prospector.searchRadius .. prospector.green ..".\n")
            
    else
        prospector.print(prospector.green .. " Current Radius = " .. prospector.orange .. prospector.searchRadius .. prospector.green .. ".\n")
            
    end -- if(radius < 0
                
end -- prospector.set_radius

function prospector.pnode_set(parameter)
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

end -- prospector.set

function prospector.pnode_pos2mark()
    if(prospector.last_pos ~= "") then
        prospector.marker = minetest.string_to_pos(prospector.last_pos)
        prospector.print(prospector.green .. "Last Position to Marker transfered.\n")
                                            
    else
        prospector.print(prospector.red .. "No valid Position as last Positon found.\n")
                                            
    end -- if(prospector.last_pos ~= nil
    
end -- prospector.pos2marker

function prospector.pnode_who_is()
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

end -- prospector.who_is

function prospector.pnode_show_mb()
    local mypos = prospector.you:get_pos()
    local x = math.floor(mypos.x+0.5)
    local y = math.floor(mypos.y+0.5)
    local z = math.floor(mypos.z+0.5)
    
    local pos_string = math.floor(x / 16) .. "." .. math.floor(y / 16) .. "." .. math.floor(z / 16)
    prospector.print(prospector.green .. "Current Mapblocknumber: (" .. prospector.orange .. pos_string .. prospector.green .. ")\n")

end -- prospector.show_mapblock

function prospector.pnode_mark(parameter)
    local command = {}
        
    command = prospector.split(parameter)
    local current_position = prospector.you:get_pos()
    current_position = prospector.convert_position(current_position)
                                         
    -- No Node or Index given
    if(command[1] == nil or command[1] == "") then
        if(prospector.marker ~= nil) then
                                         
            prospector.print(prospector.green .. "Current Marker is @ " .. prospector.orange .. minetest.pos_to_string(prospector.marker))
                                         
        else
            prospector.print(prospector.green .. "Current Marker is " .. prospector.orange .. " not set.\n")
                                 
        end -- if(prospector.marker ~=
    
    elseif(command[1] == "-s") then
        prospector.marker = current_position
        prospector.print(prospector.green .. "Marker set to " .. prospector.orange .. minetest.pos_to_string(prospector.marker))
                                         
    elseif(command[1] == "-m") then
        if(prospector.marker ~= nil) then
                                         
            prospector.print(prospector.green .. "Current Marker is @ " .. prospector.yellow .. minetest.pos_to_string(prospector.marker))
            prospector.print(prospector.green .. "Your Position is @ " .. prospector.orange .. minetest.pos_to_string(current_position))
                                         
            local distance = math.floor(vector.distance(current_position, prospector.marker))
                                         
            prospector.print(prospector.green .. "You are " .. prospector.light_blue .. distance .. prospector.green .. " Nodes far away.")
                                         
        else
                                         
            prospector.print(prospector.green .. "Current Marker is " .. prospector.orange .. " not set " .. prospector.green .. " to calculate a Distance.\n")
                                         
        end -- if(prospector.marker ~= nil
        
    elseif(command[1] == "-w") then
            
        if(command[2] == nil or command[2] == "") then
            prospector.print(prospector.red .. "No Position to set Marker given.\n")
                                         
        else
            if(tonumber(command[2]) ~= nil and tonumber(command[3]) ~= nil and tonumber(command[4]) ~= nil) then
                local new_marker = "(" .. tonumber(command[2]) .. "," .. tonumber(command[3]) .. "," .. tonumber(command[4]) .. ")"
                prospector.print(prospector.green .. "Marker set to : " .. prospector.orange .. new_marker .. "\n")
                prospector.marker = minetest.string_to_pos(new_marker)
                prospector.marker = prospector.convert_position(prospector.marker)
                                         
            else
                prospector.print(prospector.red .. "Wrong Position(format) given.\n")
                                                                                       
            end -- if(command[3] .. command[4]
                                                                                       
        end -- if(command[2] ~= nil
                                         
    elseif(command[1] == "-p") then                                         
            
        if(prospector.marker ~= nil) then
            local distance = prospector.calc_distance_pos(prospector.marker, current_position)
            prospector.print(prospector.green .. "Current Marker is @ " .. prospector.yellow .. minetest.pos_to_string(prospector.marker))
            prospector.print(prospector.green .. "Your Position is @ " .. prospector.orange .. minetest.pos_to_string(current_position))
            prospector.print(prospector.green .. "The Distance between them is: " .. prospector.white .. minetest.pos_to_string(distance))
            prospector.print(prospector.green .. "You have to go " .. prospector.light_blue .. distance.x .. prospector.green .. " Steps at X-Axis.")
            prospector.print(prospector.green .. "You have to go " .. prospector.light_blue .. distance.y .. prospector.green .. " Steps at Y-Axis.")
            prospector.print(prospector.green .. "You have to go " .. prospector.light_blue .. distance.z .. prospector.green .. " Steps at Z-Axis.")
            
        else
            prospector.print(prospector.red .. "No Marker set.\n")
                                                                                       
        end -- if(prospector.marker ~= nil
                                         
    end -- if(command[1] ==
    
end -- prospector.marker

function prospector.pnode_version()
    prospector.print(prospector.green .. "Client-Side-Mod: Prospector " .. prospector.orange .. "v " .. prospector.version .. "." .. prospector.revision .. "\n")

end -- prospector.version
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

minetest.register_chatcommand("pnode_lastpos", {

    params = "<>",
    description = "Shows you the last Position of a found Node.\nUsage:\n<> shows you the last Position.\n",
    func = function()
        prospector.pnode_lastpos()
    end -- function
                                            
}) -- chatcommand prospector.last_pos

minetest.register_chatcommand("pnode_list", {

    params = "<> | <searchpattern>",
    description = "Shows you all successfully found Nodes.\nUsage:\n<> Shows you the whole Nodelist with Index.\n<searchpattern> Shows you a filtered Nodelist with <searchpattern>.\n",
    func = function(param)
        if(param == nil) then param = "" end
        prospector.show_nodelist(param)
                                            
    end -- function
                                            
}) -- chatcommand search_for

minetest.register_chatcommand("pnode_search", {

    params = "<> | <Node> | <-i> index",
    description = "Shows you the given Nodes in a Radius of <.set_radius>.\nUsage:\n<> searches for the set node with command .set_node\n<Node> search for <Node>\n<-i> index searches for Node in the Nodelist.\n",
    func = function(param)

        local parameter = param:lower()
        prospector.pnode_search(parameter)
                                             
    end -- function
                                             
}) -- chatcommand search

minetest.register_chatcommand("pnode_setradius", {

    params = "<> | <radius>",
    description = "Set's or shows you the the Radius for the command .search_for.\nUsage:\n<> Shows you the current Radius.\n<radius> set's a new Radius if valid.\n",
    func = function(param)
        local parameter = param:lower()
        prospector.pnode_setradius(parameter)
    
    end -- function
                                        
}) -- chatcommand set_radius
    
minetest.register_chatcommand("pnode_set", {
        
    params = "<> | <Node> | <-i> index",
    description = "Set's a new Node for search.\nUsage:\n<> shows the current Node for search.\n<Node> set's a new Node.\n<-i> index set's a new Node for search from the Nodelist.\n",
    func = function(param)
                      
        local parameter = param:lower()
        prospector.pnode_set(parameter)
                                          
    end -- function

}) -- chatcommand pos2marker

minetest.register_chatcommand("pnode_pos2mark", {

    params = "<>",
    description = "Transfers the LastPos to the Marker.\nUsage:\n<> Transfers the last found to the Marker.\n",
    func = function()
        prospector.pnode_pos2mark()
                                            
    end -- function
                                            
}) -- chatcommand searc
    
minetest.register_chatcommand("pnode_who_is", {

    params = "<>",
    description = "Shows you all online Playernames.\nUsage:\n<> shows you all Playernames.\n",
    func = function()
        prospector.pnode_who_is()
                                        
    end -- function
                                            
}) -- chatcommand searc

minetest.register_chatcommand("pnode_show_mb",{

    params = "<>",
    description = "Shows the current Mapblock, where you are.",
    func = function()
        prospector.pnode_show_mb()
                                              
    end -- function
                                              
}) -- chatcommand show_mapblock

minetest.register_chatcommand("pnode_mark",{

    params = "<> | -s | -m | -p | -w X,Y,Z",
    description = "\n<> shows you the stored Marker.\n-s - Set's the Marker to your current Position.\n-m - Shows the Distance from your Marker.\n-p - Shows the Distance from your Marker as Vector\n-w X,Y,Z - Set's the Marker to X,Y,Z",
    func = function(param)
        
        local parameter = param:lower()
            prospector.pnode_mark(parameter)
                                       
    end -- function
                                              
}) -- chatcommand show_mapblock

minetest.register_chatcommand("pnode_version",{
    
    params = "<>",
    description = "Shows the current Revision of Prospector.",
    func = function ()
        prospector.pnode_version()
                                                   
    end -- function

}) -- chatcommand prospector_version
        
       
   
                                                    
