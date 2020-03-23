--[[
   ****************************************************************
   *******                    Prospector                     ******
   *******    A CS-Mod to search for Nodes in Minetest       ******
   *******                  License: GPL 3.0                 ******
   *******                     by A.C.M.                     ******
   ****************************************************************
--]]

prospector = {}

prospector.modname = "Prospector"
prospector.version = 3
prospector.revision = 0

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

prospector.display_chat_message = minetest.display_chat_message

prospector.helpsystem = {}
--[[
   ****************************************************************
   *******        Functions for Prospector                   ******
   ****************************************************************
--]]

--[[
   ****************************************************************
   *******        Function check(command)                    ******
   ****************************************************************
    Check if the command is valid
--]]
function prospector.check(cmd)
        if(cmd ~= nil and cmd[1] ~= nil) then
            if(prospector[cmd[1]] ~= nil) then
            -- Command is valid, execute it with parameter
            prospector[cmd[1]](cmd)

            else -- A command is given, but
            -- Command not found, report it.
                if(cmd[1] ~= nil) then
                    prospector.print(prospector.red .. "Prospector: Unknown Command \n" ..
                                    prospector.orange .. cmd[1] .. prospector.red .. "\n.")

                else
                    if(prospector["help"]) then
                        prospector["help"]()

                    else
                        prospector.print(prospector.red .. "Unknown Command. No helpsystem available.")

                    end --if(prospector["help"]

                end -- if(cmd[1]

            end -- if(prospector[cmd[1
                
        else
            prospector.print(prospector.red .. "No Command for Prospector given.")
            prospector.print(prospector.red .. "Try .prs help.")
            
        end -- if(not cmd)
                    
end -- function prospector.check(cmd

--[[
   ****************************************************************
   *******         Function register_help()                  ******
   ****************************************************************
    Registers a new Entry in the Helpsystem for an Command.
]]--
function prospector.register_help(entry)

    prospector.helpsystem[entry.Name] = {
                                Name = entry.Name,
                                Usage = entry.Usage,
                                Description = entry.Description,
                                Parameter = entry.Parameter
                            }

end

function prospector.split(parameter)
    local cmd = {}
    if(parameter ~= "" or parameter ~= nil) then
        for word in string.gmatch(parameter, "[%w%-%:%_]+") do
            table.insert(cmd, word)

        end -- for word

    end -- if(parameter ~=

    return cmd

end -- function prospector.split


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
    prospector.print(prospector.green .. "Node: " .. prospector.orange .. node ..
    prospector.green .. " added to Nodelist.\n")
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

local find_node = minetest.find_node_near
local pos_to_string = minetest.pos_to_string
local string_to_pos = minetest.string_to_pos

function prospector.search_node(node)
    if(node == "") then
        prospector.print(prospector.green .. " No Nodename given!\n")

    else
        prospector.print(prospector.green .. "Searching for " .. prospector.yellow .. node .. prospector.green .. ".\n")
        local nodes = find_node(minetest.localplayer:get_pos(), prospector.searchRadius, node)

        if(nodes ~= nil) then
            prospector.print(prospector.green .. "Found at ".. prospector.orange .. pos_to_string(nodes) ..
            prospector.green .. ".\n")
            prospector.last_pos = minetest.pos_to_string(nodes)
            prospector.print(prospector.green .. "This is ".. prospector.yellow .. prospector.calc_distance() ..
            prospector.green .. " Nodes far away.\n")
            prospector.check_node(node)

            --prospector.print(prospector.grey .. dump(nodes))

        else
            prospector.print(prospector.yellow .. node .. prospector.green .. " not found.\n")

        end -- if(nodes

    end -- if(node == "")

end -- function search_node()

function prospector.calc_distance()
    return math.floor(vector.distance(minetest.localplayer:get_pos(), string_to_pos(prospector.last_pos)))

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

function prospector.set_node(node)
    if(node == nil or node == "") then -- No Node is given
        if(prospector.current_Node == "") then -- No current_Node is set
            prospector.print(prospector.red .. "There is no searching Node set. Use command set_node <Nodename>.\n")
            return
        else -- No Node is give, current_Node is set
            prospector.print(prospector.green .. "Current node is set to: " ..
            prospector.orange .. prospector.current_Node ..
            prospector.green ..".\n")
            return

        end -- if(prospector.current_Node

    end -- if(node == nil


    if(prospector.current_Node == "") then -- Node is given, but no current_Node set
        prospector.print(prospector.light_red .. "Old node wasn't set.\n")

    else -- Node is given and current_Node is a Node
        prospector.print(prospector.green .. "Old node was set to: " ..
        prospector.orange .. prospector.current_Node ..
        prospector.green ..".\n")

    end

    prospector.current_Node = node
    prospector.print(prospector.green .. "Current node set to: " ..
    prospector.orange .. prospector.current_Node ..
    prospector.green ..".\n")

end -- function set_node

function prospector.print(text)
    prospector.display_chat_message(text)

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

function prospector.show_version()
    print("[CSM-MOD]" .. prospector.modname .. " v " ..
    prospector.version .. "." ..
    prospector.revision .. " loaded. \n")

end -- function prospector.version

--[[
   ****************************************************************
   *******    Functions for MOD-Channel of Prospector        ******
   ****************************************************************
--]]

function prospector.handle_channel_event(channel, msg)
    local report
    if(msg >= 0) then
        if(msg == 0) then
            report = prospector.orange .. " joined with success.\n"

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

        prospector.print(prospector.green .. "[Prospector] Channel: " ..
        prospector.yellow .. channel ..
        prospector.green .. ": " ..
        prospector.orange .. report)

    end -- if(msg ~= 0

end -- function prospector.handle_channel_event(

function prospector.handle_message(channelname, sender, message)
  if(channelname == prospector.distancer_channelname) then
      prospector.print(prospector.green .. "Message from " ..
      prospector.orange .. sender ..
      prospector.green .. " received.\n")
      prospector.print(prospector.green .. "Message: " ..
      prospector.orange .. message ..
      prospector.green .. " .\n")

  end -- if(channelname

end -- distancer.handle_message

--[[
   ****************************************************************
   *******        Registered Chatcommands                    ******
   ****************************************************************
--]]

minetest.register_chatcommand("prs",{
    param = "<command> <parameter>",
    description = "Gives the Prospector a command with or without Parameter.\n",
    func = function(cmd)
                if(cmd.type == "string") then
                    cmd = cmd:lower()
                end
                local command = prospector.split(cmd)
                prospector.check(command)

            end -- function

}) -- minetest.register_chatcommand("dis

--[[
   ****************************************************************
   *******        Main for Prospector                        ******
   ****************************************************************
--]]

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
    minetest.register_on_modchannel_signal(function(channel, signal)
            prospector.handle_channel_event(channel, signal)

    end) -- minetest.register_on_modchannel_signal(

    minetest.register_on_modchannel_message(function(channel, sender, message)
            prospector.handle_message(channel, sender, message)

    end) -- minetest.register_on_mod_channel_message

else
    prospector.print(prospector.orange .. "No Channelname for Distancer found.\n")

end -- if(prospector.distancer_channel

--[[
minetest.after(5, function()
      if(prospector.distancer_channel:is_writeable()) then
        prospector.print(prospector.green .. "Modchannel is writeable.")
        prospector.distancer_channel:send_all("Testmessage.")

      else
        prospector.print(prospector.orange .. "Modchannel is writeprotected.")

      end -- if(prospector

  end -- function()
  )
  ]]--

dofile("prospector:cmd_help.lua")
dofile("prospector:cmd_lastpos.lua")
dofile("prospector:cmd_list.lua")
dofile("prospector:cmd_search.lua")
dofile("prospector:cmd_radius.lua")
dofile("prospector:cmd_set.lua")

prospector.show_version()
