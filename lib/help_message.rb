module HelpMessage
  def help(command = nil)
    return help_command(command) if command
    available_commands.reduce("") { |text,command| text + help_command(command) + "\n" }
  end

  def help_command(command)
    case command
    when "help" then "help:  lists all available commands\n"
    when "quit" then "quit:  exit the program\n"
    when "load" then "load <filename.csv>:  erase any loaded data and parse the specified file\n"
    when "queue count" then "queue count:  counts the number of records in the current queue.\n"
    when "queue clear" then "queue clear:  empties the current queue. Queue will remain empty until the next find command.\n"
    when "queue print" then "queue print:  prints out a table of the queue.\n"
    when "queue print by" then "queue print by <attribute>:  prints out a table of the queue sorted by attribute.\n"
    when "queue save to" then "queue save to <filename.csv>:  exports the queue to the specified csv file. WARNING: saving will overwrite all file contents.\n"
    when "find" then "find <attribute> <criteria>:  load the queue with all records matching the criteria for the given attribute.\n"
    else "Invalid entry: #{command} is not a command.\nThe following are all valid commands.\n"; help_command
    end
  end

end

  def available_commands
      ["help", "quit", "load", "queue count", "queue clear", "queue print", "queue print by", "queue save to", "find"]
  end

