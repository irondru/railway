require_relative '../modules/instance_counter'

class Station
  
  include InstanceCounter
  
  attr_reader :name, :trains 
 
  @@stations = {}
  
  class << self
    
    def find(name)
      @@stations[name]
    end
    
    def all
      rezult = []
      @@stations.each { |key, val| rezult << val }
      rezult
    end
    
    def count
      @@stations.count
    end
    
    def list
      names = []
      @@stations.each { |key, val| names << key}
      names
    end
             
  end
  
  def initialize(name)
    @trains = []
    @name = name.capitalize
    validate!
    @@stations[name] = self
    register_instance
  end
  
  def trains_each(&block)
    @trains.each(&block)
  end
  
  def trains_list
    numbers = []
    @trains.each { |tr| numbers << tr.number }
    numbers
  end
  
  def add_train(train)
    @trains << train
  end
  
  def del_train(train)
    @trains.delete(train)
  end
  
  def show_trains_by_type(type)
    #@trains.select{|tr| tr.type == type}
  end         
  
  private 
  
  def validate!
    raise 'Имя не может быть пустым!' if @name.nil?
    raise 'Неверное название станции!' if @name !~ /^([a-z]|[0-9]|-){3,32}$/i   
    raise "Станция с именем #{@name} уже существует!" unless Station.find(@name).nil?
    true
  end
  
end