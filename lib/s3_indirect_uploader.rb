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

  def full_path key
    ret = "#{@path}/#{key}"
    ret << ".#{@extension}" unless @extension.nil?
    return ret
  end

  def url(key)
    @bucket.objects[full_path(key)].url_for(:read, :expires => EXPIRE_DOWNLOAD).to_s
  end

  def publish_url(key, options = {})
    expires = options[:expires] || default_options[:expires]
    acl     = options[:acl]     || default_options[:acl]

    form = @bucket.presigned_post(
      key: full_path(key),
      expires: expires,
      acl: acl
    )
  end
end
