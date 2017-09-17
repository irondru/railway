require_relative 'wagon'

class PassengerWagon < Wagon
  
  attr_reader :passengers, :max_passengers
  
  def initialize(params = {})
    @passengers = 0
    @max_passengers = params[:max_passengers] || 160
    super
  end 
  
  def add_passenger
    raise 'Достигнуто максимальное чилсло пассажиров!' if @total_passengers == max_passengers
    @passengers += 1
  end
  
  def free_places
    @max_passengers - @passengers
  end
  
  def show_info
    puts "№ #{@number}, тип: #{type}, свободно: #{free_places}, занято: #{@passengers}"
  end 
  
end