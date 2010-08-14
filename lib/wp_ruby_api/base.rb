require 'wp_ruby_api/exceptions'

module WpRubyApi
  
  class Base
    cattr_accessor :site
    
    class << self
      
      # get info about certain controller
      # corresponds to the 'info' - API-Method
      
      def info(controller_name)
        request(:json => 'info', :controller => controller_name.to_s)
      end
      
      # get date index
      # corresponds to the 'get_date_index' - API-Method
      
      def date_index
        request(:json => 'get_date_index')
      end
      
      # get nonce value. Needed to create a post via API
      # corresponds to the 'get_nonce' - API-Method
      
      def nonce(controller_name, method_name)
        request(:json => 'get_nonce', :controller => controller_name.to_s, :method => method_name.to_s)
      end
      
      protected
      
      def find_single(request_params, response_key)
        json = request(request_params)
        instantiate_record(json[response_key])
      end

      def find_many(request_params, response_key)
        json = request(request_params)
        json['status'] == 'ok' ? instantiate_collection(json[response_key]) : []
      end
      
      def request(request_params)
        Crack::JSON.parse(HTTParty.get(site, :query => request_params).to_json)
      end
      
      def instantiate_collection(collection)
        collection.collect! { |record| instantiate_record(record) }
      end

      def instantiate_record(record)
        new(record)
      end
      
      def identifier(id_or_slug)
        id_or_slug.to_s.numeric? ? {:id => id_or_slug} : {:slug => id_or_slug}
      end
      
    end
    
    attr_accessor :attributes, :errors
    
    def initialize(attributes={}, errors={})
      @attributes = attributes
      @errors = errors
    end
    
    def id
      attributes['id']
    end
    
    def method_missing(method_symbol, *arguments) #:nodoc:
      method_name = method_symbol.to_s

      if method_name =~ /(=|\?)$/
        case $1
        when "="
          attributes[$`] = arguments.first
        when "?"
          attributes[$`]
        end
      else
        return attributes[method_name] if attributes.include?(method_name)
        super
      end
    end
    
  end
  
end