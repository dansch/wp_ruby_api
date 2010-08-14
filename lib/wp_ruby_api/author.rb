module WpRubyApi

  class Author < Base
    
    class << self
      def all
        find_many({:json => 'get_author_index'}, 'authors')
      end
    end
    
  end

end