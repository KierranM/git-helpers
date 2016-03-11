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
    end
  end
end
