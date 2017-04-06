# config valid only for current version of Capistrano
lock '3.8.0'

set :application, "confess_bot"
set :repo_url, "git@github.com:ngocthang/confess_bot.git"
set :assets_roles, [:app]
set :deploy_ref, ENV["DEPLOY_REF"]
set :bundle_binstubs, ->{shared_path.join("bin")}

if fetch(:deploy_ref)
  set :branch, fetch(:deploy_ref)
else
  raise "Please set $DEPLOY_REF"
end

set :deploy_to, "/usr/local/rails_apps/#{fetch :application}"
set :pid_file, "#{shared_path}/tmp/pids/unicorn.pid"
set :unicorn_rack_env, ENV["RAILS_ENV"] || "production"
set :unicorn_config_path, "#{current_path}/config/unicorn.rb"

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, []

# Default value for linked_dirs is []
# NOTE: public/uploads IS USED ONLY FOR THE STAGING ENVIRONMENT
set :linked_dirs, %w(bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads)

# Default value for default_env is {}
set :default_env, {
  rails_env: ENV["RAILS_ENV"],
  deploy_ref: ENV["DEPLOY_REF"],
  deploy_ref_type: ENV["DEPLOY_REF_TYPE"],
  aws_region: ENV["AWS_REGION"],
  aws_elb_name: ENV["AWS_ELB_NAME"],
  aws_access_key_id: ENV["AWS_ACCESS_KEY_ID"],
  aws_secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
  s3_bucket_name: ENV["S3_BUCKET_NAME"],
  devise_secret_key: ENV["DEVISE_SECRET_KEY"],
  secret_key_base: ENV["SECRET_KEY_BASE"],
  database_name: ENV["DATABASE_NAME"],
  database_hostname: ENV["DATABASE_HOSTNAME"],
  database_username: ENV["DATABASE_USERNAME"],
  database_password: ENV["DATABASE_PASSWORD"],
  redis_hostname: ENV["REDIS_HOSTNAME"],
  host: ENV["HOST"],
  twilio_account_sid: ENV["TWILIO_ACCOUNT_SID"],
  twilio_auth_token: ENV["TWILIO_AUTH_TOKEN"],
  twilio_phone_number: ENV["TWILIO_PHONE_NUMBER"],
  email_username: ENV["EMAIL_USERNAME"],
  email_password: ENV["EMAIL_PASSWORD"]
}

# Default value for keep_releases is 5
# set :keep_releases, 5


namespace :deploy do
  desc "create database"
  task :create_database do
    on roles(:db) do |host|
      within "#{release_path}" do
        with rails_env: ENV["RAILS_ENV"] do
          execute :rake, "db:create"
        end
      end
    end
  end
  before :migrate, :create_database

  desc "link dotenv"
  task :link_dotenv do
    on roles(:app) do
      execute "ln -s /home/deploy/.env #{release_path}/.env"
    end
  end
  before :restart, :link_dotenv

  desc "Restart application"
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke "unicorn:restart"
    end
  end
  after :publishing, :restart

  #desc "update ec2 tags"
  #task :update_ec2_tags do
  #  on roles(:app) do
  #    within "#{release_path}" do
  #      execute :rake, "tag:update_ec2_tags" if fetch(:stage) == :production
  #    end
  #  end
  #end
  #after :restart, :update_ec2_tags
end
