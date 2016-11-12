require_relative "train"
require_relative "passenger_train"
require_relative "cargo_train"
require_relative "station"
require_relative "route"
require_relative "wagon"
require_relative "cargo_wagon"
require_relative "passenger_wagon"
require_relative "string"

$stations = Hash.new(0)
$trains = Hash.new(0)
$wagons = Hash.new(0)

INPUT_EXIT = "exit"

def message_exit_reserved
  puts "#{INPUT_EXIT} зарезервировано системой, введите другое значение:".red
end

def create_station
  puts "Вы создаете станцию. Введите название новой станции:".green
  loop do
    name_station = gets.chomp
    if name_station == INPUT_EXIT
      message_exit_reserved
    elsif $stations[name_station] == 0
      $stations[name_station] = Station.new(name_station)
      puts "Создана станция с названием #{name_station}".red
      break
    else
      puts "Станция с таким названием уже существует, повторите ввод:".green
    end
  end
end

def create_train
  puts "Вы создаете поезд. Введите номер поезда:".green
  message = ""
  loop do
    number = gets.chomp
    if number == INPUT_EXIT
      message_exit_reserved
    elsif $trains[number] == 0
      puts "Введите тип поезда: 1. Грузовой, 2. Пассажирский:".green
      loop do
        type = gets.chomp.to_i
        case type
        when 1
          $trains[number] = CargoTrain.new(number)
          message = "грузовой поезд с номером #{number}"
          break
        when 2
          $trains[number] = PassengerTrain.new(number)
          message = "пассажирский поезд с номером #{number}"
          break
        else
          puts "Нет такого типа, повторите ввод:".green
        end
      end
      break
    else
      puts "Поезд с таким номером уже существует, повторите ввод:".green
    end
  end
  puts "Создан #{message}".red
end

def create_wagon
  puts "Вы создаете новый вагон. Введите номер вагона:".green
  message = ""
  loop do
    number = gets.chomp
    if number == INPUT_EXIT
      message_exit_reserved
    elsif $wagons[number] == 0
      puts "Введите тип вагона: 1. Грузовой, 2. Пассажирский:".green
      loop do
        type = gets.chomp.to_i
        case type
        when 1
          $wagons[number] = CargoWagon.new(number)
          message = "грузовой вагон с номером #{number}"
          break
        when 2
          $wagons[number] = PassengerWagon.new(number)
          message = "пассажирский вагон с номером #{number}"
          break
        else
          puts "Нет такого типа, повторите ввод:".green
        end
      end
      break
    else
      puts "Вагон с таким номером уже существует, повторите ввод:".green
    end
  end
  puts "Создан #{message}".red
end

def hitch_wagon_to_train
  loop do
    puts "===".blue
    puts "Вы находитесь в меню прицепки вагона к поезду.".green
    puts "Введите номер поезда, к которому нужно прицепить вагон:".green
    puts "Для перехода в главное меню введите #{INPUT_EXIT}".red
    number = gets.chomp
    break if number == INPUT_EXIT
    train = $trains[number]
    if train == 0
      puts "Такого поезда не существует, повторите ввод:".green
    else
      print_list_wagons
      puts "Введите номер вагона, который нужно прицепить к поезду #{number}:".green
      puts "Для перехода в меню выше введите #{INPUT_EXIT}".red
      number_wagon = gets.chomp
      break if number_wagon == INPUT_EXIT
      wagon = $wagons[number_wagon]
      if wagon == 0
        puts "Такого вагона не существует, повторите ввод:".green
      else
        wagon_added = train.hitch_wagon(wagon)
        if wagon_added
          message = "Вагон #{number_wagon} добавлен к поезду #{number}."
        else
          message = "Не удалось добавить вагон к поезду."
        end
        puts message.red
        break
      end
    end
  end
end

