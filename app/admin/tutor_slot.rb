ActiveAdmin.register TutorSlot do

  menu false

  permit_params :id,:day,:from_hour_hour,:from_hour_minute,
  :to_hour_hour,:to_hour_minute, :tutor_id



end
