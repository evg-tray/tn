puts "Введите ваше имя:"
name = gets.chomp

puts "Введите ваш рост:"
height = gets.chomp

ideal_weight = height.to_i - 110

if ideal_weight < 0 
	message = "ваш вес оптимален!"
else
	message = "ваш оптимальный вес: #{ideal_weight}кг."
end
puts "#{name.capitalize}, #{message}"