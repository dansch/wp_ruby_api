module WpRubyApi

  class Page < Base
    
    class << self
      def find(id_or_slug)
        find_single({:json => 'get_page'}.merge!(identifier(id_or_slug)), 'page')
      end
      
      def all
        find_many({:json => 'get_page_index'}, 'pages')
      end
    end
    
  end

end