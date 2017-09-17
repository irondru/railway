class Route
  
  attr_reader :stations, :number
  
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
    @stations = [start_station, finish_station]
    @number = number
    validate!
    @@routes[number] = self
    true
  end
  
  def add_station(station)
    return false if check_station(station) 
    @stations.insert(1, station)
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
  
  private
  
  def validate!
    raise 'Нельзя создать маршрут из одной и той же станции!' if @stations[0] == @stations[1]
    raise 'Нельзя создать маршрут в пустоту!' if @stations[0].nil? || @stations[1].nil? 
    raise 'Неверный формат!' if number !~ /^([a-z]|[0-9]|-){3,32}$/i 
    raise "Маршрут именем #{@number} уже существует!"  unless Route.find(@number).nil?
    true
  end
  
end