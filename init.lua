local you -- Player
local searchRadius = 100
local maxRadius = 300
local current_Node = ""
local last_pos = ""
local pnodelist = {}
local nodestring = ""           -- String to load
local prospector_storage = minetest.get_mod_storage()

-- Colors for Chat
local green = minetest.get_color_escape_sequence('#00FF00')
local red = minetest.get_color_escape_sequence('#FF0000')
local orange = minetest.get_color_escape_sequence('#FF6700')
local blue = minetest.get_color_escape_sequence('#0000FF')
local yellow = minetest.get_color_escape_sequence('#FFFF00')
local purple = minetest.get_color_escape_sequence('#FF00FF')
local pink = minetest.get_color_escape_sequence('#FFAAFF')
local white = minetest.get_color_escape_sequence('#FFFFFF')
local black = minetest.get_color_escape_sequence('#000000')
local grey = minetest.get_color_escape_sequence('#888888')
local light_blue = minetest.get_color_escape_sequence('#8888FF')
local light_green = minetest.get_color_escape_sequence('#88FF88')
local light_red = minetest.get_color_escape_sequence('#FF8888')

-- Get yourself
minetest.register_on_connect(function()
    you = minetest.localplayer               
end)

nodestring = prospector_storage:get_string("nodes") -- Get the Nodelist as String
if(nodestring ~= nil) then
    pnodelist = minetest.deserialize(nodestring) -- and write it to the list.
    minetest.display_chat_message(green .. "Nodelist loaded.\n")
    
else
    nodelist = ""
    minetest.display_chat_message(green .. "No Nodelist found.\n")
    
end


minetest.register_chatcommand("last_pos", {

    params = "",
    description = "Shows you the last Position of a found Node.",
    func = function()
        
        if(last_pos ~= "") then
            minetest.display_chat_message(green .. "The last found was at: " .. orange .. last_pos .. green .. ".\n")
            minetest.display_chat_message(green .. "This is ".. yellow .. calc_distance() .. green .. " Nodes far away.\n")
        else
            minetest.display_chat_message(green .. "There is no last Found set.\n")
                                          
        end
                                          
                                            
    end -- function
                                            
}) -- chatcommand last_pos

minetest.register_chatcommand("search_for", {

    params = "node",
    description = "Shows you the given Nodes in a Radius of ".. searchRadius .. ".",
    func = function(param)
                                            
        if(param == nil) then
                minetest.display_chat_message(green .. "No Node given. Usage: search_for <node>.\n")
                return
        end

        local node = param:lower()
        node = node:trim()
        search_node(node)
                                            
    end -- function
                                            
}) -- chatcommand search_for

minetest.register_chatcommand("search_for_index", {

    params = "idx",
    description = "Shows you the given Node at Entry " .. yellow .. "<idx>" .. green .. " from the Nodelist in a Radius of ".. searchRadius .. ".",
    func = function(param)
        
        if(param == nil) then
                minetest.display_chat_message(green .. "No Index set. Usage: search_for_index <idx>.\n")
                return
        end
                                                  
        local idx = param:lower()
        idx = tonumber(idx:trim())
        
        local node = pnodelist[idx]
                      
        if(node ~= nil) then
            search_node(node)
                      
        else
            minetest.display_chat_message(green .. "No Node found at Entry " .. yellow .. idx .. green .. " in the Nodelist.\n")
        
        end
                                            
    end -- function
                                            
}) -- chatcommand search_for

minetest.register_chatcommand("show_nodelist", {

    params = "",
    description = "Shows you all successfully found Nodes.",
    func = function()
        show_nodelist()
                                            
    end -- function
                                            
}) -- chatcommand search_for

minetest.register_chatcommand("filter_nodelist", {

    params = "filter",
    description = "Shows you all successfully found Nodes.",
    func = function(param)
                                                 
        if(param == nil) then
            show_nodelist()
            return
                                                 
        end
                                                 
        local filter = param:lower()
        filter = filter:trim()
        filter_nodelist(filter)
                                            
    end -- function
                                            
}) -- chatcommand search_for

minetest.register_chatcommand("search", {

    params = "",
    description = "Shows you the given Nodes in a Radius of ".. searchRadius .. ".",
    func = function()
    
        if(current_Node == "") then
            minetest.display_chat_message(green .. "There is no searching Node set. Use command set_node <Nodename>.\n")
                                        
        else
            search_node(current_Node)
                                        
        end
                                        
    end -- function
                                            
}) -- chatcommand search

minetest.register_chatcommand("set_radius", {

    params = "radius",
    description = "Set's or shows you the the Radius for the command .search_for.",
    func = function(param)
        
        if(param == nil) then
                minetest.display_chat_message(green .. "No Radius given. Usage: set_radius <radius>.\n")
                return
        end
                                            
        local radius = tonumber(param:trim())
        minetest.display_chat_message(green .. " Current Radius = " .. orange .. searchRadius .. green .. ".\n")
        minetest.display_chat_message(green .. " Max Radius = " .. red .. maxRadius .. green .. ".\n")
                                            
        if(radius ~= nil and radius > 0 and radius <= maxRadius) then
            searchRadius = radius
            minetest.display_chat_message(green .. " New Radius set to " .. yellow .. searchRadius .. green ..".\n")
                                            
        end
    
    end -- function
                                        
}) -- chatcommand set_radius

