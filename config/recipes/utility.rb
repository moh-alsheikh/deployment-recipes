set_default :rails_env , "RAILS_ENV= 'production' "

namespace :utility do
  
  desc "migrate the database"
  task :migrate do
    run "cd #{current_path}; bundle exec rake db:migrate RAILS_ENV=#{rails_env}"
  end
  
  desc "reload the database with schema load"
  task :schema do
    run "cd #{current_path}; bundle exec rake db:schema:load RAILS_ENV=#{rails_env}"
  end
  
  desc "reload the database with seed data"
  task :seed do
    run "cd #{current_path}; bundle exec rake db:seed RAILS_ENV=#{rails_env}"
  end
  
  desc "reload the database with seed data"
  task :drop do
    run "cd #{current_path}; bundle exec rake db:drop RAILS_ENV=#{rails_env}"
  end
  
  desc "start delayed jobs"
  task :djstart do
    #run "cd #{current_path}; RAILS_ENV=#{rails_env} bundle exec bin/delayed_job -n 4 start"
    run "cd #{current_path}; RAILS_ENV=#{rails_env} bundle exec bin/delayed_job start"
  end
  
  desc "stop delayed jobs"
  task :djstop do
    run "cd #{current_path};  RAILS_ENV=#{rails_env} bundle exec bin/delayed_job stop"
  end
  
  desc "restart delayed jobs"
  task :djrestart do
    #run "cd #{current_path};  RAILS_ENV=#{rails_env} bundle exec bin/delayed_job -n 2 restart"
    run "cd #{current_path};  RAILS_ENV=#{rails_env} bundle exec bin/delayed_job restart"
  end
  
  #==================================================================
  
  desc "start jobs"
  task :jobsstart do
    run "cd #{current_path}; RAILS_ENV=#{rails_env} bundle exec rake jobs:work"
  end
  
  desc "stop jobs"
  task :jobsstop do
    run "cd #{current_path};  RAILS_ENV=#{rails_env} bundle exec rake jobs:stop"
  end
  
  desc "restart jobs"
  task :jobsrestart do
    run "cd #{current_path};  RAILS_ENV=#{rails_env} bundle exec rake jobs:restart"
  end
  
  #==================================================================
  
  desc "whenever update"
  task :whenever_update do
    run "cd #{current_path}; RAILS_ENV=#{rails_env} bundle exec whenever --update-crontab"
  end
  
  #==================================================================
  
  desc "open remote rails console"
  task :console, :roles => :app do
    hostname = find_servers_for_task(current_task).first
    exec "ssh -l #{user} #{hostname} -p 44444 -t 'cd #{current_path}; bundle exec rails console #{rails_env}'"
  end
  
  desc "open remote rails db a.k.a psql"
  task :pgpsql, :roles => :app do      
      hostname = find_servers_for_task(current_task).first
      exec "ssh -l #{user} #{hostname} -p 44444 -t 'cd #{current_path}; bundle exec rails db #{rails_env}'"
  end
  
end

__END__
