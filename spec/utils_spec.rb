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
end
