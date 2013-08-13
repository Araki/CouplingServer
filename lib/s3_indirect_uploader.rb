class S3IndirectUploader

  EXPIRE_UPLOAD = 120
  EXPIRE_DOWNLOAD = 10

  def initialize(path, extension = nil)
    @path = path
    @extension = extension unless extension.nil?
    @bucket = AWS::S3.new.buckets[Pref::AWS::BUCKETNAME]
  end

  attr_reader :bucket

  def default_options
    {
      expires: EXPIRE_UPLOAD.seconds.from_now
    }
  end

  def full_path(id)
    ret = "#{@path}/#{id}"
    ret << ".#{@extension}" unless @extension.nil?
    return ret
  end

  def url(id)
    @bucket.objects[full_path(id)].url_for(:read, :expires => EXPIRE_DOWNLOAD).to_s
  end

  def presigned_post(id, options = {})
    expires = options[:expires] || default_options[:expires]
    acl     = options[:acl]     || default_options[:acl]

    form = @bucket.presigned_post(key: full_path(id), expires: expires, acl: acl)
    { 
      url: form.url.to_s,
      fields: form.fields
    }
  end
end