minetest.register_chatcommand("set_node", {
        
    params = "node",
    description = "Set's an new Node or shows the current Node for search.",
    func = function(param)
    
        if(param == nil) then
                minetest.display_chat_message(green .. "No Node given. Usage: set_node <node>.\n")
                return
        end

        local node = param:lower()
        node = node:trim()
                                          
        if(node == "") then
                                          
            if(current_Node ~= "") then
                minetest.display_chat_message(green .. "Current node is set to: " .. orange .. current_Node .. green ..".\n")
                                          
            else
                minetest.display_chat_message(green .. "There is no searching Node set. Use command set_node <Nodename>.\n")
                                          
            end -- if(current_Node ~= ""
                                          
        else
            
            minetest.display_chat_message(green .. "Old node was set to: " .. orange .. current_Node .. green ..".\n")
            current_Node = node
            minetest.display_chat_message(green .. "Current node set to: " .. orange .. current_Node .. green ..".\n")
    
        end -- if(node == ""
    
    end -- function

}) -- chatcommand set_node

minetest.register_chatcommand("set_node_index", {
        
    params = "idx",
    description = "Set's an new Node from the Nodelist at <idx>.",
    func = function(param)

        if(param == nil) then
                minetest.display_chat_message(green .. "No Index given. Usage: set_node_index <idx>.\n")
                return
        end

        local idx = param:lower()
        idx = tonumber(idx:trim())
        
        local node = pnodelist[idx]
                                                
        if(node == nil) then
            minetest.display_chat_message(green .. "No Node found in list at Entry Nr.: " .. orange .. idx .. green ..".\n")
                                          
        else
            minetest.display_chat_message(green .. "Old node was set to: " .. orange .. current_Node .. green ..".\n")
            current_Node = node
            minetest.display_chat_message(green .. "Current node set to: " .. orange .. current_Node .. green ..".\n")
    
        end -- if(node == ""
    
    end -- function

}) -- chatcommand set_node

minetest.register_chatcommand("who_is", {

    params = "",
    description = "Shows you all online Playernames.",
    func = function()
    
        local online = minetest.get_player_names()
        if(online == nil) then 
                minetest.display_chat_message(green .. "No Player is online?\n")
                return
                                        
        else
            table.sort(online)
    
        end
                                            
        minetest.display_chat_message(green .. "Player now online:\n")
                                        
        for pl, name in ipairs(online) do
            minetest.display_chat_message(green .. pl .. ": " .. orange .. name .. "\n")
        
        end -- for
    end -- function
                                            
}) -- chatcommand search

function show_nodelist()
    
    minetest.display_chat_message(green .. "Show the Nodelist:\n")
    
    for idx,entry in pairs(pnodelist) 
    do
            minetest.display_chat_message(yellow .. idx .. ": " .. orange .. entry .. green .."\n")
            
    end -- for _,key
    
end -- function(show_nodelist

function filter_nodelist(filter)
    
    minetest.display_chat_message(green .. "Show the Nodelist only with: " .. orange .. filter .. green .. ".\n")
    
    for idx,entry in pairs(pnodelist) 
    do
            local hit = string.find(entry, filter)
            if(hit ~= nil) then
                minetest.display_chat_message(yellow .. idx .. green .. ": " .. orange .. entry .. green .."\n")
                
            end
            
    end -- for _,key
    
end -- function(show_nodelist

function check_node(node)

    for _,entry in pairs(pnodelist)
    do
        if(entry == node) then
            return
            
        end
        
    end -- for
    
    add_node(node)
    minetest.display_chat_message(green .. "Node: " .. orange .. node .. green .. " added to Nodelist.\n")
    table.sort(pnodelist)
    nodestring = minetest.serialize(pnodelist)
    prospector_storage:set_string("nodes", nodestring) -- Saves the Table
    
end -- function check_node

function add_node(node)
    table.insert(pnodelist, node)
    
end -- function add_node

function search_node(node)
    
    if(node == "") then 
        minetest.display_chat_message(green .. " No Nodename given!\n")
                                            
    else
        minetest.display_chat_message(green .. "Searching for " .. yellow .. node .. green .. ".\n")
        local nodes = {}
        nodes = minetest.find_node_near(you:get_pos(), searchRadius, node)
                                            
        if(nodes ~= nil) then
            minetest.display_chat_message(green .. "Found at ".. orange .. minetest.pos_to_string(nodes) .. green .. ".\n")
            last_pos = minetest.pos_to_string(nodes)
            minetest.display_chat_message(green .. "This is ".. yellow .. calc_distance() .. green .. " Nodes far away.\n")
            check_node(node)
            
            --minetest.display_chat_message(grey .. dump(nodes))
                                            
        else
            minetest.display_chat_message(yellow .. node .. green .. " not found.\n")
        
        end -- if(nodes
                
    end -- if(node == "")
    
end -- function search_node()

function calc_distance()
    return math.floor(vector.distance(you:get_pos(), minetest.string_to_pos(last_pos)))

end -- function calc_distance
