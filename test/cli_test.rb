require 'simplecov'
SimpleCov.start
require './test/test_helper'
require 'cli'

class CLI_Test < Minitest::Test
  attr_reader :reader, :writer

  def setup
    @reader    = MockReader.new
    @writer    = MockWriter.new
    @processor = MockProcessor.new
    @cli       = CLI.new(@reader, @writer)
  end

end

class MockReader < CLI::Reader
  attr_reader :times_read,
              :command_responses,

  def initialize
    @times_read        = 0
    @command_responses = []
  end

  def read_command
    raise "No more responses!" if command_responses.empty?
    @times_read += 1
    interpret_command command_responses.shift
  end

  def read_board_size
    raise "No more responses!" if board_selections.empty?
    @times_read += 1
    interpret_board_size board_selections.shift
  end
end

class MockWriter

  attr_reader :messages_written

  def initialize
    @messages_written = []
  end

  def _print(message)
    @messages_written << message
  end
end

class MockProcessor
  attr_reader :methods_called

  def initializer
    @methods_called = []
  end

  def method_missing(method)
    methods_called << method
  end
end
