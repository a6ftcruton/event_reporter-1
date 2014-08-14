require './test/test_helper'
require 'command_processor'

class CommandCommandProcessorTest < Minitest::Test
  def test_queue_is_cleared
    processor = CommandProcessor.new
    processor.repository_manager.queue << Entry.new({first_name: "Alice"})
    assert_equal 1, processor.repository_manager.queue.length
    assert_equal [], processor.repository_manager.queue.clear
  end

  def test_queue_can_be_printed
    data = [{:regdate => "11/12/08 10:47", :first_name => "Glen",:last_name => "Egbert",
      :email_address => "123@gmail.com", :home_phone => "303.564.9379", :street => "326 Wright Street",
      :city => "Lakewood", :state => "CO", :zipcode => "80228"}, {:regdate => "11/12/08 10:47", :first_name => "James",
      :last_name => "Brown", :email_address => "shebang@gmail.com", :home_phone => "303.123.9379", :street => "123 Get on Up Street",
      :city => "Downtown", :state => "CO", :zipcode => "87543"}]

    processor = CommandProcessor.new
    processor.repository_manager.instance_variable_set(:@queue, data.map { |row| Entry.new(row) })

    assert processor.print_out[0].include?("Glen")
    assert processor.print_out[1].include?("Brown")
  end

  def test_queue_can_be_sorted_before_printing
    data = [{:regdate => "11/12/08 10:47", :first_name => "Glen",:last_name => "Egbert",
      :email_address => "123@gmail.com", :home_phone => "303.564.9379", :street => "326 Wright Street",
      :city => "Lakewood", :state => "CO", :zipcode => "80228"}, {:regdate => "11/12/08 10:47", :first_name => "James",
      :last_name => "Brown", :email_address => "shebang@gmail.com", :home_phone => "303.123.9379", :street => "123 Get on Up Street",
      :city => "Downtown", :state => "CO", :zipcode => "87543"}]

    processor = CommandProcessor.new
    processor.repository_manager.instance_variable_set(:@queue, data.map { |row| Entry.new(row) })

    assert processor.print_by("city")[0].include?("Downtown")
  end

  def test_number_records_que_can_be_counted
    data = [{:regdate => "11/12/08 10:47", :first_name => "Glen",:last_name => "Egbert",
      :email_address => "123@gmail.com", :homephone => "303.564.9379", :street => "326 Wright Street",
      :city => "Lakewood", :state => "CO", :zipcode => "80228"}, {:regdate => "11/12/08 10:47", :first_name => "James",
      :last_name => "Brown", :email_address => "shebang@gmail.com", :homephone => "303.123.9379", :street => "123 Get on Up Street",
      :city => "Downtown", :state => "CO", :zipcode => "87543"}]

    processor = CommandProcessor.new
    processor.repository_manager.instance_variable_set(:@queue, data.map { |row| Entry.new(row) })

    assert_equal 2, processor.queue_count
  end


  def test_data_is_loaded_into_the_queue_by_default
    # data =   [{:regdate => "11/12/08 10:47", :first_name => "Glen",:last_name => "Egbert",
    #   :email_address => "123@gmail.com", :home_phone => "303.564.9379", :street => "326 Wright Street",
    #   :city => "Lakewood", :state => "CO", :zipcode => "80228"}, {:regdate => "11/12/08 10:47", :first_name => "James",
    #   :last_name => "Brown", :email_address => "shebang@gmail.com", :home_phone => "303.123.9379", :street => "123 Get on Up Street",
    #   :city => "Downtown", :state => "CO", :zipcode => "87543"}]
    #
    # processor = CommandProcessor.new
    #
    # processor.repository_manager.instance_variable_set(:@entries, data.map { |row| Entry.new(row) })
    #
    # assert_equal 2, processor.repository_manager.entries.length
    #
    # processor = CommandProcessor.new
    # assert_operator processor.repository_manager.entries.length, :>, 2

    processor = CommandProcessor.new

    assert_equal 0, processor.repository_manager.entries.length

    # processor = CommandProcessor.new(RepositoryManager.load_entries('event_two_attendees.csv'))

    processor.repository_manager.load_entries

    assert_equal 5175, processor.repository_manager.entries.length
  end

  def test_data_can_be_loaded_into_the_repository_manager_from_other_CSV_files
    processor = CommandProcessor.new

    assert_equal 0, processor.repository_manager.entries.length

    # processor = CommandProcessor.new(RepositoryManager.load_entries('event_two_attendees.csv'))

    processor.repository_manager.load_entries('event_two_attendees.csv')

    assert_equal 9, processor.repository_manager.entries.length
  end

  def test_data_in_queue_can_be_saved_to_a_file
    data =   [{:regdate => "11/12/08 10:47", :first_name => "Glen",:last_name => "Egbert",
      :email_address => "123@gmail.com", :homephone => "303.564.9379", :street => "326 Wright Street",
      :city => "Lakewood", :state => "CO", :zipcode => "80228"}, {:regdate => "11/12/08 10:47", :first_name => "James",
      :last_name => "Brown", :email_address => "shebang@gmail.com", :homephone => "303.123.9379", :street => "123 Get on Up Street",
      :city => "Downtown", :state => "CO", :zipcode => "87543"}]

    processor = CommandProcessor.new

    processor.repository_manager.instance_variable_set(:@queue, data.map { |row| Entry.new(row) })

    processor.save_queue("saved_data.csv")

    assert File.exist? "saved_data.csv"

  end
end
