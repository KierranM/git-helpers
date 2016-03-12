require 'git/helpers/utils'
module Git
  # Provides a set of helper functions to make Git life easier
  module Helpers
    require 'git'
    require 'launchy'

    # Opens the default web browser to an comparison page to open a pull request
    # @param repo_dir [String] Directory of the git repo to browse, defaults to current working dir
    # @param target_remote [String] Name of the target remote, default upstream
    # @param target_branch [String] Name of the branch on the target remote to compare, defaults to current branch
    # @param source_remote [String] Name of the source remote, default origin
    # @param source_branch [String] Name of the branch on the source remote to compare, defaults to current branch
    def self.pull_request(repo_dir = Dir.pwd, target = 'upstream', target_branch = nil, source = 'origin', source_branch = nil)
      repo = Git.open(repo_dir)
      raise "#{target} is not a known remote" unless Utils.remote? repo, target
      raise "#{source} is not a known remote" unless Utils.remote? repo, source
      target_remote = Utils.remotes_hash(repo)[target]
      source_remote = Utils.remotes_hash(repo)[source]
      target_branch ||= repo.current_branch
      source_branch ||= repo.current_branch
      url = target_remote.url.chomp('.git')
      url = Utils.transform_url(url)
      url << "/compare/#{target_branch}...#{Utils.true_name(source_remote)}:#{source_branch}?expand=1"
      Launchy.open url
    end
  end
end
