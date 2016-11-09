fibonachi_numbers = [0, 1]
loop do
    new_number = fibonachi_numbers[-2] + fibonachi_numbers[-1]
    break if new_number >= 100
    fibonachi_numbers << new_number
end
puts fibonachi_numbers