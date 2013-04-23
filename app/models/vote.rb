class Vote < ActiveRecord::Base

  belongs_to :user

  def delete_and_save
    self.delete
    self.save
  end

end
