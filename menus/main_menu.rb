require_relative 'route_menu'
require_relative 'stations_menu'
require_relative 'train_menu'

module MainMenu
  
  class << self
  
  def call
    menu_text = "1 - Меню станций\n" +
                "2 - Меню поезов\n" +
                "3 - Меню маршрутов\n" +
                "Enter - Выход"  
    procs = [ proc { StationsMenu.call }, 
              proc { TrainMenu.call }, 
              proc { RouteMenu.call }, 
              proc { return } ] 
    call_menu_procs('Выберите действие: ', menu_text, *procs)
  end  
  
  #ф-я принимает заголовок, текст меню и массив с ф-ми меню
  def call_menu_procs(caption, menu_text, *procs)
    puts menu_text
    loop do
      begin
        print caption
        procs[gets.to_i.abs - 1].call   
      rescue RuntimeError => e
        puts e.message
      rescue NoMethodError #наверно так делать нельзя :)
        puts menu_text
        puts 'Введен неверный пункт меню. Пожалуйста, повторите попытку.'
      end  
    end
  end
  
  def check_input(input)
    raise 'Вы ввели парашу, попробуйте еще раз!' if input !~ /^([a-z]|[0-9]|-){3,32}$/i 
    input
  end
  
  end
  
end  






