require 'vlad'

class Vlad::DaemonKit
  VERSION = '1.1.2'

  set :mkdirs, 'tmp'
  set :shared_paths, { 'log' => 'log' }
  set :environment, 'production'
  set :arguments, []

  namespace :vlad do
    desc "Run the daemon in the foreground"
    remote_task(:run_app, :extra_args, {:roles => :app}) do |task, args|
      extra_args = args[:extra_args]
      run "cd #{current_path} && bin/#{application} run -e #{environment} #{arguments.join(' ')} #{extra_args}"
    end

    desc "Start the daemon"
    remote_task(:start_app, :extra_args, {:roles => :app}) do |task, args|
      extra_args = args[:extra_args]
      run "cd #{current_path} && bin/#{application} start -e #{environment} #{arguments.join(' ')} #{extra_args}"
    end
    Rake::Task['vlad:start_app'].enhance %w(vlad:stop_app)

    desc "Stop the daemon"
    remote_task :stop_app, :roles => :app do
      run "cd #{current_path} && bin/#{application} stop -e #{environment}"
    end

    desc "Run script/console on the remove"
    task :console do
      ssh_flags << ' -t'
      cmd = "'cd #{current_path} && script/console #{environment}'"
      sh [ssh_cmd, ssh_flags, domain, cmd].join(' ')
    end

    desc "Tail the log"
    task(:tail_app, :extra_args) do |t, args|
      # We don't use a remote task, because it won't terminate cleanly on
      # CTRL+C, which breaks -f args, etc.
      ssh_flags << ' -t'
      extra_args = args[:extra_args]
      cmd = "'cd #{current_path} && tail #{extra_args} log/#{environment}.log'"
      sh [ssh_cmd, ssh_flags, domain, cmd].join(' ')
    end
  end
end