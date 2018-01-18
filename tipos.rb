list = MateriaInstance.select {|instance| !instance.materia.univ && instance.at_date.year==2017 }

[*1..12].each do |mes| 
  count = 0
  list.select{|i| i.at_date.month==mes }.each {|j| count+= j.duration}
  puts "#{mes} : #{count}"
end 