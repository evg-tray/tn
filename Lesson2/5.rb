puts "Введите день месяца:"
day, month, year = 0
loop do
    day = gets.chomp.to_i
    break if (1..31) === day
    puts "День месяца должен быть числом от 1 до 31, повторите ввод"
end

puts "Введите месяц(числом):"
loop do
    month = gets.chomp.to_i
    break if (1..12) === month
    puts "Месяц должен быть числом от 1 до 12, повторите ввод"
end

puts "Введите год:"
loop do
    year = gets.chomp.to_i
    break if year > 0
    puts "Год должен быть числом больше нуля, повторите ввод"
end
  
days_in_months = [31,28,31,30,31,30,31,31,30,31,30,31]
leap_year = year % 400 == 0 || (year % 4 == 0 && year % 100 != 0)
days_in_months[1] = 29 if leap_year

days = day
if month > 1
  days_in_months[0...month-1].each{|days_in_month| days += days_in_month}
end
puts "Введенный день #{days}-й в году"