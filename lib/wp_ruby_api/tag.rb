module WpRubyApi

  class Tag < Base
    
    class << self
      def all
        find_many({:json => 'get_tag_index'}, 'tags')
      end
    end
    
  end

end