def detach_wagon_from_train
  loop do
    puts "===".blue
    puts "Вы находитесь в меню отцепки вагона от поезда.".green
    puts "Введите номер поезда, у которого нужно отцепить вагон:".green
    puts "Для перехода в главное меню введите #{INPUT_EXIT}".red
    number = gets.chomp
    break if number == INPUT_EXIT
    train = $trains[number]
    if train == 0
      puts "Такого поезда не существует, повторите ввод:".green
    else
      puts "Список вагонов у поезда #{number}:".green
      train.wagons.each { |wagon| puts wagon.number }
      puts "Введите номер вагона, который нужно удалить:".green
      puts "Для перехода в меню выше введите #{INPUT_EXIT}".red
      loop do
        number_wagon = gets.chomp
        break if number_wagon == INPUT_EXIT
        wagon = $wagons[number_wagon]
        if wagon == 0
          puts "Такого вагона не существует, повторите ввод:".green
        else
          wagon_detached = train.detach_wagon(wagon)
          if wagon_detached
            message = "отцеплен от поезда #{number}."
          else
            message = "не возможно отцепить от поезда #{number}"
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
    puts "===".blue
    puts "Вы находитесь в меню добавления поезда на станцию.".green
    puts "Введите станцию, на которую нужно добавить поезд:".green
    puts "Для перехода в главное меню введите #{INPUT_EXIT}".red
    name_station = gets.chomp
    break if name_station == INPUT_EXIT
    station = $stations[name_station]
    if station == 0
      puts "Такой станции не существует, повторите ввод:".green
    else
      print_list_trains
      puts "Введите номер поезда для добавления на станцию #{name_station}:".green
      puts "Для перехода в меню выше введите #{INPUT_EXIT}".red
      loop do
        number = gets.chomp
        break if number == INPUT_EXIT
        train = $trains[number]
        if train == 0
          puts "Такого поезда не существует, повторите ввод:".green
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
    puts "===".blue
    puts "Вы находитесь в меню вывода списков. Какой список вывести?".green
    puts "1. Список станций"
    puts "2. Список поездов на станции"
    puts "3. Количество поездов на станции"
    puts "4. Список поездов"
    puts "5. Список вагонов"
    puts "Любая другая команда - переход к главному меню".red
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
    else
      break
    end
  end
end

def print_list_trains
  puts "=== Список существующих поездов:".green
  $trains.each { |key, value| puts key }
end

def print_list_stations
  puts "=== Список существующих станций:".green
  $stations.each { |key, value| puts key }
end

def print_list_wagons
  puts "=== Список существующих вагонов:".green
  $wagons.each { |key, value| puts key }
end

def print_count_trains_by_type
  loop do
    puts "===".blue
    puts "Вы находитесь в меню вывода списка поездов на станции.".green
    puts "Введите название станции:".green
    puts "Для перехода в главное меню введите #{INPUT_EXIT}".red
    name_station = gets.chomp
    break if name_station == INPUT_EXIT
    station = $stations[name_station]
    if station == 0
      puts "Такой станции не существует, повторите ввод:".green
    else
      station.print_count_trains_by_type
      break
    end
  end
end

def menu_trains_by_station
  loop do
    puts "===".blue
    puts "Вы находитесь в меню вывода списка поездов на станции.".green
    puts "Для какой станции вывести список поездов? Введите название станции:".green
    puts "Для перехода в меню выше введите #{INPUT_EXIT}".red
    name_station = gets.chomp
    break if name_station == INPUT_EXIT
    station = $stations[name_station]
    if station == 0
      puts "Введенной станции не существует".red
    else
      puts "Поезда на станции #{name_station}:".green
      station.print_trains
    end
  end
end

def create_info
  $stations["Moscow"] = Station.new("Moscow")
  $stations["Spb"] = Station.new("Spb")
  $stations["Omsk"] = Station.new("Omsk")
  $stations["Krd"] = Station.new("Krd")
  $stations["Tula"] = Station.new("Tula")

  $trains["444"] = CargoTrain.new("444")
  $trains["872"] = CargoTrain.new("872")
  $trains["980"] = PassengerTrain.new("980")
  $trains["578"] = PassengerTrain.new("578")

  $wagons["134"] = CargoWagon.new("134")
  $wagons["222"] = CargoWagon.new("222")
  $wagons["452"] = CargoWagon.new("452")
  $wagons["777"] = PassengerWagon.new("777")
  $wagons["890"] = PassengerWagon.new("890")
end

loop do
  puts "=====".blue
  puts "Введите номер желаемого действия:".green
  puts "1. Создать станцию"
  puts "2. Создать поезд"
  puts "3. Создать вагон"
  puts "4. Добавить вагон к поезду"
  puts "5. Отцепить вагон от поезда"
  puts "6. Поместить поезд на станцию"
  puts "7. Просмотр списков станций, поездов, вагонов"
  puts "8. Создать несколько предопределенных станций, поездов, вагонов"
  puts "Любая другая ввод - выход из программы".red
  puts "=====".blue

  command = gets.chomp.to_i
  case command
  when 1
    create_station
  when 2
    create_train
  when 3
    create_wagon
  when 4
    hitch_wagon_to_train
  when 5
    detach_wagon_from_train
  when 6
    send_train_to_staion
  when 7
    menu_lists_stations_trains
  when 8
    create_info
  else
    break
  end
end
