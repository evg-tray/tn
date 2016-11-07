puts "Введите длину первой стороны:"
first_line = gets.chomp.to_f

puts "Введите длину второй стороны:"
second_line = gets.chomp.to_f

puts "Введите длину третьей стороны"
third_line = gets.chomp.to_f

do_pifagor = true
if first_line == second_line && first_line == third_line
	puts "Все стороны равны, треугольник равнобедренный и равносторонний, но не прямоугольный"
	do_pifagor = false
end

if do_pifagor
	if first_line == second_line || first_line == third_line || second_line == third_line
		isoscales_triangle = true
	end

	if first_line > second_line
		hypotenuse = first_line
		a = second_line
	else
		hypotenuse = second_line
		a = first_line
	end

	if hypotenuse > third_line
		b = third_line
	else
		hypotenuse = third_line
		b = second_line
	end

	right_triangle = a**2 + b**2 == hypotenuse ** 2
	
	puts "Треугольник #{'не' unless right_triangle}прямоугольный#{' и равнобедренный' if isoscales_triangle}"
end