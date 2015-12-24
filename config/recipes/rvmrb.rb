# set_default :ruby_version, "1.9.3-p125"
set_default :ruby_version, "1.9.3-p392"

#set_default :rbenv_bootstrap, "bootstrap-ubuntu-10-04"
set_default :rbenv_bootstrap, "bootstrap-ubuntu-12-04"

def mrbenv(command)
  run "rbenv #{command}", :pty => true do |ch, stream, data|
    if data =~ /\[sudo\].password.for/
      ch.send_data(Capistrano::CLI.password_prompt("Password:") + "\n")
    else
      Capistrano::Configuration.default_io_proc.call(ch, stream, data)
    end
  end
end

namespace :rvmrb  do
  desc "Install rvm, Ruby, and the Bundler gem"
  task :install, roles: :app do
    
    run "#{sudo} apt-get -y install curl git-core"
    run "git config --global user.name 'Mohammed Alsheikh'"
    run "git config --global user.email 'msheikh2009@yahoo.com'"
    run "#{sudo} apt-get -y update"
    run "curl -L get.rvm.io | bash -s stable"
    run "gem install bundler --no-ri --no-rdoc"
    run "gem install rails -v=3.2.12"

    end
    after "deploy:install", "rvmrb:install"
  end
  