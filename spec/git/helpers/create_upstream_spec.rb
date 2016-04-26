require 'spec_helper'
require 'git/helpers/browse'

describe Git::Helpers do
  describe '#create_upstream' do
    let(:git_mock) { double('Git::Base') }
    let(:remote) { 'origin' }
    let(:upstream_user) { 'test-user' }
    let(:test_url) { 'git@github.com:test/test.git' }
    let(:transformed_url) { 'git://github.com/test/test' }
    let(:remote_mock) { double('Git::Remote') }
    before :each do
      allow(remote_mock).to receive(:url).and_return test_url
      allow(Git::Helpers::Utils).to receive(:remote?).and_return(true)
      allow(Git::Helpers::Utils).to receive(:remotes_hash).and_return(remote => remote_mock)
      allow(Git::Helpers::Utils).to receive(:transform_url).and_return transformed_url
      allow(Git::Helpers::Utils).to receive(:true_name).and_return 'test'
    end

    context 'when a repo_dir is given' do
      let(:repo_dir) { '/test_dir' }
      it 'opens the Git repo in the given dir' do
        expect(Git).to receive(:open).with(repo_dir).and_return git_mock
        allow(git_mock).to receive(:add_remote)
        subject.create_upstream upstream_user, repo_dir, false
      end
    end

    context 'when no repo_dir is given' do
      it 'opens the Git repo in the current working dir' do
        expect(Git).to receive(:open).with(Dir.pwd).and_return git_mock
        allow(git_mock).to receive(:add_remote)
        subject.create_upstream upstream_user, Dir.pwd, false
      end
    end

    context 'when given an upstream user' do
      let(:repo_dir) { '/test_dir' }
      it 'adds a new read-only upstream' do
        allow(Git).to receive(:open).and_return git_mock
        allow(Git::Helpers::Utils).to receive(:remote?).and_return false
        expect(git_mock).to receive(:add_remote).with('upstream', 'git://github.com/test-user/test')
        subject.create_upstream upstream_user, Dir.pwd, false
      end
    end

    context 'when an upstream already exists' do
      it 'does nothing' do
        expect(git_mock).not_to receive(:add_remote)
        upstream_mock = double('Git::Remote')
        allow(Git::Helpers::Utils).to receive(:remotes_hash).and_return(remote => remote_mock, 'upstream' => upstream_mock)
        subject.create_upstream upstream_user, Dir.pwd, false
      end
    end
  end
end
