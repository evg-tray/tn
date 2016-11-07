puts "Введите a:"
a = gets.chomp.to_f

puts "Введите b:"
b = gets.chomp.to_f

puts "Введите c"
c = gets.chomp.to_f

D = b**2 - 4 * a * c
if D < 0 
	puts "Корней нет!"
elsif D == 0
	puts "X = #{-b / (2 * a)}"
else
	puts "X1 = #{(-b + Math.sqrt(D)) / (2 * a)}"
	puts "X2 = #{(-b - Math.sqrt(D)) / (2 * a)}"
end