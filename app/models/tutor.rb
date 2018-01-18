class Tutor < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_many :materia_instances
  has_many :tutoria_instances
  has_many :tutorias

  has_one :user, :as => :user_role

  #has_many :tutor_slots, :dependent => :delete_all
  #accepts_nested_attributes_for :tutor_slots,  :allow_destroy => true


  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  scope :activos,  -> {where(:status => true)}
  scope :inactivos,  -> {where(:status => false)}

  validates :name,           presence: true
  validates :email,          presence: true, uniqueness: true

  after_create :create_user

  default_scope  { order(:name => :asc) }



  Levels = ["Primaria / Bachillerato ESP","Primaria / Bachillerato BIL",
            "Primaria ESP","Primaria BIL","Bachillerato ESP",
            "Bachillerato BIL","Hasta 9 ESP","Hasta 9 BIL"].sort

  CATEGORY = {1=>18000,2=>19000,3=>20000}


  def create_user

    new_user = User.create(email:self.email,role:3,password:self.card_id,password_confirmation:self.card_id,user_role_id:self.id, user_role_type:Tutor.model_name.name)
    self.user_id = new_user.id
  end

  def shortname
    return self.name.split(' ', 2)[0]
  end

  def is_bilingual?
    if self.level[-3..-1] == 'BIL'
      "Si"
    else
      "No"
    end
  end

  def payable_materia_instances
    #payables = {}
    instances = MateriaInstance.select {|inst| inst.tutor_id==self.id && inst.payable?}
  end

=begin
    instances.each do |inst|
      subsidy = inst.student.parent.subsidy_amount
      total   = inst.tutor_payable + subsidy
      if !payables.has_key? inst.materia.order_id

        payables[inst.materia.order_id] = {"student"=> inst.student.name ,inst.id => inst.tutor_payable,"subtotal"=> inst.tutor_payable, "hours"=> inst.duration, "subsidy"=> subsidy, "total"=> total  }
      else
        payables[inst.materia.order_id][inst.id] = inst.tutor_payable
        payables[inst.materia.order_id]["subtotal"] += inst.tutor_payable
        payables[inst.materia.order_id]["hours"] += inst.duration
        payables[inst.materia.order_id]["subsidy"] += subsidy
        payables[inst.materia.order_id]["subsidy"] += total
      end
    end

    #payables = self.materias.select {|mat| mat.has_payables?}
    return payables
=end

  def hourly_rate
    per_hour = Tutor::CATEGORY[self.category]

    return per_hour

  end

  def total_account
    total = 0
    self.payable_materia_instances.each {|inst| total+= inst.total_payable}
    return total
  end


  def balance(inputs)
    from = inputs["inicia"].to_date
    to = inputs["termina"].to_date
    tutorias = self.tutoria_instances.select{|tutoria| tutoria.at_date <= to &&
                                                        tutoria.at_date >= from}
    balance = {}
    per_hour = Tutor::CATEGORY[self.category]
    tutorias.each do |tutoria|
      student = tutoria.student.name
      if balance.has_key? student
        balance[student][:hours]+= tutoria.duration
        balance[student][:total]+= tutoria.duration*per_hour
      else

        balance[student] = {:hours => tutoria.duration,
                            :valor_hora=> per_hour,
                            :total => tutoria.duration*per_hour}
      end
    end
    return balance
  end

  def self.balance_to_csv(data)
    CSV.generate do |csv|
      csv << ["tutor","alumno","horas","valor hora","total"]
      data.each do |k,v|
        v.each do |q,b|
          csv << [k,q,b[:valor_hora],b[:total]]
        end
      end
    end
  end


end
