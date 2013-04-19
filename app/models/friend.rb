# coding:utf-8
class Friend < Member
  attr_accessible :age, :gender

  belongs_to :group

  def create_friend(params)
    self.class.transaction do
      self.create!(params[:friend])
      self.hobbies << Hobby.where(:id => params[:hobbies])
      self.characters << Character.where(:id => params[:characters])
      self.specialities << Speciality.where(:id => params[:specialities])
    end
    true
  rescue ActiveRecord::RecordInvalid => e
    false
  rescue => e
    self.errors.add :base, e.message
    false
  end

  def as_json(options = {})
      json = super(options)
      # json['images'] = self.images.as_json
      json
  end  

end
