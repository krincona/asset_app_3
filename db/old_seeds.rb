require 'csv'

def file_to_array(file)
  resources = CSV.read(file)
  return resources
end

def seed_resource(resources,resource_name)

  #resources = CSV.read(file)
  header = resources.first.map &:to_sym
  resources = resources[1..-1]

  seed = []
  resources.each {|item| seed << Hash[header.zip(item)]}

  object  = Object.const_get(resource_name)
  seed.each {|item| object.create(item)}

end

#parents  = file_to_array('lib/csv/parents.csv')
students = file_to_array('lib/csv/students.csv')
tutors   = file_to_array('lib/csv/tutores.csv')

#seed_resource(parents,'Parent')

students[1..-1].each do |student|
  if !Parent.where("card_id = ?", '' + student[4] + '').empty?
    student[4] = Parent.where("card_id = ?", '' + student[4] + '')[0].id
  else
    student[4]=0
  end
end

students = students.select {|s| s[4]!=0}

seed_resource(students,'Student')

tutors[1..-1].each {|tutor| tutor[4]=tutor[4].split()}

seed_resource(tutors,'Tutor')




















# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
=begin
#Tutors
# {:name,:email,:profile,:category:level,:university,:grade,:homephone,:cellphone,:major}
tutor_test = [
  {name:"R.Daneel Olivaw",email:"dolivaw@assimov.sci",
    profile:["", "Fisica", "Matematicas"],category:3,level:"Bachillerato BIL",
    university:"National Fundation University",grade:"5",
    homephone:"018000112170",cellphone:"3155315513",major:"Fisica"},
  {name:"Hari Seldon",email:"hseldon@assimov.sci",
    profile:["","Biologia","Quimica"],category:2,level:"Bachillerato ESP",
    university:"Universidad de la Fundacion e Imperio",grade:"2",
    homephone:"018000113171",cellphone:"3202200220", major:"Quimica"},
  {name:"Eto Demerzel",email:"edemerzel@assimov.sci",
    profile:["","Frances","Filosofia"],category:2,level:"Hasta 9 BIL",
    university:"Universidad de la Fundacion e Imperio",grade:"2",
    homephone:"018000113171",cellphone:"3202200220",major:"Filosofia"}
  ]
count = 100
tutor_test.each do |tutor|
  Tutor.create!(name: tutor[:name],email: tutor[:email],category: tutor[:category],
  level: tutor[:level],university: tutor[:university],grade: tutor[:grade],
  homephone: tutor[:homephone],cellphone: tutor[:cellphone],major: tutor[:major],
  password:"tutor"+count.to_s, password_confirmation:"tutor"+count.to_s )
  count+=1
end
=end
