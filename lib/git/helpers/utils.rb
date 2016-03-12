module Git
  # Provides a set of helper functions to make Git life easier
  module Helpers
    # Provides utility methods for other Git-Helper modules
    module Utils
      # Checks if the given remote exists on the given repo
      # @param repo [Git::Base] The repository in question
      # @param remote [String] The name of the remote to check for
      # @return [Boolean] true if the remote exists, false if not
      def self.remote?(repo, remote)
        repo.remotes.map(&:name).include?(remote)
      end

      # Get a hash of remotes keyed to their name
      # @param repo [Git::Base] Repository to get the remotes for
      # @return [Hash{String => Git::Remote}] A hash of remotes
      def self.remotes_hash(repo)
        Hash[repo.remotes.map { |r| [r.name, r] }]
      end

      # Takes a url from a git remote and transforms it into an normal url with
      #   the desired scheme
      # @param url [String] Url to transform
      # @param scheme [String] What scheme the transformed Url will use, https (default), or http
      # @return [String] A transformed Url
      def self.transform_url(url, scheme = 'https')
        # if git ssh url
        if /^git@/ === url
          url.gsub(/^git@(.*):/, scheme + '://\1/')
        elsif %r{^git://} === url
          url.gsub(/^git/, scheme)
        else
          url
        end
      end
    end
  end
end
