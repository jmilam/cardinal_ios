class Validator

  def self.textfields_complete?(fields)
    complete = true

    fields.each do |field|
      if field.text.empty? 
      	complete = false
      	break
      else
      	next
      end
    end
    complete
  end
end