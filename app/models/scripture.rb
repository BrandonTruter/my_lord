class Scripture < ActiveRecord::Base
  belongs_to :user
  
  validates_presence_of :title, :reference, :verse
  
  def daily_verse
    # scriptures = Scripture.all
   #  randomly_selected = rand(0..scriptures.count)
   #
   #  s = scriptures.find_by(id: randomly_selected)
   #  random_verse = s.verse
    # return random_verse
    
    return self.verse
  end

end
