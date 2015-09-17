require 'sinatra'
require 'aws-sdk'
require 'crowdflower'

get '/' do
  'hello'

  access_key = ENV['AWS_ACCESS_KEY_ID_VERMOUTHA']
  secret = ENV['AWS_SECRET_ACCESS_KEY_VERMOUTHA']
  credentials = Aws::Credentials.new(access_key, secret)
  s3 = Aws::S3::Client.new(region: 'us-east-1', credentials: credentials)
  resp = s3.list_buckets
  puts resp.inspect
end

post '/images' do
  tempfile_path = params['file'][:tempfile].path
  access_key = ENV['AWS_ACCESS_KEY_ID_VERMOUTHA']
  secret = ENV['AWS_SECRET_ACCESS_KEY_VERMOUTHA']

  s3 = Aws::S3::Resource.new(
    credentials: Aws::Credentials.new(access_key, secret),
    region: 'us-east-1'
  )

  key = params['file'][:filename] + Time.now.to_i.to_s
  obj = s3.bucket(ENV['AWS_BUCKET_VERMOUTHA']).object(key)
  obj.upload_file(tempfile_path, acl:'public-read')
  url = obj.public_url

  puts url

  crowdflower_api_key = ENV['CLOUDFLOWER_API_KEY']
  crowdflower_domain_base = ENV["CLOUDFLOWER_DOMAIN_BASE"]
  job_id = 778829

  CrowdFlower::Job.connect! crowdflower_api_key, crowdflower_domain_base
  job = CrowdFlower::Job.new(job_id)
  new_job = job.copy
  unit = CrowdFlower::Unit.new(new_job)
  resp = unit.create({ image_url: url })
  puts resp.inspect
end