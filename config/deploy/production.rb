set :stage, :production
set :rails_env, :production
set :deploy_to, "/deploy/apps/sample_app"
set :branch, :config
server "103.166.183.90", user: "root", roles: %w(web app db)
