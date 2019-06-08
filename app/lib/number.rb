module Number
  def self.is_integer?(some_string)
    true if Integer(some_string) rescue false
  end
end