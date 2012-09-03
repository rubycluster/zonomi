require 'spec_helper'

describe Zonomi::API::Client do

  before(:all) {
    @client = build(:client)
  }

  subject { @client }

  it { should respond_to(:api_key) }
  its(:api_key) { should eq(TEST_API_KEY) }

  it { should respond_to(:api) }
  its(:api) { should be_a_kind_of(Zonomi::API::Adapter) }

  it { should respond_to(:api_request) }
  it { should respond_to(:api_request).with(1).arguments }

end
