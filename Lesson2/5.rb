puts "Введите день месяца:"
day, month, year = 0
loop do
    day = gets.chomp.to_i
    break if day > 0 && day < 32
    puts "День месяца должен быть числом от 1 до 31, повторите ввод" 
end

puts "Введите месяц(числом):"
loop do
    month = gets.chomp.to_i
    break if month > 0 && month < 13
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
i = 0
while i < month-1 do
    days += days_in_months[i]
    i += 1
end
puts "Введенный день #{days}-й в году"