require 'active_support/inflector'

class String

   # Uses active_support/infectors to determine if a string is singular or plural
   # 
   # @example Determining if word is singular
   #   "poop".singular?  # => true
   #   "farts".singular? # => false
   #
   def singular?
      self.pluralize != self and self.singularize == self
   end

end