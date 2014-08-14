require 'help_message'
require 'repository_manager'
require 'entry'

class CommandProcessor
  attr_accessor :repository_manager

  include HelpMessage

  def initialize
    @repository_manager = nil
  end

  def load(file='event_attendees.csv')
    self.repository_manager = RepositoryManager.load_entries(file)
  end

  def queue_print
    if repository_manager
      headers
      repository_manager.queue.map { |row| entry_format(row) }
    end
  end

  def headers
    "LAST NAME".ljust(24, " ") +
    "FIRST NAME".ljust(24, " ") +
    "EMAIL".ljust(24, " ") +
    "ZIPCODE".ljust(12, " ") +
    "CITY".ljust(24, " ") +
    "STATE".ljust(20, " ") +
    "ADDRESS".ljust(28, " ") +
    "PHONE".ljust(18, " ")
  end

  def queue_print_by(field)
    if repository_manager
    repository_manager.queue.sort_by { |row| row.send(field) }
                            .map { |row| entry_format(row) }
    end
  end

  def entry_format(row)
    "#{row.last_name}".ljust(24, " ")+
    "#{row.first_name}".ljust(24, " ")+
    "#{row.email_address}".ljust(24, " ")+
    "#{row.zipcode}".ljust(12, " ")+
    "#{row.city}".ljust(24, " ")+
    "#{row.state}".ljust(20, " ")+
    "#{row.street}".ljust(28, " ")+
    "#{row.homephone}".ljust(18," ")
  end

  def queue_count
    repository_manager ? repository_manager.queue.length : 0
  end

  def find(attribute, criteria)
    repository_manager ? repository_manager.find(attribute, criteria) : "You must first load a CSV."
  end

  def queue_clear
    repository_manager.queue.clear
  end

  def queue_save_to(file="saved_data.csv")
    if repository_manager
      path = File.realdirpath(__FILE__)
      directory = File.dirname(path)
      File.open(directory + '/data/' + file, "w") do |file|
        file.puts headers
        repository_manager.queue.each { |row| file.puts entry_format(row) }
      end
    else
    "You must first load a CSV, and execute a find query."
    end
  end

end
