require_relative '../modules/manufacturer'
require_relative '../modules/instance_counter'

class Wagon
  
  attr_reader :number
  
  include Manufacturer
  include InstanceCounter
  
  def initialize(params = {})
    @number = params[:number] || 0
    register_instance
  end
  
  def type
    self.class.to_s
  end
  
end
