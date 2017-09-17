require_relative '../classes/train'
require_relative '../classes/cargo_train'
require_relative '../classes/passenger_train'
require_relative 'stations_menu'
require_relative 'route_menu'
require_relative 'main_menu'

module TrainMenu
  
  def self.call  
    menu_text = "1 - Создать поезд\n" +
                "2 - Добавить вагон\n" +
                "3 - Удалить вагон\n" +
                "4 - Поместить поезд на станцию\n" +
                "5 - Добавить маршрут\n" +
                "6 - Cледующая станция по маршруту\n" +
                "7 - Предидущая станция по маршруту\n" +
                "8 - Показать инфо о вагонах поезда\n" +
                "Enter - << Назад"  
    procs = [ proc { menu_create_train }, 
              proc { menu_add_wagon_to_train }, 
              proc { menu_del_wagon_at_train }, 
              proc { menu_add_train_to_station }, 
              proc { menu_add_train_route }, 
              proc { menu_goto_next_station },
              proc { menu_goto_prev_station }, 
              proc { menu_show_wagons_info },
              proc { return } ]    
    MainMenu.call_menu_procs("Выберите действие (поезда): ", menu_text, *procs)
  end
  
  private 
  
  class << self
    # menu funcs
    def menu_create_train(train_number = '')
      if train_number == '' #нужно для автозаполнения demo data creator'ом
        loop do
          print "Введите номер поезда (или help для справки): "
          train_number = gets.chomp.to_s
          if train_number.downcase == 'help'
            puts '1-й символ номера задает тип поезда (p - пассажирский, c - грузовой)'
            puts 'даллеe через дефис или без допускается 2 цифры или буквы латинского алфавита'
            redo
          end
          break
        end  
      end
      tprocs = { 'p' => proc { puts "Создан пассажирский поезд с номером #{train_number}" if PassengerTrain.new(train_number) } ,
                 'c' => proc { puts "Создан грузовой поезд с номером #{train_number}" if CargoTrain.new(train_number) } }
      raise 'Неверный формат номера!' if tprocs[train_number[0].downcase].nil? 
      tprocs[train_number[0].downcase].call
    end

    def menu_add_wagon_to_train
      train = get_train_by_user
      raise "Нельзя цеплять вагоны во время движения поезда!" unless train.stopped?
      if train.class == PassengerTrain
        print "Укажите максимальное количество пассажиров: "
        max_passengers = gets.to_i.abs
        raise "0 не катит, попробуйте еще раз" if max_passengers == 0
        is_added = train.add_wagon(PassengerWagon.new(max_passengers: max_passengers, number: train.wagons.count))
      else 
        print "Укажите макимальную грузоподъемность: "
        raise  "0 не катит, попробуйте еще раз" if max_load == 0
        is_added = train.add_wagon(CargoWagon.new(max_load: max_load, number: train.wagons.count))
      end
      if is_added
        puts "Прицеплен вагон к поезду с номером #{train.number}, вагонов: #{train.wagons.count}"
      else 
        puts "Вагон не может быть прицеплен!"  
      end
    end

    def menu_del_wagon_at_train
      train = get_train_by_user
      raise "Нельзя отцеплять вагоны во время движения поезда!" unless train.stopped?
      if train.del_wagon
        puts "Отцеплен вагон от поезда с номером #{train.number}, вагонов: #{train.wagons.count}"
      else
        puts "У поезда с номером #{train_number} нет вагонов!"
      end         
    end

    def menu_add_train_to_station 
      station = get_station_by_user
      train = get_train_by_user
      puts "На станцию #{station.name} прибыл поезд с номером #{train.number}" if station.add_train(train)       
    end
    
    def menu_add_train_route
      train = get_train_by_user
      train.add_route(get_route_by_user)
      puts 'Маршрут добавлен!'
    end
    
    def menu_goto_next_station
      train = get_train_by_user
      raise 'У поезда нет маршрута!' if train.route.nil?
      raise 'Поезд на конечной станции!' unless train.next_station
      puts "Поезд отправился на станцию #{train.get_current_station.name}"
    end
    
    def menu_goto_prev_station
      train = get_train_by_user
      raise 'У поезда нет маршрута!' if train.route.nil?
      raise 'Поезд на начальной станции!' unless train.prev_station
      puts "Поезд отправился на станцию #{train.get_current_station.name}"      
    end
    
    def menu_show_wagons_info
      get_train_by_user.wagons_each { |wagon| wagon.show_info }
    end
    
    #end of menu funcs
    def get_train_by_user(text = 'Введите номер поезда: ')
      print text
      train_number = MainMenu.check_input(gets.chomp.to_s)
      train = Train.find(train_number)
      raise "Поезд с номером #{train_number} не найден!" if train.nil?
      train
    end  
    
    def get_station_by_user
      StationsMenu.send(:get_station_by_user)
    end  
    
    def get_route_by_user
      RouteMenu.send(:get_route_by_user)
    end
    
  end
  
end
