require 'yaml'

module GithubPostReceiveServer
  class Deploy

    WHITE_LIST = YAML.load_file(File.expand_path '../../../whitelist.yml', __FILE__)

    def self.go(payload) 
      ref_pushed = payload['ref']

      branch_match = ref_pushed.match(/refs\/heads\/([a-z]+)/)
      unless branch_match.nil?
        branch = branch_match[1]
        if WHITE_LIST.has_key?(branch)
          cd WHITE_LIST[branch]
          git('pull', 'origin', branch)
          cap('beta', 'deploy:migrations')
        end
      end

      $?
    end

    def self.cd(wd)
      return unless $?.nil? || $?.exitstatus == 0
      `cd #{wd}`
    end

    def self.git(cmd, repo = 'origin', branch = 'master')
      return unless $?.nil? || $?.exitstatus == 0
      puts ">>> #{cmd}ing #{branch} from #{repo} in #{`pwd`}"
      `git #{cmd} #{repo} #{branch}`
    end

    def self.cap(stage, task)
      return unless $?.nil? || $?.exitstatus == 0
      puts ">>> Cap #{stage} #{task} in #{`pwd`}"
      `cap #{stage} #{task}`
    end
  end
end