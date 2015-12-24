set_default(:postgresql_host, "localhost")
set_default(:postgresql_user) { application }
set_default(:postgresql_password) { Capistrano::CLI.password_prompt "PostgreSQL Password: " }
set_default(:postgresql_database) { "#{application}_production" }

namespace :postgresql do
  desc "Install the latest stable release of PostgreSQL."
  task :install, roles: :db, only: {primary: true} do

    add_apt_repository 'ppa:pitti/postgresql'
    run "#{sudo} apt-get install wget ca-certificates"
    run "#{sudo} apt-get update"
    run "#{sudo} apt-get upgrade"
    run "#{sudo} apt-get install postgresql-9.2 libpq-dev  -y"
    
    
  end
  after "deploy:install", "postgresql:install"

  desc "Create a database for this application."
  task :create_database, roles: :db, only: {primary: true} do
    run %Q{#{sudo} -u postgres psql -c "create user #{postgresql_user} with password '#{postgresql_password}';"}
    run %Q{#{sudo} -u postgres psql -c "create database #{postgresql_database} owner #{postgresql_user};"}
  end
  after "deploy:setup", "postgresql:create_database"

  desc "Generate the database.yml configuration file."
  task :setup, roles: :app do
    run "mkdir -p #{shared_path}/config"
    template "postgresql.yml.erb", "#{shared_path}/config/database.yml"
  end
  after "deploy:setup", "postgresql:setup"

  desc "Symlink the database.yml file into latest release"
  task :symlink, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  after "deploy:finalize_update", "postgresql:symlink"
end


__END__

    #run "#{sudo} add-apt-repository ppa:pitti/postgresql"
    #add_apt_repository 'ppa:pitti/postgresql'
    #run "#{sudo} apt-get -y update"
    #run "#{sudo} apt-get -y install postgresql libpq-dev"
    
    
    =====================================================================================
    
    Add the following to  environment
    
    sudo nano /etc/environment
    
    ==========
    
LANGUAGE=en_US.UTF-8
LC_ALL=en_US.UTF-8
LANG=en_US.UTF-8
LC_TYPE=en_US.UTF-8
    
    
    =====================================================================================
    
    #run "#{sudo} locale-gen en_US.UTF-8"
    #run "export LANGUAGE=en_US.UTF-8"
    #run "export LC_ALL=en_US.UTF-8"
    #run "export LANG=en_US.UTF-8"
    #run "export LC_TYPE=en_US.UTF-8"
    
    
    run "#{sudo} locale-gen en_US en_US.UTF-8"
    run "#{sudo} dpkg-reconfigure locales"
    #run "export LANGUAGE=en_US.UTF-8"
    #run "export LC_ALL=en_US.UTF-8"
    
    =====================================================================================
    
    run "#{sudo} pg_createcluster 9.2 main --start"