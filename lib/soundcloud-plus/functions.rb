require 'active_support/inflector'

class String

   def singular?
      self.pluralize != self and self.singularize == self
   end

end