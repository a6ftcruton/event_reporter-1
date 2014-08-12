require 'help_message'

class CLI
  attr_reader :reader, :writer
  
  include HelpMessage

  def initialize(reader = Reader.new($stdin), writer = Writer.new($stdout))
    @reader = reader
    @writer = writer
  end

  def run
    writer.print_message "Please load a csv file from to build a queue. Enter help for help using this program."
  end

  class Reader
    def initialize(input_stream)
      @input_stream = input_stream
    end
    
    private
      attr_reader :input_stream
  end

  class Writer
    def initialize(output_stream)
      @output_stream = output_stream
    end

    def print_message(message)
      output_stream.print message
    end

    def print_prompt
      output_stream.print '>>'
    end

    private
      attr_reader :output_stream
  end

end