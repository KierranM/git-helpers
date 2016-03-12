require 'spec_helper'
require 'git/helpers/utils'

describe Git::Helpers::Utils do
  describe '#remote?' do
    let(:repo_mock) { double('Git::Base') }
    let(:remote_mock) {double('Git::Remote')}
    before :each do
      allow(repo_mock).to receive(:remotes).and_return [remote_mock]
      allow(remote_mock).to receive(:name).and_return 'upstream'
    end

    it 'returns true when the given string is a remote' do
      expect(subject.remote? repo_mock, 'upstream').to be true
    end

    it 'returns false when the given strin is not a remote' do
      expect(subject.remote? repo_mock, 'missing').to be false
    end
  end
end
