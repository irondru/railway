require_relative '../modules/validation'
require_relative '../classes/station'

class Route
  
  include Validation
  
  attr_reader :stations, :number
  
  validate :stations, PRESENCE + ARRTYPE, arrtype: Station
  validate :number, PRESENCE + TYPE, type: Fixnum
  
  @@routes = {}
  
  class << self
   
   def find(number)
     @@routes[number]
   end
  
   def all
     rezult = []
     @@routes.each { |key, val| rezult << val }
     rezult
   end  
   
  end
  
  def initialize(number, start_station, finish_station)
    raise 'Нельзя создать маршрут из одной и той же станции!' if start_station == finish_station
    raise "Маршрут именем #{@number} уже существует!"  unless Route.find(@number).nil? 
    @stations = [start_station, finish_station]
    @number = number
    validate!
    @@routes[number] = self
    true
  end
  
  def add_station(station)
    return false if check_station(station) 
    @stations.insert(1, station)
    validate!
    true 
  end
  
  def del_station(station)
    @stations.delete(station)    
  end
  
  def show
    @stations
  end
  
  def check_station(station)
    @stations.include?(station)
  end
  
end