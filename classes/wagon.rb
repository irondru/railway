require_relative '../modules/manufacturer'
require_relative '../modules/instance_counter'
require_relative '../modules/validation.rb'

class Wagon
  
  include Validation
  
  attr_reader :number
  
  validate :number, PRESENCE + TYPE, type: Fixnum
  
  include Manufacturer
  include InstanceCounter
  
  def initialize(params = {})
    @number = params[:number] || 0
    validate!
    register_instance
  end
  
  def type
    self.class.to_s
  end
  
end
