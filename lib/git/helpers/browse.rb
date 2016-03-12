require 'git/helpers/utils'
module Git
  # Provides a set of helper functions to make Git life easier
  module Helpers
    require 'git'
    require 'launchy'

    # Opens the default web browser to the specified repositorys page based on
    #   the the specified remote, and tree
    # @param repo_dir [String] Directory of the git repo to browse, defaults to current working dir
    # @param remote_name [String] Name of the remote to browse, defaults to origin
    # @param tree [String] Tree to browse, can be a branch name, tag, or commit hash
    def self.browse(repo_dir = Dir.pwd, remote_name = 'origin', tree = nil)
      repo = Git.open(repo_dir)
      raise "#{remote_name} is not a known remote" unless Utils.remote? repo, remote_name
      remote = Utils.remotes_hash(repo)[remote_name]
      tree ||= repo.current_branch
      url = remote.url.chomp('.git')
      url = Utils.transform_url(url)
      url << "/tree/#{tree}"
      Launchy.open url
    end
  end
end
