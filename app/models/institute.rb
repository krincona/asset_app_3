class Institute < ActiveRecord::Base
	has_many :students

	has_many :institute_users, :dependent => :delete_all
	accepts_nested_attributes_for :institute_users,reject_if: :all_blank, :allow_destroy => true
end
