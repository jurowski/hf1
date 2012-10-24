require 'mongrel_cluster/recipes'

default_run_options[:pty] = true
set :application, "habitforge"
set :repository,  "http://svn.habitforge.com/svn/habitforge/trunk"
set :scm, :subversion
set :scm_username, "svn"
set :scm_password, "check1t1n\!"
set :deploy_via, :remote_cache
set :keep_releases, 3

task :production do
  set :deploy_to, "/home/jurowsk1/etc/rails_apps/#{application}"
  set :mongrel_conf, "#{current_path}/config/mongrel_cluster.yml"
  set :user, "jurowsk1"
  set :runner, "jurowsk1"
  set :rails_env, "production"
  set :keep_releases, 3
  role :web, "habitforge.com"                          # Your HTTP server, Apache/etc
  role :app, "habitforge.com"                          # This may be the same as your `Web` server
  role :db,  "habitforge.com", :primary => true # This is where Rails migrations will run
  after "deploy:symlink", "deploy:cleanup"
end

task :dev do
  set :deploy_to, "/home/jill/domains/dev.habitforge.com/web"
  set :mongrel_conf, "#{current_path}/config/mongrel_cluster.yml"
  set :user, "svn-svn-habitforge"
  set :runner, "svn-svn-habitforge"
  set :rails_env, "development"
  set :keep_releases, 3
  role :web, "dev.habitforge.com"                          # Your HTTP server, Apache/etc
  role :app, "dev.habitforge.com"                          # This may be the same as your `Web` server
  role :db,  "dev.habitforge.com", :primary => true # This is where Rails migrations will run

  # If you are using Passenger mod_rails uncomment this:
  # if you're still using the script/reapear helper you will need
  # these http://github.com/rails/irs_process_scripts
  
  namespace :deploy do
    task :start do ; end
    task :stop do ; end
    task :restart, :roles => :app, :except => { :no_release => true } do
      run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
    end
  end
  after "deploy:symlink", "deploy:cleanup"
end
