class Collaborator < ActiveRecord::Base
  belongs_to :user
  belongs_to :wiki
  
#   before_save :check_unique
  
  private
  
  def check_unique
    if Collaborator.exist?(user_id: user_id, wiki_id: wiki_id)
      false
    end
  end
end
