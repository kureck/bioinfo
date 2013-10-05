class User
	include Mongoid::Document
	include Mongoid::Timestamps
	# Include default devise modules. Others available are:
	# :token_authenticatable, :confirmable,
	# :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
	     :recoverable, :rememberable, :trackable, :validatable

	## Database authenticatable
	field :email,              :type => String, :default => ""
	field :encrypted_password, :type => String, :default => ""

	## Rememberable
	field :remember_created_at, :type => Time

	## Trackable
	field :sign_in_count,      :type => Integer, :default => 0
	field :current_sign_in_at, :type => Time
	field :last_sign_in_at,    :type => Time
	field :current_sign_in_ip, :type => String
	field :last_sign_in_ip,    :type => String

	index({ email: 1 }, { unique: true, background: true })
	field :name, :type => String

	# Setup accessible (or protected) attributes for your model
	attr_accessible :name, :email, :password, :password_confirmation, :remember_me
	# attr_accessible :title, :body

	has_many :initial_inputs, :dependent => :destroy
	has_many :merge_files, :dependent => :destroy
end
