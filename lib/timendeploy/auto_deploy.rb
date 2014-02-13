require 'yaml'

module Timendeploy
  class Deploy

    WHITE_LIST = YAML.load_file(File.expand_path '../../../whitelist.yml', __FILE__)

    def self.go(payload) 
      ref_pushed = payload['ref']

      branch_match = ref_pushed.match(/refs\/heads\/([a-z]+)/)
      unless branch_match.nil?
        branch = branch_match[1]
        if WHITE_LIST.has_key?(branch)
          branch_config = WHITE_LIST[branch]
	        wd = branch_config.has_key?('directory') ? branch_config['directory'] : WHITE_LIST[branch]
          Dir.chdir(wd){
            git('checkout', {:branch => branch})
            git('fetch', {:repo => 'origin', :branch => branch})
            git('pull', {:repo => 'origin', :branch => branch})
          }
	        cap_stage = branch_config.has_key?('stage') ? branch_config['stage'] : branch
	        cap_task = branch_config.has_key?('task') ? branch_config['task'] : 'deploy:migrations'
          Dir.chdir(wd){
            cap(cap_stage, cap_task)
          }
        end
      end

      $?
    end

    def self.git(cmd, opts=nil)
      return unless $?.nil? || $?.exitstatus == 0
      branch = opts.nil? ? 'master' : opts[:branch]
      repo = opts.nil? ? 'origin' : opts[:repo]
      puts ">>> #{cmd}ing #{opts} from #{repo} in #{`pwd`}"
      if cmd == 'checkout'
        `git #{cmd} #{branch}`
      else
        `git #{cmd} #{repo} #{branch}`
      end
    end

    def self.cap(stage, task)
      return unless $?.nil? || $?.exitstatus == 0
      puts ">>> Cap #{stage} #{task} in #{`pwd`}"
      `export BUNDLE_GEMFILE=#{Dir.pwd}/Gemfile && bundle exec cap #{stage} #{task}`
    end
  end
end