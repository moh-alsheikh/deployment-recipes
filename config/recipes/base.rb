def template(from, to)
  erb = File.read(File.expand_path("../templates/#{from}", __FILE__))
  put ERB.new(erb).result(binding), to
end

def set_default(name, *args, &block)
  set(name, *args, &block) unless exists?(name)
end

def add_apt_repository(repo)
  run "#{sudo} add-apt-repository #{repo}", :pty => true do |ch, stream, data|
    if data =~ /Press.\[ENTER\].to.continue/
      ch.send_data("\n")
    else
      Capistrano::Configuration.default_io_proc.call(ch, stream, data)
    end
  end
end

namespace :deploy do
  desc "Install everything onto the server"
  task :install do
    template "environment", "/tmp/environment"
    run "#{sudo} mv /tmp/environment /etc/environment"
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y install python-software-properties"
  end
end


__END__


sudo adduser deployer --ingroup sudo