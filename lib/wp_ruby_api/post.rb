module WpRubyApi
  
  class Post < Base
    
    # only explicit methods are called from the json api
    
    class << self
    
      def find(id_or_slug)
        find_single({:json => 'get_post'}.merge!(identifier(id_or_slug)), 'post')
      end
    
      def all(options={})
        find_posts({:json => 'get_recent_posts'}, options)
      end
    
      def by_category(id_or_slug, options={})
        find_posts({:json => 'get_category_posts'}.merge!(identifier(id_or_slug)), options)
      end
    
      def by_tag(id_or_slug, options={})
        find_posts({:json => 'get_tag_posts'}.merge!(identifier(id_or_slug)), options)
      end
      
      def by_author(id_or_slug, options={})
        find_posts({:json => 'get_author_posts'}.merge!(identifier(id_or_slug)), options)
      end
    
      def search(search_query, options={})
        find_posts({:json => 'get_search_results', :search => search_query}, options)
      end
      
      def by_date(date_string, options={})
        find_posts({:json => 'get_date_posts', :date => date_string}, options)
      end
      
      private 
      
      def find_posts(query, options)
        find_many(set_query_options(query, options.symbolize_keys!), 'posts')
      end
      
      def set_query_options(query, options)
        query.merge!({:count => options[:count]}) if options[:count]
        query.merge!({:page => options[:page]}) if options[:page]
        query.merge!({:post_type => options[:post_type]}) if options[:post_type]
        query
      end

    end
    
  end
  
end