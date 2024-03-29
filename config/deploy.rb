default_run_options[:pty] = true
set :application, "pairful"
set :repository,  "git@github.com:Araki/CouplingServer.git"
set :ssh_options, {
  :user => "ec2-user",
  :keys => ["~/.ssh/coupling_tokyo.pem"],
}
set :deploy_to, "/var/www/#{application}"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "54.248.83.160"                          # Your HTTP server, Apache/etc
role :app, "54.248.83.160"                          # This may be the same as your `Web` server
role :db,  "54.248.83.160", :primary => true        # This is where Rails migrations will run
role :db,  "54.248.83.160"

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

#If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
