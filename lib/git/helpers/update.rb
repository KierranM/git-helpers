require 'git/helpers/utils'

module Git
  # Provides a set of helper functions to make Git life easier
  module Helpers
    require 'git'
    # Updates a repositories current branch from upstream, and pushes those
    #   to origin
    # @param repo_dir [String] The directory of the repo to update
    # @param print_details [Boolean] Print messages for each action or not
    def self.update_repository(repo_dir = Dir.pwd, print_details = true)
      repo = Git.open(repo_dir)
      remote = Utils.remote?(repo, 'upstream') ? 'upstream' : 'origin'
      current_branch = repo.current_branch
      print "Pulling changes from #{remote}/#{current_branch}..." if print_details
      repo.pull(remote, current_branch)
      puts "\tSUCCESS" if print_details
      if remote != 'origin'
        print "Pushing changes to origin/#{current_branch}..." if print_details
        repo.push('origin', current_branch)
        puts "\tSUCCESS" if print_details
      end
    end
  end
end
