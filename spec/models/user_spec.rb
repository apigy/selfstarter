# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  email      :string
#  created_at :datetime
#  updated_at :datetime
#

describe User do

  it { should have_many :orders }
  it { should respond_to :email }

end
