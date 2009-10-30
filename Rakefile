#!/usr/bin/env rake

require 'hoe'
Hoe.plugin :doofus, :git

spec = Hoe.spec 'vlad-daemon_kit' do
  developer('James Tucker', 'raggi@rubyforge.org')
  
  self.extra_rdoc_files = FileList["*.rdoc"]
  self.history_file     = "CHANGELOG.rdoc"
  self.readme_file      = "README.rdoc"
  self.rubyforge_name   = "libraggi"
  self.testlib          = :minitest
end

task :release_to_gemcutter => [:clean, :package, :release_sanity] do
  pkg   = "pkg/#{spec.name}-#{spec.version}"
  gems  = Dir["#{pkg}*.gem"]
  gems.each do |g|
    sh "gem push #{g}"
  end
end

task :release_to => :release_to_gemcutter