module ApplicationHelper

  # Random string to be use in email signup url
  def random_string(len)
    chars = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
    (0..len).collect { chars[Kernel.rand(chars.length)] }.join
  end

end
