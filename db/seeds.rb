
# MateriaInstanceStatus

instance_status = {1=> "Tutor Pendiente"   , 
                   2=> "Reservada"         , 
                   3=> "Confirmada"        ,   
                   4=> "Dictada"           , 
                   5=> "Pagada"            }

instance_status.each do |key,value|
  MateriaInstanceStatus.create(id:key,name:value)
end

# MateriaStatus

materia_status  = {1=> "Sin Publicar"      , 
                   2=> "Publicada"         , 
                   3=> "Reservada"         , 
                   4=> "Pendiente de Tutor", 
                   5=> "Confirmada"        }

materia_status.each do |key,value|
  MateriaStatus.create(id:key,name:value)
end

# OrderStatus

order_status    = {1=> "En Proceso"        , 
                   2=> "En Oferta"         , 
                   3=> "Pendiente de Pago" , 
                   4=> "Pendiente de Tutor", 
                   5=> "Confirmada"        , 
                   6=> "Caduca"            }

order_status.each do |key,value|
  OrderStatus.create(id:key,name:value)
end

# Tutor

Tutor.create(id:1,name:"Andres Pruebas",email:"krusworks@gmail.com",card_id:"80165831",category:1,active:true)
