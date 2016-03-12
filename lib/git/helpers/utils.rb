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

      # Splits a remote/branch string into its component parts
      # @param str [String] String to split
      # @return [Array<String>] remote, branch
      def self.split_remote_string(str)
        first_slash = str.index('/')
        if first_slash.nil?
          return str, nil
        else
          return str[0..first_slash-1], str[first_slash+1..-1]
        end
      end

      # Gets the true name for a remote
      # @param remote [Git::Remote] The remote to get the true name for
      # @return [String] The true name of the remote, pulled from the url
      def self.true_name(remote)
        transform_url(remote.url) =~ %r{^https://.*?/(.*?)/.*$}
        Regexp.last_match 1
      end
    end
  end
end
