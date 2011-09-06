require 'spec_helper'

describe Congregation do

  it { should belong_to( :language ) }
  it { should have_many( :families ) }
  it { should have_many( :students ) }
  it { should have_many( :school_sessions ) }
  it { should have_many( :special_dates ) }
  it { should have_and_belong_to_many( :users ) }

  it { should validate_presence_of( :number_of_schools ) }
  it { should validate_presence_of( :language_id ) }
  it { should validate_presence_of( :name ) }

end
