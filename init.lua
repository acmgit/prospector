local you -- Player
local searchRadius = 100
local maxRadius = 300
local current_Node = ""
local last_pos = ""

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
    
        local node = param:lower()
        search_node(node)
                                            
    end -- function
                                            
}) -- chatcommand search_for

minetest.register_chatcommand("search", {

    params = "",
    description = "Shows you the given Nodes in a Radius of ".. searchRadius .. ".",
    func = function()
    
        if(searchNode == "") then
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
            --minetest.display_chat_message(grey .. dump(nodes))
                                            
        else
            minetest.display_chat_message(yellow .. node .. green .. " not found.\n")
        
        end -- if(nodes
                
    end -- if(node == "")
    
end -- function search_node()

function calc_distance()
    return math.floor(vector.distance(you:get_pos(), minetest.string_to_pos(last_pos)))

end -- function calc_distance
