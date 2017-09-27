require_relative '../classes/station'

module StationsMenu
  
  def self.call  
    menu_text = "1 - Создать станцию\n" +
                "2 - Показать список станций\n" +
                "3 - Показать поезда на станции\n" +
                "4 - Показать онфо о всех поездах на всех станциях\n" +
                "Enter - << Назад"
    procs = [ proc { menu_create_station }, #в таком варианте меню я обнаружил один плюс 
              proc { menu_show_stations }, # - проще править/добавлять, и ненадо переписывать кучу when'ов
              proc { menu_show_trains_on_station }, 
              proc { menu_show_all_trains_on_stations },
              proc { return } ]    
    MainMenu.call_menu_procs('Выберите действие (станции): ', menu_text, *procs)
  end
  
  private 
  
  class << self
    # menu funcs
    def menu_create_station
      print "Введите название станции: "
      station_name = gets.chomp.to_s
      Station.new(station_name) 
      puts "Создана станция с именем #{station_name}"
    end
    
    def menu_show_stations 
      raise "Не создано ни одной станции!" if Station.list.empty? 
      puts "Список станций:"
      puts Station.list 
    end

    def menu_show_trains_on_station
      station = get_station_by_user
      raise "На станции нет поездов!" if station.trains_list.empty?
      puts "На станции находятся поезда с номерами:"
      puts station.trains_list 
    end
    
    def menu_show_all_trains_on_stations
      Station.all.each do |station| 
        puts "#{station.name}:"
        station.trains_each { |train| train.show_info } 
      end  
    end 
    # end of menu    
    def get_station_by_user(text = 'Введите название станции: ')
      print text
      station_name = MainMenu.check_input(gets.chomp.to_s)
      station = Station.find(station_name)
      raise "Станции с именем #{station_name} не существует!" if station.nil?
      station
    end

  end 
  
end
