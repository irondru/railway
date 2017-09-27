require_relative '../modules/instance_counter'
require_relative '../modules/validation'

class Station
  
  include InstanceCounter
  include Validation
  
  attr_reader :name, :trains
  validate :name, PRESENCE 
  #validate :name, PRESENCE + FORMAT, format: /^([a-z]|[0-9]|-){3,32}$/i 
 
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
    name.capitalize!
    raise "Станция с именем #{name} уже существует!" unless Station.find(name).nil?
    @name = name
    @trains = []
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
  
end