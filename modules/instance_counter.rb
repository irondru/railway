module InstanceCounter
  
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end
  
  module ClassMethods
    
    attr_reader :instances
    
    def show_counter
      puts "instances: #{@instances}"
    end
    
    private
    
    def register_instance
      @instances ||= 0
      @instances += 1
      #show_counter
    end
    
  end 
  
  module InstanceMethods
    
    protected
    
    def register_instance
      self.class.send :register_instance
    end
    
  end
  
end