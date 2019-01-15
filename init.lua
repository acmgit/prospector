--[[
   ****************************************************************
   *******                    Prospector                     ******
   *******    A CS-Mod to search for Nodes in Minetest       ******
   *******                  License: GPL 3.0                 ******
   *******                     by A.C.M.                     ******
   ****************************************************************
--]]

local prospector = {}

prospector.modname = "Prospector"
prospector.version = 2
prospector.revision = 4

prospector.you = nil -- Player
prospector.searchRadius = 100
prospector.maxRadius = 300
prospector.current_Node = ""
prospector.last_pos = ""
prospector.pnodelist = {}
prospector.nodestring = ""           -- String to load
prospector.storage = minetest.get_mod_storage()
prospector.distancer_channelname = dst.channelname
prospector.distancer_channel = nil

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
            prospector.print(prospector.red .. "Empty Nodelist.")
            return
            
        end -- if(prospector.pnodelist ~= nil
            
    else
        prospector.print(prospector.green .. "Show the Nodelist only with: " .. prospector.orange .. pattern .. prospector.green .. ".\n")
        local count = 0
        if(prospector.pnodelist ~= nil) then
            for idx,entry in ipairs(prospector.pnodelist) 
            do
                local hit = string.find(entry, pattern)
                if(hit ~= nil) then
                    prospector.print(prospector.yellow .. idx .. prospector.green .. ": " .. prospector.orange .. entry .. prospector.green .."\n")
                    count = count + 1
                
                end
            
            end -- for _,key
            
        else
            prospector.print(prospector.red .. "Empty Nodelist.")
            return
        end
            
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
            
            end -- if(entry ==
        
        end -- for _,entry
        
    end -- if(prospector.pnodelist
    
    prospector.add_node(node)
    prospector.print(prospector.green .. "Node: " .. prospector.orange .. node .. prospector.green .. " added to Nodelist.\n")
    table.sort(prospector.pnodelist)
    prospector.nodestring = minetest.serialize(prospector.pnodelist)
    prospector.storage:set_string("nodes", prospector.nodestring) -- Saves the Table
    
end -- function check_node

function prospector.add_node(node)
    
    if(type(prospector.pnodelist) ~= "table") then
        prospector.pnodelist = {}
        table.insert(prospector.pnodelist, node)
        
    else
        table.insert(prospector.pnodelist, node)
    
    end -- if(prospector.pnodelist ~=
    
end -- function add_node

function prospector.search_node(node)
    if(node == "") then 
        prospector.print(prospector.green .. " No Nodename given!\n")
                                            
    else
        if(prospector.you == nil) then -- Don't know why, but sometimes there is no localplayer registered at start.
            prospector.you = minetest.localplayer
            
        end -- if(prospector.you
            
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
    if(parameter ~= "" or parameter ~= nil) then
        for word in string.gmatch(parameter, "[%w%-%:%_]+") do
            table.insert(cmd, word)
            
        end -- for word
        
    end -- if(parameter ~=
        
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

function prospector.pnode_lastpos(cmd)
    local command = prospector.split(cmd)
    if(command[1] == nil or command[1] == "") then
        if(prospector.last_pos ~= "") then
            prospector.print(prospector.green .. "The last found was at: " .. prospector.orange .. prospector.last_pos .. prospector.green .. ".\n")
            prospector.print(prospector.green .. "This is ".. prospector.yellow .. prospector.calc_distance() .. prospector.green .. " Nodes far away.\n")
        else
            prospector.print(prospector.red .. "There is no last Found set.\n")
                                          
        end -- if(prospector.last_pos ~= nil
                                               
    elseif(command[1] == "-s") then -- Sends the last Position to distancer
        
        if(dst.ver == 2 and dst.rev >= 7) then
            local mylastpos = prospector.last_pos
            if(mylastpos == "") then
                mylastpos = "0,0,0"
                
            end -- if(mylastpos ==
            
            dst.send_pos(prospector.you:get_name(), mylastpos)
                        
        else
            prospector.print(prospector.orange .. "No Distancer found or Version < 2.7.\n")
            
        end -- if(dst.ver
        
--[[
        if(prospector.distancer_channel ~= nil) then
            if(prospector.distancer_channel:is_writeable()) then
                prospector.distancer_channel:send_all("POS:" .. prospector.last_pos)
                prospector.print(prospector.green .. "Position: " .. prospector.orange .. prospector.last_pos .. prospector.green .. " send to Distancer.\n")
                                                             
            else
                prospector.print(prospector.red .. "Modchannel not writeable.\n")
                                                             
            end -- if(prospector.distancer_channel:is_writeable
        
        else
            prospector.print(prospector.red .. "No Modchannel open.\n")
            prospector.distancer_channel = minetest.mod_channel_join(prospector.distancer_channelname)
                                                        
        end -- if(prospector.distancer_channel 
]]--
        
    end -- if(command[1]
            
end -- prospector.pnode_lastpos

function prospector.pnode_search(cmd)
    if(cmd == "" or cmd == nil) then
        if(prospector.current_Node == "" or prospector.current_Node == nil) then
            prospector.print(prospector.green .. "There is no searching Node set. Use command set_node <Nodename>.\n")
            return                            
                                        
        else
            prospector.search_node(prospector.current_Node)
            return                  
                                        
        end --if(prospector.current_Node
    end
         
    local command = prospector.split(cmd)
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
    prospector.search_node(cmd)
    
end -- prospector.pnode_search

function prospector.pnode_setradius(cmd)
    if(cmd == nil or cmd == "") then
        if(prospector.searchRadius ~= nil or prospector.searchRadius ~= "") then
            prospector.print(prospector.green .. "Current Radius is set to: " .. prospector.orange .. prospector.searchRadius .. prospector.green .. ".\n")
            return
        else
            prospector.print(prospector.red .. "Illegal Radiusnumber set. Set a new Number.\n")
            return
            
        end -- if(prospector.searchRadius ~= nil
        
    end -- if(cmd == nil
                                            
    local radius = tonumber(cmd:trim())
    prospector.print(prospector.green .. " Current Radius = " .. prospector.orange .. prospector.searchRadius .. prospector.green .. ".\n")
    prospector.print(prospector.green .. " Max Radius = " .. prospector.red .. prospector.maxRadius .. prospector.green .. ".\n")
                                            
    if(radius ~= nil and radius > 0 and radius <= prospector.maxRadius) then
        prospector.searchRadius = radius
        prospector.print(prospector.green .. " New Radius set to " .. prospector.yellow .. prospector.searchRadius .. prospector.green ..".\n")
                                            
    else
        prospector.print(prospector.red .. "Illegal Radiusnumber.\n")
                                            
    end -- if(radius ~= nil

end -- prospector.pnode_setradius

function prospector.pnode_set(cmd)
    local command = {}
    command = prospector.split(cmd)
                                                                                
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

end -- prospector.pnode_set

function prospector.show_version()
    print("[CSM-MOD]" .. prospector.modname .. " v " .. prospector.version .. "." .. prospector.revision .. " loaded. \n")

end -- function prospector.version
    
--[[
   ****************************************************************
   *******    Functions for MOD-Channel of Prospector        ******
   ****************************************************************
--]]

function prospector.handle_channel_event(channel, msg)
    local report = ""
    if(msg ~= 0) then
        if(msg == 0) then
            report = prospector.orange .. " join with success.\n"
            
        elseif(msg == 1) then
            report = prospector.red .. " join failed.\n"
            
        elseif(msg == 2) then
            report = prospector.orange .. " leave with success.\n"
            
        elseif(msg == 3) then
            report = prospector.red .. " leave failed.\n"
            
        elseif(msg == 4) then
            report = prospector.orange .. " Event on another Channel.\n"
            
        elseif(msg == 5) then 
            report = prospector.orange .. " state changed.\n"
        else
            report = prospector.red .. " unknown Event.\n"
        end
        
        prospector.print(prospector.green .. "Prospectorchannel: " .. prospector.orange .. channel .. report)
        
    end -- if(msg ~= 0
    
end -- function prospector.handle_channel_event(

function prospector.handle_message(sender, message)
    prospector.print(prospector.green .. "Prospectormessage from " .. prospector.orange .. sender .. prospector.green .. " received.\n")
    prospector.print(prospector.green .. "Message: " .. prospector.orange .. message .. prospector.green .. " .\n")
    
end -- distancer.handle_message

--[[
   ****************************************************************
   *******        Registered Chatcommands                    ******
   ****************************************************************
--]]

minetest.register_chatcommand("pnode_lastpos", {

    params = "<> | -s",
    description = "Shows you the last Position of a found Node.\nUsage:\n<> shows you the last Position.\n-s Sends the last Position to Distancer",
    func = function(param)
        local cmd = param:lower()       
        prospector.pnode_lastpos(cmd)
                                            
    end -- function
                                            
}) -- chatcommand prospector_last_pos

minetest.register_chatcommand("pnode_list", {

    params = "<> | <searchpattern>",
    description = "Shows you all successfully found Nodes.\nUsage:\n<> Shows you the whole Nodelist with Index.\n<searchpattern> Shows you a filtered Nodelist with <searchpattern>.\n",
    func = function(param)
        if(param == nil) then param = "" end
        local cmd = param:lower()        
        prospector.show_nodelist(cmd)
                                            
    end -- function
                                            
}) -- chatcommand prospector_show_nodelist

minetest.register_chatcommand("pnode_search", {

    params = "<> | <Node> | <-i> index",
    description = "Shows you the given Nodes in a Radius of <.set_radius>.\nUsage:\n<> searches for the set node with command .set_node\n<Node> search for <Node>\n<-i> index searches for Node in the Nodelist.\n",
    func = function(param)
        local cmd = param:lower()        
        prospector.pnode_search(cmd)
                                              
    end -- function
                                            
}) -- chatcommand prospector_search_node

minetest.register_chatcommand("pnode_setradius", {

    params = "<> | <radius>",
    description = "Set's or shows you the the Radius for the command .search_for.\nUsage:\n<> Shows you the current Radius.\n<radius> set's a new Radius if valid.\n",
    func = function(param)
        prospector.pnode_setradius(param)    
    
    end -- function
                                        
}) -- chatcommand prospector_set_radius
    
minetest.register_chatcommand("pnode_set", {
        
    params = "<> | <Node> | <-i> index",
    description = "Set's a new Node for search.\nUsage:\n<> shows the current Node for search.\n<Node> set's a new Node.\n<-i> index set's a new Node for search from the Nodelist.\n",
    func = function(param)
        local cmd = param:lower()
        print(cmd)
        prospector.pnode_set(cmd)
                                
    end -- func

}) -- chatcommand prospector_set_node
        

--[[
   ****************************************************************
   *******        Main for Prospector                        ******
   ****************************************************************
--]]

-- Get yourself
prospector.you = minetest.localplayer

prospector.nodestring = prospector.storage:get_string("nodes") -- Get the Nodelist as String
if(prospector.nodestring ~= nil) then
    prospector.pnodelist = minetest.deserialize(prospector.nodestring) -- and write it to the list.
    prospector.print(prospector.green .. "Nodelist loaded.\n")
    
else
    prospector.pnodelist = {}
    prospector.print(prospector.red .. "No Nodelist found.\n")
    
end

-- Join to shared Modchannel
if(prospector.distancer_channelname ~= nil) then
    prospector.distancer_channel = minetest.mod_channel_join(prospector.distancer_channelname)
    minetest.register_on_modchannel_signal(function(channelname, signal)
            prospector.handle_channel_event(channelname, signal)
                                      
    end) -- minetest.register_on_modchannel_signal(

    minetest.register_on_modchannel_message(function(channelname, sender, message)
            prospector.handle_message(sender, message)
                                                                                
    end) -- minetest.register_on_mod_channel_message
    
    prospector.print(prospector.green .. "Channel for Distancer ready.\n")
    prospector.distancer_channel:send_all("Testmessage .. ")
    
else
    prospector.print(prospector.orange .. "No Channelname for Distancer found.\n")

end -- if(prospector.distancer_channel
    
prospector.show_version()
