module Validation
  # я решил немного отступить от задания 9
  # метод validate может принимать сразу несколько опций через "+"
  # а параметры валидации передаются в виде хеша
  # в проверке на тип, NilClass игнорируется, т.к. его можно проверить с опцией PRESENCE
  # также ее можно определить в классе-родителе или переопределить в классе наследнике
  # пример использования: 
  # validate :number, PRESENCE + FORMAT + TYPE, format: /^(p|c){1}-?([a-z]|\d){2}$/i, type: String 
  
  # бинарики для наглядности  
  PRESENCE = 0b00010 #проверка на nil
  FORMAT   = 0b00100 #проверка regex
  TYPE     = 0b01000 #проверка класса
  ARRTYPE  = 0b10000 #проверка елементов массива на соответствие классу
  NULL     = 0b00000
  
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end
  
  module ClassMethods
    # нужен для доступа из инстанс
    attr_reader :valid_rules
    # сохраняем правила валидации в массив хешей, для последующей проверки в validate!   
    def validate(name, options, params = {})
      raise "invalid options!" if options & PRESENCE + FORMAT + TYPE + ARRTYPE == NULL
      @valid_rules ||= []
      @valid_rules << { name: name, options: options, params: params }
    end    

  end
  
  module InstanceMethods
    # ACHTUNG!!! WTF Code!
    def validate! #мне чет понравилось запихивать код в хеши))
      procs = { PRESENCE => proc { |name| raise "Var: \"#{name}\" is nil!" if 
                  instance_variable_get("@#{name}".to_sym).nil? }, 
                FORMAT => proc { |name, params| raise "Var: \"#{name}\" format error!" if 
                  instance_variable_get("@#{name}".to_sym) !~ params[:format] }, 
                TYPE => proc { |name, params| 
                  unless instance_variable_get("@#{name}".to_sym).instance_of?(NilClass)
                    raise "Var: \"#{name}\" type error #{instance_variable_get("@#{name}".to_sym).class} !" unless 
                      instance_variable_get("@#{name}".to_sym).instance_of?(params[:type]) 
                  end },
                ARRTYPE => proc { |name, params| instance_variable_get("@#{name}".to_sym).each { 
                  |elem| raise "Var #{name} incorrent array element!" unless elem.instance_of?(params[:arrtype]) } },
                NULL => proc {} } #заглушка, что бы не было NoMethodError
      # ищем переменную valid_rules в текущем или родительских классах, что бы не копипастить валидацию ибо not true          
      self.class.ancestors.select{ |c| c.instance_of?(Class) }.each do |c| #отфильтровываем лишнее, нас интересуют только классы           
        if c.instance_variable_defined?("@valid_rules".to_sym)                   
          c.valid_rules.each { |rule|
            #было бы лучше что то типо как на с++ for(i = 2; i =< 8; i *= 2 ) но так и не допер как написать подобное на руби
            [PRESENCE, FORMAT, TYPE, ARRTYPE].each { |i|
              procs[rule[:options] & i].call(rule[:name], rule[:params]) } }
          break    
        end     
      end  
      true 
    end
    
    def valid?
      validate!
    rescue
      false  
    end  
      
  end
       
end