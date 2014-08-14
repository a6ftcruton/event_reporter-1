require 'colorize'
require 'command_processor'

class CLI
  attr_reader :reader, :writer, :processor

  def initialize(reader = Reader.new($stdin), writer = Writer.new($stdout), processor = CommandProcessor.new)
    @reader = reader
    @writer = writer
    @processor = processor
    writer._print "Please first load a csv file upon which to build a queue.\n"
  end

  def run
    writer.prompt
    command_parts = get_command  
    send(command_parts[:part1], command_parts) if command_parts
  end

  alias_method :reset, :run

  def get_command
    command_parts = reader.read_command
    return command_parts if command_parts
    writer.invalid_message
    reset
  end

  def help(command_parts)
   help = command_parts[:part3] ? processor.help(command_parts[:part2]  + command_parts[:part3]) : processor.help(command_parts[:part2])
   writer._print(help)
   reset
  end

  def queue(command_parts)
    reset unless command_parts[:part2]
    command_parts[:part3] ? processor.send('queue' + '_' + command_parts[:part2], command_parts[:part3]) : processor.send('queue' + '_' + command_parts[:part2])
  end

  def load(command_parts)
    command_parts[:part2] ? processor.repository_manager.load_entries(command_parts[:part_2]) : processor.repository_manager.load_entries
  end

  def find(command_parts)
    reset unless command_parts[:part2] && command_parts[:part3]
    processor.find(command_parts[:part2], command_parts[:part3])
  end

  def quit(command_parts)
  end
  
  class Reader
    def initialize(input_stream)
      @input_stream = input_stream
    end

    def read_command
      command = gets.strip.downcase
      parse_command(command) if valid_command?(command)
    end

    def parse_command(command)
      parts = command_parser.match(command)
      command_parts = { part1: parts['part1'], part2: parts['part2'], part3: parts['part3'] }
      command_parts.delete_if { |k,v| v.empty? }
    end

    def valid_command?(command)
      available_commands.any? { |c| /#{c}/ =~ command }
    end

    def command_parser
      /^(?<part1>\w+)\s*(?<part2>\w*\s*(by|to)?)\s*(?<part3>\w*\s*(by|to)?)/
    end
    
    def available_commands
      ['help', 'quit', 'load', 'queue count', 'queue clear', 'queue print', 'queue print by', 'queue save to', 'find']
    end

    private
    attr_reader :input_stream
  end

  class Writer
    def initialize(output_stream)
      @output_stream = output_stream
    end

    def _print(message)
      output_stream.print message
    end

    def prompt
      _print '>>'.colorize(:cyan)
    end

    def invalid_message
      _print "Invalid command or use of command. Enter 'help' for a list of valid commands.\n".colorize(:magenta)
    end

    private
    attr_reader :output_stream
  end

end
