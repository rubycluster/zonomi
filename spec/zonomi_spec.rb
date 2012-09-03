require 'spec_helper'

describe Zonomi do

  specify { TEST_API_KEY.should_not be_nil }
  specify { TEST_DOMAIN_NAME.should_not be_nil }

  subject { Zonomi }

  it { should be_a(Module) }
  its(:constants) { should include(:'VERSION', :'API') }
  it "should have a valid version" do
    subject::VERSION.should =~ %r{^(\d*\.){2,3}(\d|\w*)$}
  end

end
