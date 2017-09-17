require_relative 'wagon'
require_relative '../modules/manufacturer'
require_relative '../modules/instance_counter'
require_relative 'route'
require_relative 'station'

class Train
  
  include Manufacturer
  include InstanceCounter
  
  attr_accessor :speed
  attr_reader :wagons, :number, :manufacturer, :route
  
  MAX_WAGONS = 50
  
  @@trains = {}
  
  class << self
  
    def find(number)
      @@trains[number]
    end 
    
    def all
      rezult = []
      @@trains.each { |key, val| rezult << val  }
      rezult
    end
    
  end        

  def initialize(number, manufacturer = 'unknown', wagons)
    @number = number
    @speed = 0
    @wagons ||= []
    @manufacturer = manufacturer
    validate!
    @@trains[number] = self
    register_instance
    true
  end
  
  def get_current_station
    rezult = nil
    Station.all.each { |station| station.trains.each { |train| rezult = station if train == self } }
    rezult
  end
  
  def type
    self.class.to_s
  end
  
  def wagons_each(&block)
    @wagons.each(&block)
  end
  
  def stopped!
    @speed = 0
  end
  
  def stopped?
    @speed.zero?
  end

  def add_wagon(wagon)
    if @wagons.count < MAX_WAGONS    
      @wagons << wagon
      return true
    else
      return false  
    end  
  end
    
  def del_wagon(wagon = nil)
    if @wagons.count > 0 
      if wagon.nil? 
        @wagons.delete_at(-1)
      else 
        @wagons.delete(wagon)
      end
      return true
    else 
      return false
    end           
  end
 
  def show_info
    puts "#{@number} - #{type}, wagons: #{@wagons.count}"
  end
  
  def add_route(route)
    @route = route
    @route.stations[0].add_train(self)
    @current_station = 0
  end
  
  def next_station
    return false if @route.stations.count == @current_station + 1
    @route.stations[@current_station].del_train(self)
    @current_station += 1
    @route.stations[@current_station].add_train(self)
    @route.stations[@current_station].name
    true
  end
  
  def prev_station
    return false if @current_station == 0
    @route.stations[@current_station].del_train(self)
    @current_station -= 1
    @route.stations[@current_station].add_train(self)
    @route.stations[@current_station].name
    true
  end
  
  def show_prev_station
    return if @current_station == 0
    @route.stations[@current_station - 1].name
  end
  
  def show_next_station
    return if @route.stations.count == @current_station + 1
    @route.stations[@current_station + 1].name
  end
  
  private
  
  def validate!
    raise 'Номер не может быть пустым!' if @number.nil?
    raise 'Неверный формат номера!' if @number !~ /^(p|c){1}-?([a-z]|\d){2}$/i
    raise "Поезд с номером #{@number} уже существует!" unless Train.find(@number).nil?
    true
  end
end

