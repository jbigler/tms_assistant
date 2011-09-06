class User < ActiveRecord::Base

  has_and_belongs_to_many :congregations
  belongs_to :default_congregation, :class_name => "Congregation", :foreign_key => :default_congregation_id

  devise :database_authenticatable, :token_authenticatable, :recoverable, :registerable, :rememberable, :trackable, :confirmable
  default_scope :conditions => { :deleted_at => nil }

  validates_presence_of     :name, :email
  validates_presence_of     :password, :on => :create
  validates_confirmation_of :password, :on => :create
  validates_length_of       :password, :within => 6..30, :allow_blank => true
  validates_uniqueness_of   :email, :case_sensitive => false, :scope => :deleted_at
  validates_format_of       :email, :with => Devise::email_regexp

  after_save :assign_default_congregation, :if => "default_congregation_id.nil?"

  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :admin

  def destroy
    self.update_attribute(:deleted_at, Time.now.utc)
  end

  def self.find_with_destroyed *args
    self.with_exclusive_scope { find(*args) }
  end

  def self.find_only_destroyed
    self.with_exclusive_scope :find => { :conditions => "deleted_at IS NOT NULL" } do
      all
    end
  end

  private

  def assign_default_congregation
    if not congregations.empty?
      self.default_congregation = self.congregations[0]
      self.save
    end
  end

end


# == Schema Information
#
# Table name: users
#
#  id                      :integer         primary key
#  email                   :string(255)     default(""), not null
#  encrypted_password      :string(128)     default(""), not null
#  password_salt           :string(255)     default(""), not null
#  reset_password_token    :string(255)
#  remember_token          :string(255)
#  remember_created_at     :timestamp
#  sign_in_count           :integer         default(0)
#  current_sign_in_at      :timestamp
#  last_sign_in_at         :timestamp
#  current_sign_in_ip      :string(255)
#  last_sign_in_ip         :string(255)
#  confirmation_token      :string(255)
#  confirmed_at            :timestamp
#  confirmation_sent_at    :timestamp
#  authentication_token    :string(255)
#  created_at              :timestamp
#  updated_at              :timestamp
#  name                    :string(255)
#  cached_slug             :string(255)
#  deleted_at              :timestamp
#  default_congregation_id :integer
#  admin                   :boolean         default(FALSE)
#

