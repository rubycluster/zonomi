module Zonomi::API

class Adapter

  attr_reader :client, :actions, :requests, :responses, :results

  def initialize(client)
    @client    = client
    @actions   = []
    @requests  = []
    @responses = []
    @results   = []
    self
  end

  # Set the IP Address for 'some-test-domain.com' to your PC's address. Right now that is 176.52.37.118.
  # https://zonomi.com/app/dns/dyndns.jsp?host=some-test-domain.com&api_key=api_key_hash

  def set_current_ipaddress_to_host(host)
    query!(:set_current_ipaddress_to_host, host: host)
  end

  # Set an IP Address (A) record
  # https://zonomi.com/app/dns/dyndns.jsp?action=SET&name=some-test-domain.com&value=10.0.0.1&type=A&api_key=api_key_hash

  def set_ipaddress_for_a_record_for(name, value)
    query!(:set_ipaddress_for_a_record_for, name: name, value: value)
  end

  # Delete an IP Address (A) record
  # https://zonomi.com/app/dns/dyndns.jsp?action=DELETE&name=some-test-domain.com&type=A&api_key=api_key_hash

  def delete_ipaddress_for_a_record_for(name)
    query!(:delete_ipaddress_for_a_record_for, name: name)
  end

  # Set an MX Record
  # https://zonomi.com/app/dns/dyndns.jsp?action=SET&name=some-test-domain.com&value=mail.some-test-domain.com&type=MX&prio=5&api_key=api_key_hash

  def set_mx_record_for(name, value, prio = 5)
    query!(:set_mx_record_for, name: name, value: value, prio: prio)
  end

  # Retrieve a list of records with the specified name.
  # https://zonomi.com/app/dns/dyndns.jsp?action=QUERY&name=some-test-domain.com&api_key=api_key_hash

  # Retrieve all records ending in some-test-domain.com. e.g. letting you fetch all records in a DNS zone.
  # https://zonomi.com/app/dns/dyndns.jsp?action=QUERY&name=**.some-test-domain.com&api_key=api_key_hash

  def records_by_name(name, options = {})
    all_records = options.delete(:all_records) || false
    if all_records
      name.gsub!(%r{^\W+}, '')
      name = '**.' + name
    end

    query!(:records_by_name, name: name)
    respond_value_for(results.last, :records_by_name).map do |record_hash|
      Record.new(record_hash)
    end
  end

  # Multiple actions: set two records to the same IP and delete the bar.some-test-domain.com IP Address (A) record.
  # https://zonomi.com/app/dns/dyndns.jsp?action[1]=SET&name[1]=some-test-domain.com,bar.some-test-domain.com&value[1]=10.0.0.1&action[2]=DELETE&host[2]=bar.some-test-domain.com&api_key=api_key_hash

  # Multiple actions: set multiple different values for a particular name. e.g. for setting multiple MX servers (like with gmail).
  # https://zonomi.com/app/dns/dyndns.jsp?action[1]=SET&name[1]=some-test-domain.com&value[1]=ASPMX.L.GOOGLE.COM&prio[1]=1&type[1]=MX&action[2]=SET&name[2]=some-test-domain.com&value[2]=ALT1.ASPMX.L.GOOGLE.COM&prio[2]=2&type[2]=MX&action[3]=SET&name[3]=some-test-domain.com&value[3]=ALT2.ASPMX.L.GOOGLE.COM&prio[3]=3&type[3]=MX&action[4]=SET&name[4]=some-test-domain.com&value[4]=ASPMX2.GOOGLEMAIL.COM&prio[4]=4&type[4]=MX&action[5]=SET&name[5]=some-test-domain.com&value[5]=ASPMX3.GOOGLEMAIL.COM&prio[5]=5&type[5]=MX&api_key=api_key_hash

  # Setup a new DNS zone.
  # https://zonomi.com/app/dns/addzone.jsp?name=some-test-domain.com&api_key=api_key_hash

  def add_zone(name)
    query!(:add_zone, name: name)
  end

  # Delete a DNS zone.
  # https://zonomi.com/app/dns/dyndns.jsp?action=DELETEZONE&name=some-test-domain.com&api_key=api_key_hash

  def delete_zone(name)
    query!(:delete_zone, name: name)
  end

  # Return a list of zones on your account.
  # https://zonomi.com/app/dns/dyndns.jsp?action=QUERYZONES&api_key=api_key_hash

  def zones
    query!(:zones)
    respond_value_for(results.last, :zones).map do |zone_hash|
      Zone.new(zone_hash)
    end
  end

  # Convert a zone to a slave zone with the specified master name server IP address.
  # https://zonomi.com/app/dns/converttosecondary.jsp?name=some-test-domain.com&master=0.0.0.0&api_key=api_key_hash

  def convert_zone_to_slave(name, master)
    query!(:convert_zone_to_slave, name: name, master: master)
  end

  # Convert a zone from a slave zone back to a 'regular' zone (where you manage your DNS records via our web pages and API).
  # https://zonomi.com/app/dns/converttomaster.jsp?name=some-test-domain.com&api_key=api_key_hash

  def convert_zone_to_master(name)
    query!(:convert_zone_to_master, name: name)
  end

  # Change an IP across all your zones.
  # https://zonomi.com/app/dns/ipchange.jsp?old_ip=0.0.0.0&new_ip=0.0.0.0&api_key=api_key_hash

  def change_ip(old_ip, new_ip)
    query!(:change_ip, old_ip: old_ip, new_ip: new_ip)
  end

  # Multiple actions: set two records to the same IP and delete the
  # bar.some-test-domain.com IP Address (A) record

  # Multiple actions: set multiple different values for a particular
  # name. e.g. for setting multiple MX servers (like with gmail).

  private

  def query!(result_type, params = {})
    action = Action.new(action_params(result_type, params))
    action.valid?
    request_params = action.to_hash.merge({
      request_path: path_for_result_type(result_type)
    })
    request = self.client.api_request(request_params)
    request.send!

    @actions   << action
    @requests  << request
    @responses << request.response
    @results   << request.result

    self
  end

  def action_params(result_type, params)
    default_action_params(result_type).merge(params)
  end

  def default_action_params(result_type)
    case result_type
    when :records_by_name
      { action: :query }
    when :set_ipaddress_for_a_record_for
      { action: :set, type: :a }
    when :delete_ipaddress_for_a_record_for
      { action: :delete, type: :a }
    when :set_mx_record_for
      { action: :set, type: :mx, prio: 5 }
    when :delete_zone
      { action: :delete_zone }
    when :zones
      { action: :query_zones }
    else
      {}
    end
  end

  def path_for_result_type(result_type)
    case result_type
    when :add_zone
      [:zone, :add]
    when :convert_zone_to_slave
      [:zone, :to_slave]
    when :convert_zone_to_master
      [:zone, :to_master]
    when :change_ip
      :ipchange
    else
      :dyndns
    end
  end

  def respond_value_for(result, result_type)
    case result_type
    when :records_by_name
      result.actions['action']['record']
    when :zones
      result.actions['action']['zone']
    end
  end

end

end
