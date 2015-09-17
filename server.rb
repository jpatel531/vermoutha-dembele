require 'sinatra'
require 'aws-sdk'
require 'crowdflower'
require './lib/s3'
require './lib/db'
require 'rethinkdb'
require 'json'

include RethinkDB::Shortcuts

get '/' do
  erb :index
end

post '/results' do 
  puts params

  payload = JSON.parse(params["payload"])
  return {success: 200}.to_json unless payload["state"]["finalized"]

  match_id = payload["data"]["id"]

  match_data = payload["results"]["judgments"][0]["data"]

  r.table($rethinkdb.matches_table_name).
    get(match_id).
    update(match_data).
    run($rethinkdb.conn)

  {success:200}.to_json
end

get '/matches' do 
  content_type 'application/json'
  r.table($rethinkdb.matches_table_name).run($rethinkdb.conn).to_a.to_json
end

post '/images' do
  tempfile_path = params['file'][:tempfile].path


  key = params['file'][:filename] + Time.now.to_i.to_s
  obj = $s3.bucket(ENV['AWS_BUCKET_VERMOUTHA']).object(key)
  obj.upload_file(tempfile_path, acl:'public-read')
  url = obj.public_url

  id = r.table($rethinkdb.matches_table_name).insert({image_url: url}).run($rethinkdb.conn)["generated_keys"][0]

  crowdflower_api_key = ENV['CLOUDFLOWER_API_KEY']
  crowdflower_domain_base = ENV["CLOUDFLOWER_DOMAIN_BASE"]
  job_id = 778829

  CrowdFlower::Job.connect! crowdflower_api_key, crowdflower_domain_base
  job = CrowdFlower::Job.new(job_id)
  unit = CrowdFlower::Unit.new(job)
  resp = unit.create(image_url: url, id: id)
  job.resume
  {success:200}.to_json
end