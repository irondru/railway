require_relative '../classes/station'
require_relative '../classes/train'
require_relative '../classes/route'
require_relative '../classes/cargo_train'
require_relative '../classes/passenger_train'
require_relative '../classes/cargo_wagon'
require_relative '../classes/passenger_wagon'
require_relative '../menus/train_menu'


module DemoData
  
  def self.call
    puts "Demo data creator start"
    stations_names = ['Nerezinovsk', 'Muhosransk', 'Pripyat', 'Leninburg', 'Blackmesa', 'Las-Venturas', 'City17', 'San-Firerro']
    trains_numbers = ['P42', 'C17', 'C07', 'P23', 'P77', 'P-22', 'C-59', 'C-13', 'P-91']
    routes_numbers = [100, 101, 102, 103]
    # создаем станции
    puts "Create stations..."
    stations_names.each { |name| Station.new(name) }
    # создаем поезда. что бы не вызывать для каждого типа поезда свой класс, 
    # сделаем это через меню - оно распихает куда нужно, но будет выведена лишняя инфа
    puts "Create trains and wagons..."
    trains_numbers.each { |number| TrainMenu.send(:menu_create_train, number) }  
    Train.all.each do |train| 
      (0..rand(42)).each do # цепляем каждому поезду случайное кол-во вагонов
        if train.class == PassengerTrain
          wagon = PassengerWagon.new(max_passengers: 160, number: train.wagons.count)
          (0..rand(160)).each { wagon.add_passenger } # создаем вагон и добовляем пассажиров         
        else 
          wagon = CargoWagon.new(max_load: 80, number: train.wagons.count)
          wagon.loading(rand(80)) #или груз
        end
        train.add_wagon(wagon) 
      end
    end
    # генерируем маршруты
    puts "Generate routes..."
    routes_numbers.each do |number|
      begin   
        Route.new(number, Station.all[ rand(Station.count) ], Station.all[ rand(Station.count) ] ) 
      rescue RuntimeError # пробуем еще раз при попытке добавления одной и той же станции в маршрут
        retry  
      end
    end  
    puts "Add trains to stations..."
    # распихиваем все поезда по начальным станциям случайных маршрутов
    Train.all.each { |train|  train.add_route( Route.all[ rand(Route.all.count) ] ) }
    puts "Demo data creator done"
    rescue RuntimeError => e
      puts "Demo data create error: #{e.message}"
  end  
  
end
