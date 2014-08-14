require 'help_message'
require 'repository_manager'
require 'entry'

class CommandProcessor
  attr_accessor :repository_manager

  include HelpMessage

  def initialize(repository_manager = RepositoryManager.new)
    @repository_manager = repository_manager
  end

  def print_out
    headers
    repository_manager.queue.map { |entry| entry_format(entry)}
  end

  def headers
    "LAST NAME".ljust(24, " ") + "FIRST NAME".ljust(24, " ") + "EMAIL".ljust(24, " ") + "ZIPCODE".ljust(12, " ") + "CITY".ljust(24, " ") + "STATE".ljust(20, " ") + "ADDRESS".ljust(28, " ") + "PHONE".ljust(18, " ")
  end

  def print_by(field)
      repository_manager.queue.sort_by {|entry| entry.send(field)}.map{|entry| entry_format(entry)}
  end

  def entry_format(entry)
    "#{entry.last_name}".ljust(24, " ")+
    "#{entry.first_name}".ljust(24, " ")+
    "#{entry.email_address}".ljust(24, " ")+
    "#{entry.zipcode}".ljust(12, " ")+
    "#{entry.city}".ljust(24, " ")+
    "#{entry.state}".ljust(20, " ")+
    "#{entry.street}".ljust(28, " ")+
    "#{entry.homephone}".ljust(18," ")
  end

  def queue_count
    repository_manager.queue.length
  end

  def find(field, match)
    repository_manager.queue = repository_manager.entries.select{ |entry| entry.send(field) == match}
  end

  def save_queue(to_file="saved_data.csv")
    File.open(to_file, "w") do |file|
      file.puts headers
      @repository_manager.queue.each { |entry| file.puts entry_format(entry) }
      # file.puts @repository_manager.queue.each{|entry| puts entry_format(entry)}
      end
 end

end

#refactor
#split out some classes
#
