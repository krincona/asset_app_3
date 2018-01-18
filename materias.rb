#!/usr/bin/env ruby

list = MateriaInstance.select {|instance| instance.materia.order.status == 5 && instance.materia_instance_status_id == 2 }

list.each do |i|
  i.update_attribute :materia_instance_status_id,3
end


