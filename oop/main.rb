require_relative 'modules/manufacturer'
require_relative 'models/train'
require_relative 'models/train/passenger_train'
require_relative 'models/train/cargo_train'
require_relative 'models/station'
require_relative 'models/route'
require_relative 'models/wagon'
require_relative 'models/wagon/cargo_wagon'
require_relative 'models/wagon/passenger_wagon'
require_relative 'core_ext/string/colorize'

@stations = Hash.new(0)
@trains = Hash.new(0)
@wagons = Hash.new(0)

INPUT_EXIT = 'exit'.freeze
MAX_ATTEMPTS = 5

def message_exit_reserved
  puts "#{INPUT_EXIT} зарезервировано системой, введите другое значение:".red
end

def create_station
  puts 'Вы создаете станцию. Введите название новой станции:'.green
  loop do
    name_station = gets.chomp
    next message_exit_reserved if name_station == INPUT_EXIT
    if @stations[name_station] == 0
      @stations[name_station] = Station.new(name_station)
      puts "Создана станция с названием #{name_station}".red
      break
    else
      puts 'Станция с таким названием уже существует, повторите ввод:'.green
    end
  end
end

def create_train
  type_train = input_type_train
  puts 'Введите номер поезда:'.green
  attempt = 0
  begin
    attempt += 1
    number = gets.chomp
    raise message_exit_reserved if number == INPUT_EXIT
    @trains[number] = type_train.new(number)
    puts "Создан #{@trains[number].class.type} поезд с номером #{number}".red
  rescue => e
    print e.message.red
    puts " Повторите ввод(попытка #{attempt} из #{MAX_ATTEMPTS}):".green
    retry if attempt < MAX_ATTEMPTS
  end
end

def input_type_train
  puts 'Вы создаете поезд. Введите тип поезда:'.green
  puts '1. Грузовой'
  puts '2. Пассажирский'
  loop do
    type = gets.chomp.to_i
    case type
    when 1
      return CargoTrain
    when 2
      return PassengerTrain
    else
      puts 'Нет такого типа, повторите ввод:'.green
    end
  end
end

def create_wagon
  puts 'Вы создаете новый вагон. Введите номер вагона:'.green
  message = ''
  loop do
    number = gets.chomp
    next message_exit_reserved if number == INPUT_EXIT
    if @wagons[number] == 0
      message = select_type_wagon(number)
      break
    else
      puts 'Вагон с таким номером уже существует, повторите ввод:'.green
    end
  end
  puts "Создан #{message}".red
end

def select_type_wagon(number)
  puts 'Введите тип вагона: 1. Грузовой, 2. Пассажирский:'.green
  loop do
    type = gets.chomp.to_i
    case type
    when 1
      volume = volume_cargo_wagon
      @wagons[number] = CargoWagon.new(number, volume)
      return "грузовой вагон с номером #{number} и объемом #{volume}"
    when 2
      count_seats = count_seats_passenger_wagon
      @wagons[number] = PassengerWagon.new(number, count_seats)
      return "пассажирский вагон с номером #{number} " \
             "и количеством мест #{count_seats}"
    else
      puts 'Нет такого типа, повторите ввод:'.green
    end
  end
end

def volume_cargo_wagon
  puts 'Введите объем вагона:'.green
  loop do
    volume = gets.chomp.to_f
    next puts 'Объем должен быть числом больше 0.'.red if volume <= 0
    return volume
  end
end

def count_seats_passenger_wagon
  puts 'Введите количество мест в вагоне:'.green
  loop do
    count_seats = gets.chomp.to_i
    message = 'Количество мест должно быть целым положительным числом.'.red
    next puts message if count_seats <= 0
    return count_seats
  end
end

def attach_wagon_to_train
  loop do
    puts '==='.blue
    puts 'Вы находитесь в меню прицепки вагона к поезду.'.green
    puts 'Введите номер поезда, к которому нужно прицепить вагон:'.green
    puts "Для перехода в главное меню введите #{INPUT_EXIT}".red
    number = gets.chomp
    break if number == INPUT_EXIT
    train = @trains[number]
    if train == 0
      puts 'Такого поезда не существует, повторите ввод:'.green
    else
      print_list_wagons
      input_number_wagon_to_attach(train)
    end
  end
end

def input_number_wagon_to_attach(train)
  puts 'Введите номер вагона, который нужно прицепить к поезду:'.green
  puts "Для перехода в меню выше введите #{INPUT_EXIT}".red
  number_wagon = gets.chomp
  return if number_wagon == INPUT_EXIT
  wagon = @wagons[number_wagon]
  if wagon == 0
    puts 'Такого вагона не существует, повторите ввод:'.green
  else
    wagon_added = train.attach_wagon(wagon)
    message = if wagon_added
                "Вагон #{number_wagon} добавлен к поезду #{number}."
              else
                'Не удалось добавить вагон к поезду.'
              end
    puts message.red
  end
