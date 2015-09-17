access_key = ENV['AWS_ACCESS_KEY_ID_VERMOUTHA']
secret = ENV['AWS_SECRET_ACCESS_KEY_VERMOUTHA']

$s3 = Aws::S3::Resource.new(
  credentials: Aws::Credentials.new(access_key, secret),
  region: 'us-east-1'
)