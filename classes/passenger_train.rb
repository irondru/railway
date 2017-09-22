require_relative 'train'

class PassengerTrain < Train  
  
  def add_wagon(wagon)
    if wagon.class == PassengerWagon
      super
    else
      return false
    end
  end
  
  def initialize(number, manufacturer = 'unknown', speed = 0)
    super   
  end
  
end  
