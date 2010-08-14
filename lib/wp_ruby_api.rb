require 'httparty'
require 'active_support'
require 'wp_ruby_api/base'

# helper to detect if url contains id or a slug
class String
  def numeric?
    true if Float(self) rescue false
  end
end