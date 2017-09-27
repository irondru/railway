module Accessors
  
   def attr_accessor_with_history(*names)
    names.each do |name|      
      sym_name = "@#{name}".to_sym
      define_method(name) { instance_variable_get(sym_name) } #getter
      define_method("#{name}=".to_sym) do |val| #setter
        @history ||= {}
        @history[name] ||= []
        @history[name] << val
        instance_variable_set(sym_name, val) 
      end       
      define_method("#{name}_history".to_sym) { @history[name] unless @history.nil? } #get history
    end   
  end
  
  def strong_attr_accessor(name, attr_class)
    sym_name = "@#{name}".to_sym
    define_method(name) { instance_variable_get(sym_name) }
    define_method("#{name}=".to_sym) do |val|
      raise 'Type mismatch' if val.class != attr_class
      instance_variable_set(sym_name, val) 
    end
  end

end