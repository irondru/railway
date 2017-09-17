require_relative 'train'
require_relative 'cargo_wagon'

class CargoTrain < Train
  
  def add_wagon(wagon)
    if wagon.class == CargoWagon
      super
    else
      return false
    end
  end 
  
  def initialize(number, manufacturer = 'unknown', wagons = 0)
    super
  end
  
end