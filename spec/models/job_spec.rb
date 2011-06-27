require 'spec_helper'

describe Job do

  before(:each) do
    @attr = { :title => 'programmer', :company_name => 'ACME', :user_id => '1' }
  end

  it "should accept valid attributes" do
    j = Job.new(@attr)
    j.should be_valid
  end

  it "should not allow having both title and company_name empty" do
    @attr.merge!({ :title => '', :company_name => '' })
    j = Job.new(@attr)
    j.should_not be_valid
  end

end
