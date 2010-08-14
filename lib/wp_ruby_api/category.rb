module WpRubyApi

  class Category < Base
    
    class << self
      def all
        find_many({:json => 'get_category_index'}, 'categories')
      end
    end
    
  end

end