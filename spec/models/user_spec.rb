
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

    context "malformed" do
      it "should not be valid" do
        u = User.new(@attr.merge(:email => '00000'))
        u.should_not be_valid
      end
    end

  end

  describe "uuid" do
    it "should be present" do
      u = User.new(@attr.delete :uuid)
      u.should_not be_valid
    end

    it "length should be 16" do
      u = User.new(@attr.merge(:uuid => '12345'))
      u.should_not be_valid
    end
  end

  context "password existing" do
    it "should fail without salt" do
      u = User.new(@attr.merge(:crypted_password => 'liuhlhjkjhlkj'))
      u.should_not be_valid
    end

    it "should fail without persistence_token" do
      u = User.new(@attr.merge(:crypted_password => 'liuhlhjkjhlkj'))
      u.should_not be_valid
    end

    it "should create user if salt and token are present" do
      u = User.create!(@attr.merge(:crypted_password => 'liuhlhjkjhlkj',
                               :password_salt => 'aaaa',
                               :persistence_token => 'bbbb'))
    end

    describe "confirmation email" do
      it "should be sent" do
        u = User.new(@attr)
        u.send_confirmation_email.should be_true
      end
    end
  end
end

