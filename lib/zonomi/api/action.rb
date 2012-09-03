module Zonomi::API

class Action < OpenStruct

  ATTRIBUTES = [:action, :host, :name, :type, :value, :prio, :ttl]
  ACTIONS = {
    set:    'SET',
    query:  'QUERY',
    delete: 'DELETE',
    delete_zone: 'DELETEZONE',
    query_zones: 'QUERYZONES',
  }
  TYPES = {
    a:   'A',
    mx:  'MX',
    txt: 'TXT',
  }

  def attributes
    get_allowed_attributes
  end

  def to_hash
    format_attributes
  end

  def to_s
    attributes_to_params
  end

  def to_param
    attributes_to_params
  end

  def valid?
    validate_attributes!
  end

  private

  def get_allowed_attributes
    ATTRIBUTES.reduce({}) do |a,i|
      value = self.send(:"#{i}")
      if value
        a[i] = value
      end
      a
    end
  end

  def validate_attributes!
    validate_attributes_values!
  end

  def validate_attributes_values!
    conditions = [
      (attributes.has_key?(:action) ? ACTIONS.keys.include?(attributes[:action]) : true),
      (attributes.has_key?(:type)   ? TYPES.  keys.include?(attributes[:type  ]) : true),
    ]
    conditions.include?(false) ? raise(ArgumentError, 'Bad attributes values') : true
  end

  def format_attributes
    attrs = {}
    attributes.each do |k,v|
      attrs[k] = case k
      when :action
        ACTIONS[v]
      when :type
        TYPES[v]
      else
        v
      end
    end
    attrs
  end

  def attributes_to_params
    format_attributes.map.sort_by(&:first).
      map{ |k, v|
        [k,v].join('=')
      }.join('&')
  end

end

end
