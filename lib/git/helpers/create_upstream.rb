require 'git/helpers/utils'

module Git
  # Provides a set of helper functions to make Git life easier
  module Helpers
    require 'git'
    # Updates a repositories current branch from upstream, and pushes those
    #   to origin
    # @param upstream_user [String] The user of the upstream repo
    # @param repo_dir [String] The directory of the repo to update
    # @param print_details [Boolean] Print messages for each action or not
    def self.create_upstream(upstream_user, repo_dir = Dir.pwd, print_details = true)
      repo = Git.open(repo_dir)
      puts 'Upstream already exists' if print_details && Utils.remote?(repo, 'upstream')
      remote = Utils.remotes_hash(repo)['origin']
      user = Utils.true_name(remote)
      url = Utils.transform_url(remote.url, 'git')
      url.sub!(user, upstream_user)
      puts "Adding upstream with URL #{url}" if print_details
      repo.add_remote('upstream', url)
    end
  end
end
