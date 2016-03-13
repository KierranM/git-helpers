require 'spec_helper'
require 'git/helpers/utils'

describe Git::Helpers::Utils do
  describe '#remote?' do
    let(:repo_mock) { double('Git::Base') }
    let(:remote_mock) { double('Git::Remote') }
    before :each do
      allow(repo_mock).to receive(:remotes).and_return [remote_mock]
      allow(remote_mock).to receive(:name).and_return 'upstream'
    end

    it 'returns true when the given string is a remote' do
      expect(subject.remote?(repo_mock, 'upstream')).to be true
    end

    it 'returns false when the given strin is not a remote' do
      expect(subject.remote?(repo_mock, 'missing')).to be false
    end
  end

  describe '#remotes_hash' do
    let(:repo_mock) { double('Git::Base') }
    let(:remote_mock) { double('Git::Remote') }

    before :each do
      allow(repo_mock).to receive(:remotes).and_return [remote_mock]
      allow(remote_mock).to receive(:name).and_return 'upstream'
    end

    it 'returns a hash of the remotes, keyed to their name' do
      expect(subject.remotes_hash(repo_mock)).to eq 'upstream' => remote_mock
    end
  end

  describe '#transform_url' do
    context 'when a git ssh url is given' do
      let(:url) { 'git@github.com:test/test' }
      it 'transforms the url to https by default' do
        expect(subject.transform_url(url)).to eq 'https://github.com/test/test'
      end

      it 'transforms the url to http when the scheme argument is given' do
        expect(subject.transform_url(url, 'http')).to eq 'http://github.com/test/test'
      end
    end

    context 'when a git:// url is given' do
      let(:url) { 'git://github.com/test/test' }
      it 'transforms the url to https by default' do
        expect(subject.transform_url(url)).to eq 'https://github.com/test/test'
      end

      it 'transforms the url to http when the scheme argument is given' do
        expect(subject.transform_url(url, 'http')).to eq 'http://github.com/test/test'
      end
    end

    context 'when the url is neither a git ssh or git://' do
      let(:url) { 'https://github.com/test/test' }
      it 'does nothing to the url' do
        expect(subject.transform_url(url)).to eq url
      end
    end
  end

  describe '#split_remote_string' do
    context 'when given a string with just the remote name' do
      let(:test_string) { 'upstream' }
      it 'returns the input as the first return value, nil as the second' do
        expect(subject.split_remote_string(test_string)).to eq [test_string, nil]
      end
    end

    context 'when given a string containing a remote name and branch' do
      let(:test_string) { 'upstream/test_branch' }
      it 'splits the remote and branch name, and returns them' do
        expect(subject.split_remote_string(test_string)).to eq ['upstream', 'test_branch']
      end
    end

    context 'when given a string containing a remote name and a branch name that contains /\'s' do
      let(:test_string) { 'upstream/feature/test_branch' }
      it 'splits the remote and branch name correctly, perserving the slash in branch name' do
        expect(subject.split_remote_string(test_string)).to eq ['upstream', 'feature/test_branch']
      end
    end
  end

  describe '#true_name' do
    let(:remote_mock) { double('Git::Remote') }
    let(:transformed_url) { 'https://github.com/test_user/test' }

    before :each do
      allow(Git::Helpers::Utils).to receive(:transform_url).and_return transformed_url
      allow(remote_mock).to receive(:url)
    end

    it 'returns the correct name for a remote' do
      expect(subject.true_name(remote_mock)).to eq 'test_user'
    end
  end
end
