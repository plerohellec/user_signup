
require 'spec_helper'

describe User do

  before(:each) do
    @attr = {
      :email => "user@example.com",
      :uuid => "aaaaaaaaaaaaaaaa",
    }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end

  describe "email address" do

    it "should be real" do
      User.new(@attr.merge(:email => '00000')).
        should_not be_valid
    end

  end
end

