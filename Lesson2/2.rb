# Посмотри как это можно сделать с помощью метода итератора: 1.<method>() {}.
#
# что-то мне подсказывает, что вы про другой метод, но пока вроде это только подходящее
array = (10..100).step(5).map { |i| i }
puts array