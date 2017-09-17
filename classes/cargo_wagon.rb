require_relative 'wagon'

class CargoWagon < Wagon
  
  attr_reader :load, :max_load
  
  def initialize(params = {})
    @max_load = params[:max_load] || 80
    super
  end
  
  def loading(load)
    @load ||= 0
    raise 'Вагон не резиновый!' if @load + load >  @max_load
    @load += load
  end
  
  def free_space
    @max_load - @load
  end
   
  def show_info
    puts "№ #{@number}, тип: #{type}, свободно: #{free_space}, занято: #{@load}"
  end 
   
end
