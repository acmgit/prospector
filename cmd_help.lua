prospector.register_help({
                            Name = "help",
                            Usage = ".prs help <> | <command>",
                            Description = "Helpsystem for the Prospector.",
                            Parameter = "<> | <command>" .. prospector.green .. "." ..
                                        "\n" .. prospector.orange .. "<>" ..
                                        prospector.green.. " - Shows you the entire help for prospector." ..
                                        "\n" .. prospector.orange .. "<command>" ..
                                        prospector.green .. " - Shows you the help for the prospector-command."
                        })

prospector["help"] = function(parameter)
    if(parameter[2] == nil or parameter[2] == "") then
        prospector.print(prospector.green .. "Commands for the Prospector " .. prospector.orange ..
                        prospector.version .. "." .. prospector.revision .. prospector.green .. ".")
        for _,value in pairs(prospector.helpsystem) do
            prospector.print(prospector.yellow .. "---------------")
            prospector.print(prospector.green .. "Name: " .. prospector.orange .. value.Name)
            prospector.print(prospector.green .. "Description: " .. prospector.yellow .. value.Description)
            prospector.print(prospector.green .. "Usage: " .. prospector.orange .. value.Usage)
            prospector.print(prospector.green .. "Parameter: " .. prospector.orange .. value.Parameter)
        end -- for _,value
        prospector.print(prospector.yellow .. "---------------")

    else
        if(prospector.helpsystem[parameter[2]] ~= nil) then
            prospector.print(prospector.green .. "Name: " .. prospector.orange ..
                            prospector.helpsystem[parameter[2]].Name)
            prospector.print(prospector.green .. "Description: " .. prospector.yellow ..
                            prospector.helpsystem[parameter[2]].Description)
            prospector.print(prospector.green .. "Usage: " .. prospector.orange ..
                            prospector.helpsystem[parameter[2]].Usage)
            prospector.print(prospector.green .. "Parameter: " .. prospector.orange ..
                            prospector.helpsystem[parameter[2]].Parameter)

        else
            prospector.print(prospector.red .. "No entry in help for command <" ..
                            prospector.orange .. parameter[2] .. prospector.red .. "> found.")

        end -- if(prospector.help[parameter[2

    end -- if(parameter[2]

end -- function help
