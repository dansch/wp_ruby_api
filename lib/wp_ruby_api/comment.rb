module WpRubyApi

  class Comment < Base
    
    # To use the method create ( which is submit_comment in the JSON API) you must enable the Respond controller from WP Admin > Settings > JSON API.
    def self.create(attributes={})
      params = {:post_id => attributes['post_id'], :content => attributes['content'], :email => attributes['email'], :name => attributes['name']}
      create_object(params)
    end
    
    private
    
    def self.create_object(params)
      query = {:json => 'respond/submit_comment'}
      query.merge!(params)
      json = Crack::JSON.parse(HTTParty.get(site, :query => query).to_json)
      if json['status'] == 'ok'
        instantiate_record(json)
      elsif json['status'] == 'error'
        self.new(params, json['error'])
      end
    end
    
  end

end