end

def detach_wagon_from_train
  loop do
    puts '==='.blue
    puts 'Вы находитесь в меню отцепки вагона от поезда.'.green
    puts 'Введите номер поезда, у которого нужно отцепить вагон:'.green
    puts "Для перехода в главное меню введите #{INPUT_EXIT}".red
    number = gets.chomp
    break if number == INPUT_EXIT
    train = @trains[number]
    if train == 0
      puts 'Такого поезда не существует, повторите ввод:'.green
    else
      puts "Список вагонов у поезда #{number}:".green
      train.wagons.each { |wagon| puts wagon.number }
      puts 'Введите номер вагона, который нужно удалить:'.green
      puts "Для перехода в меню выше введите #{INPUT_EXIT}".red
      loop do
        number_wagon = gets.chomp
        break if number_wagon == INPUT_EXIT
        wagon = @wagons[number_wagon]
        if wagon == 0
          puts 'Такого вагона не существует, повторите ввод:'.green
        else
          wagon_detached = train.detach_wagon(wagon)
          message = if wagon_detached
                      "отцеплен от поезда #{number}."
                    else
                      "не возможно отцепить от поезда #{number}"
                    end
          puts "Вагон #{number_wagon} #{message}".red
          break
        end
      end
    end
  end
end

def send_train_to_staion
  loop do
    puts '==='.blue
    puts 'Вы находитесь в меню добавления поезда на станцию.'.green
    puts 'Введите станцию, на которую нужно добавить поезд:'.green
    puts "Для перехода в главное меню введите #{INPUT_EXIT}".red
    name_station = gets.chomp
    break if name_station == INPUT_EXIT
    station = @stations[name_station]
    if station == 0
      puts 'Такой станции не существует, повторите ввод:'.green
    else
      print_list_trains
      puts "Введите номер поезда для добавления на станцию #{name_station}:".green
      puts "Для перехода в меню выше введите #{INPUT_EXIT}".red
      loop do
        number = gets.chomp
        break if number == INPUT_EXIT
        train = @trains[number]
        if train == 0
          puts 'Такого поезда не существует, повторите ввод:'.green
        else
          station.take_train(train)
          puts "На станцию #{name_station} добавлен поезд с номером #{number}"
          break
        end
      end
      break
    end
  end
end

def menu_lists_stations_trains
  loop do
    puts '==='.blue
    puts 'Вы находитесь в меню вывода списков. Какой список вывести?'.green
    puts '1. Список станций'
    puts '2. Список поездов на станции'
    puts '3. Количество поездов на станции'
    puts '4. Список поездов'
    puts '5. Список вагонов'
    puts '6. Список вагонов у поезда'
    puts '7. Список поездов на станции в формате'
    puts 'Любая другая команда - переход к главному меню'.red
    command = gets.chomp.to_i
    case command
    when 1
      print_list_stations
    when 2
      menu_trains_by_station
    when 3
      print_count_trains_by_type
    when 4
      print_list_trains
    when 5
      print_list_wagons
    when 6
      print_list_wagons_by_train
    when 7
      print_list_trains_format
    else
      break
    end
  end
end

def print_list_trains
  puts '=== Список существующих поездов:'.green
  @trains.each_key { |key| puts key }
end

def print_list_stations
  puts '=== Список существующих станций:'.green
  @stations.each_key { |key| puts key }
end

def print_list_wagons
  puts '=== Список существующих вагонов:'.green
  @wagons.each_key { |key| puts key }
end

def print_count_trains_by_type
  loop do
    puts '==='.blue
    puts 'Вы находитесь в меню вывода списка поездов на станции.'.green
    puts 'Введите название станции:'.green
    puts "Для перехода в главное меню введите #{INPUT_EXIT}".red
    name_station = gets.chomp
    break if name_station == INPUT_EXIT
    station = @stations[name_station]
    if station == 0
      puts 'Такой станции не существует, повторите ввод:'.green
    else
      station.print_count_trains_by_type
      break
    end
  end
end

def menu_trains_by_station
  loop do
    puts '==='.blue
    puts 'Вы находитесь в меню вывода списка поездов на станции.'.green
    puts 'Для какой станции вывести список поездов? Введите название станции:'.green
    puts "Для перехода в меню выше введите #{INPUT_EXIT}".red
    name_station = gets.chomp
    break if name_station == INPUT_EXIT
    station = @stations[name_station]
    if station == 0
      puts 'Введенной станции не существует'.red
    else
      puts "Поезда на станции #{name_station}:".green
      station.print_trains
    end
  end
end

