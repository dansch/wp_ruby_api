module WpRubyApi

  class Comment < Base
    
    # To use the method create ( which is submit_comment in the JSON API) you must enable the Respond controller from WP Admin > Settings > JSON API.
    def self.create(attributes={})
      params = {}
      params[:post_id] = attributes['post_id'] unless attributes['post_id'].blank?
      params[:content] = attributes['content'] unless attributes['content'].blank?
      params[:email] = attributes['email'] unless attributes['email'].blank?
      params[:name] = attributes['name'] unless attributes['name'].blank?
      create_object(params)
    end
    
    private
    
    def self.create_object(params)
      query = {:json => 'respond/submit_comment'}
      query.merge!(params)
      if permalinks == :enabled        
        request_method = query.delete(:json)
        response = HTTParty.get("#{site}/api/#{request_method}", :query => query) 
        # strange response from the JSON api. JSON differs if post_id is set or not...current workaround
        json = case
        when query.blank? then Crack::JSON.parse(response.to_s)
        when (query.keys.size == 1 and query.keys.include?(:post_id)) then Crack::JSON.parse(response)
        else 
          Crack::JSON.parse(response.to_json)
        end
      else
        json = Crack::JSON.parse(HTTParty.get(site, :query => query).to_json)
      end
      
      if json['status'] == 'ok' or json['status'] == 'pending'
        instantiate_record(json)
      elsif json['status'] == 'error'
        self.new(params, json['error'])
      end
    end
    
  end

end