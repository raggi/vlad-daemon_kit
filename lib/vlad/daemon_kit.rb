require 'vlad'

class Vlad::DaemonKit
  VERSION = '1.0.1'

  set :mkdirs, 'tmp'
  set :shared_paths, { 'log' => 'log' }
  set :environment, 'production'

  namespace :vlad do
    desc "Start the daemon"
    remote_task :start_app, :roles => :app do
      commands = %w(stop start).map do |command|
        "ruby #{current_path}/bin/#{application} -e #{environment} #{command}"
      end
      run commands.join(' && ')
    end

    desc "Stop the daemon"
    remote_task :stop_app, :roles => :app do
      run "ruby #{current_path}/bin/#{application} -e #{environment} stop"
    end
  end
end