def print_list_wagons_by_train
  loop do
    puts '==='.blue
    puts 'Вы находитесь в меню вывода списка вагонов поезда.'.green
    puts 'Для какой какого поезда вывести список вагонов?'.green
    puts 'Введите номер поезда:'.green
    puts "Для перехода в меню выше введите #{INPUT_EXIT}".red
    number = gets.chomp
    break if number == INPUT_EXIT
    train = @trains[number]
    if train == 0
      puts "Поезда с номером #{number} не существует".red
    else
      puts "Вагоны у поезда номер #{number}:".green
      train.each_wagon { |wagon| puts wagon }
    end
  end
end

def print_list_trains_format
  loop do
    puts '==='.blue
    puts 'Вы находитесь в меню вывода списка поездов на станции.'.green
    puts 'Для какой станции вывести список поездов? Введите название станции:'.green
    puts "Для перехода в меню выше введите #{INPUT_EXIT}".red
    name_station = gets.chomp
    break if name_station == INPUT_EXIT
    station = @stations[name_station]
    if station == 0
      puts 'Введенной станции не существует'.red
    else
      puts "Поезда на станции #{name_station} в формате:".green
      station.each_train { |train| puts train }
    end
  end
end

def take_seat_cargo
  loop do
    puts 'Введите номер вагона:'.green
    puts "Для перехода в главное меню введите #{INPUT_EXIT}".red
    number = gets.chomp
    break if number == INPUT_EXIT
    wagon = @wagons[number]
    if wagon == 0
      puts 'Введенного вагона не существует'.red
    else
      if wagon.is_a? CargoWagon
        take_cargo(wagon)
      else
        take_passengers(wagon)
      end
    end
  end
end

def take_cargo(wagon)
  puts 'Введите объем груза:'
  attempt = 0
  begin
    attempt += 1
    volume = gets.chomp.to_f
    wagon.take_cargo(volume)
  rescue => e
    print e.message.red
    puts " Повторите ввод(попытка #{attempt} из #{MAX_ATTEMPTS}):".green
    retry if attempt < MAX_ATTEMPTS
  end
end

def take_passengers(wagon)
  puts 'Введите количество пассажиров:'
  count = gets.chomp.to_i
  count.times { wagon.take_passenger }
end

def create_info
  @stations['Moscow'] = Station.new('Moscow')
  @stations['Spb'] = Station.new('Spb')
  @stations['Omsk'] = Station.new('Omsk')
  @stations['Krd'] = Station.new('Krd')
  @stations['Tula'] = Station.new('Tula')

  @trains['44444'] = CargoTrain.new('44444')
  @trains['87222'] = CargoTrain.new('87222')
  @trains['980-вв'] = PassengerTrain.new('980-вв')
  @trains['АА578'] = PassengerTrain.new('АА578')

  @wagons['134'] = CargoWagon.new('134', 50)
  @wagons['222'] = CargoWagon.new('222', 45.5)
  @wagons['452'] = CargoWagon.new('452', 98.3)
  @wagons['777'] = PassengerWagon.new('777', 15)
  @wagons['890'] = PassengerWagon.new('890', 25)

  @stations['Moscow'].take_train(@trains['44444'])
  @stations['Moscow'].take_train(@trains['87222'])
  @stations['Moscow'].take_train(@trains['980-вв'])
  @stations['Moscow'].take_train(@trains['АА578'])

  @trains['44444'].attach_wagon(@wagons['134'])
  @trains['44444'].attach_wagon(@wagons['222'])
  @trains['44444'].attach_wagon(@wagons['452'])

  @trains['АА578'].attach_wagon(@wagons['777'])
  @trains['АА578'].attach_wagon(@wagons['890'])

  @wagons['134'].take_cargo(33)
  5.times { @wagons['777'].take_passenger }
end

loop do
  puts '====='.blue
  puts 'Введите номер желаемого действия:'.green
  puts '1. Создать станцию'
  puts '2. Создать поезд'
  puts '3. Создать вагон'
  puts '4. Добавить вагон к поезду'
  puts '5. Отцепить вагон от поезда'
  puts '6. Поместить поезд на станцию'
  puts '7. Просмотр списков станций, поездов, вагонов'
  puts '8. Создать несколько предопределенных станций, поездов, вагонов'
  puts '9. Занять место/загрузить груз в вагон'
  puts 'Любая другая ввод - выход из программы'.red
  puts '====='.blue

  command = gets.chomp.to_i
  case command
  when 1
    create_station
  when 2
    create_train
  when 3
    create_wagon
  when 4
    attach_wagon_to_train
  when 5
    detach_wagon_from_train
  when 6
    send_train_to_staion
  when 7
    menu_lists_stations_trains
  when 8
    create_info
  when 9
    take_seat_cargo
  else
    break
  end
end
