require "bundler/capistrano"
#require "whenever/capistrano"

load "config/recipes/base"
load "config/recipes/nginx"
load "config/recipes/unicorn"
load "config/recipes/postgresql"
load "config/recipes/imagemagik"
load "config/recipes/nodejs"
load "config/recipes/rbenv"
load "config/recipes/check"
load "config/recipes/utility"


#server "46.101.131.140", :web, :app, :db, primary: true
server "192.168.8.101", :web, :app, :db, primary: true

set :user, "deployer"
set :application, "appdeployment"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via,  :copy
set :use_sudo, false

set :scm, "git"
set :repository, "."
set :branch, "master"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
#ssh_options[ :port ] = 44444

after "deploy:cold", "unicorn:restart"
after "deploy:cold", "utility:djstop"
after "deploy:cold", "utility:djstart"
after "deploy", "deploy:cleanup" # keep only the last 5 releases


__END__


#set :whenever_command, "bundle exec whenever"

#after "deploy:cold", "nginx:restart"
#after "deploy:cold", "utility:jobsrestart"
#bundle exec rake jobs:work

#ssh_options[:verbose] = :debug