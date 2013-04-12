# coding:utf-8
class Friend < Member
  belongs_to :group

  def as_json(options = {})
      json = super(options)
      # json['images'] = self.images.as_json
      json
  end  

end
