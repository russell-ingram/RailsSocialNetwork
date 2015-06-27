set :application, 'ETRFITO'
set :repo_url, 'git@bitbucket.org:disasteruss/etr-dev.git'
set :user, "disasteruss"
set :password, "acer321"

set :deploy_to, '/home/deploy/etr-dev'

set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, 'deploy:restart'
  after :finishing, 'deploy:cleanup'
end
