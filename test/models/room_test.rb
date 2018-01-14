require 'test_helper'

class RoomTest < ActiveSupport::TestCase

  def setup
    @room = Room.new(name: "SampleRoom1", maximum: 8)
  end

  test "should be valid" do
    assert @room.valid?
  end

  test "shoud be invalid" do
    @room.name = "     "
    assert_not @room.valid?
  end
end
