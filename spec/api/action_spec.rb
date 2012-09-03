require 'spec_helper'

describe Zonomi::API::Action do

  let(:domain_name) { TEST_DOMAIN_NAME }

  context "valid" do

    context 'should accept attributes' do

      describe 'action, name' do
        subject { build(:action, action: :query, name: domain_name) }
        its(:name)   { should == domain_name }
        its(:action) { should == :query }
        its(:attributes)  { should == { action: :query, name: domain_name } }
        its(:to_hash) { should == { action: 'QUERY', name: domain_name } }
        its(:to_param) { should == "action=QUERY&name=#{domain_name}" }
      end

      describe 'and preserve keys order in hash' do
        subject { build(:action, value: '127.0.0.1', type: :a, action: :set, name: domain_name) }
        its(:to_param) { should == "action=SET&name=#{domain_name}&type=A&value=127.0.0.1" }
      end

    end

  end

  context "invalid" do

    describe "with bad attributes keys" do
      pending
    end

    describe "with bad attributes values" do
      bad_attributes_scenarios = [
        { action: :hack },
        { type: :root },
      ]
      bad_attributes_scenarios.each_with_index do |bad_attributes, index|
        it "Scenario ##{index + 1}: should raise an argument error" do
          expect { build(:action, bad_attributes).valid? }.to raise_error(ArgumentError)
        end
      end
    end

  end

end
