ActiveAdmin.register Materia do
  belongs_to :order
  permit_params  :id,:order_id,:name,:until_re_date,:student_id,:students_number, :topic,
  :_destroy, :materia_instances_attributes=> [:id,:duration, :materia_id, :at_date,:at_time, :order_id, :tutor_id,:_destroy]


end
