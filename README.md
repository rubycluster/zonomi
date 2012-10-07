# Zonomi

Zonomi DNS API wrapper written in Ruby.

> https://zonomi.com/app/dns/dyndns.jsp

## Usage

### API Client

First create new API client instance:

    client = Zonomi::API::Client.new(api_key: "YOUR_API_KEY")

> Zonomi API keys are managed at: https://zonomi.com/app/cp/apikeys.jsp

### API actions

All actions are performed via:

    client.api

#### Records

Fetch all DNS records by name:

    client.api.records_by_name(name)

Fetch all DNS records ending with name:

    client.api.records_by_name(name, all_records: true)

IP address:

    client.api.set_current_ipaddress_to_host(host)
    client.api.change_ip(old_ip, new_ip)

A type records:

    client.api.set_ipaddress_for_a_record_for(name, value)
    client.api.delete_ipaddress_for_a_record_for(name)

MX type records:

    client.api.set_mx_record_for(name, value, prio = 5)

#### Zones:

Fetch all DNS zones:

    client.api.zones

Manage DNS zones:

    client.api.add_zone(name)
    client.api.delete_zone(name)
    client.api.convert_zone_to_master(name)
    client.api.convert_zone_to_slave(name, master)

## Installation

Add this line to your application's Gemfile:

    gem 'zonomi'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install zonomi

## TODO

- Records and Zones should have active methods
- Command line tool
- Better test coverage
- Better documentation

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
