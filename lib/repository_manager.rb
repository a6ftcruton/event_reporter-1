require 'entry'
require 'csv'

class RepositoryManager
  attr_reader :entries
  attr_accessor :queue

  def self.load_entries(file='event_attendees.csv')
    data = parse_csv(file)
    rows = data.map { |row| Entry.new(row) }
    new(rows)
  end

  def initialize(entries)
    @entries = entries
    @queue = []
  end

  def find(attribute, criteria)
    self.queue = entries.select { |entry| entry.send(attribute) =~ /^#{criteria}$/i }
    "The queue has been populated by #{attribute} of #{criteria.upcase}\n"
  end

  private

  def self.parse_csv(file)
    path = File.realdirpath(__FILE__)
    directory = File.dirname(path)
    data = CSV.open(directory + '/data/' + file, headers: true, header_converters: :symbol)
  end

end
