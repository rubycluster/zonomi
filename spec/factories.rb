FactoryGirl.define do

  factory :client, class: Zonomi::API::Client do
    api_key TEST_API_KEY
  end

  factory :action, class: Zonomi::API::Action do
  end

end
