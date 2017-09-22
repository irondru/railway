require_relative '../classes/route'
require_relative '../classes/station'
require_relative 'main_menu'

module RouteMenu
  
  def self.call  
    menu_text = "1 - Создать маршрут\n" +
                "2 - Добавить станцию\n" +
                "3 - Удалить станцию\n" +
                "4 - Показать список станций в маршруте\n" +
                "5 - Показать список маршрутов\n" +
                "Enter - << Назад"
    procs = [ proc {menu_add_route}, 
              proc {menu_add_station_to_route}, 
              proc {menu_del_station_as_route},
              proc {menu_route_stations_list}, 
              proc {menu_routes_list},
              proc { return } ]  
    MainMenu.call_menu_procs('Выберите действие (маршруты): ', menu_text, *procs)
  end 
            
  private 
    
  class << self
    # menu funcs
    def menu_add_route
      print 'Введите номер маршрута: '  
      Route.new(MainMenu.check_input(gets.chomp.to_s), get_station_by_user('Введите название начальной станции: '), 
                                              get_station_by_user('Введите названеи конечной станции: ') )
    end
    
    def menu_add_station_to_route
      raise 'Станция уже есть в маршруте!' unless get_route_by_user.add_station(get_station_by_user)
    end  
    
    def menu_del_station_as_route
      get_route_by_user.del_station(get_station_by_user)
    end
    
    def menu_route_stations_list
      print 'Введите номер маршрута: '
      Route.find(MainMenu.check_input(gets.to_i)).stations.each { |station| puts station.name } 
    end   
    
    def menu_routes_list
      Route.all.each { |route| puts route.number }
    end
    # end of menu 
    def get_station_by_user(text = 'Введите название станции: ')
      print text
      station = Station.find(gets.chomp.to_s)
      raise 'Станция не найдена!' if station.nil?
      station
    end 
  
    def get_route_by_user
      print 'Введите номер маршрута: '
      route_number = MainMenu.check_input(gets.to_i)
      route = Route.find(route_number)
      raise 'Маршрут не найден!' if route.nil?
      route
    end  

    
  end 
  
end
  