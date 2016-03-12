require 'spec_helper'
require 'git/helpers/browse'

describe Git::Helpers do
  describe '#browse' do
    let(:git_mock) { double('Git::Base') }
    let(:remote) { 'origin' }
    let(:current_branch) { 'test_branch' }
    let(:test_url) { 'git@github.com:test/test.git' }
    let(:transformed_url) { 'https://github.com/test/test' }
    let(:url_with_tree) { 'https://github.com/test/test/tree/test_branch' }
    let(:remote_mock) { double('Git::Remote') }
    before :each do
      allow(git_mock).to receive(:current_branch).and_return current_branch
      allow(remote_mock).to receive(:url).and_return test_url
      allow(Git::Helpers::Utils).to receive(:remote?).and_return(true)
      allow(Git::Helpers::Utils).to receive(:remotes_hash).and_return(remote => remote_mock)
      allow(Git::Helpers::Utils).to receive(:transform_url).and_return transformed_url
      allow(Git).to receive(:open).and_return git_mock
      allow(Launchy).to receive :open
    end

    context 'when no arguments are given' do
      it 'opens the Git repo in the current working dir' do
        expect(Git).to receive(:open).with(Dir.pwd).and_return git_mock
        subject.browse
      end

      it 'opens the "origin" remote by default' do
        expect(Git::Helpers::Utils).to receive(:remote?).with(git_mock, remote)
        subject.browse
      end

      it 'transforms the url, using the current branch as tree' do
        expect(Launchy).to receive(:open).with(url_with_tree)
        subject.browse
      end
    end

    context 'when a repo_dir is given' do
      let(:repo_dir) { '/test_dir' }
      it 'opens the Git repo in the current working dir' do
        expect(Git).to receive(:open).with(repo_dir).and_return git_mock
        subject.browse repo_dir
      end
    end

    context 'when a remote is given' do
      let(:repo_dir) { '/test_dir' }

      it 'retreives the correct remote' do
        expect(Git::Helpers::Utils).to receive(:remote?).with(git_mock, remote)
        subject.browse repo_dir, remote
      end

      it 'raises an exception if the remote doesnt exist' do
        allow(Git::Helpers::Utils).to receive(:remote?).and_return(false)
        expect { subject.browse repo_dir, remote }.to raise_exception 'origin is not a known remote'
      end
    end

    context 'when a tree is given' do
      let(:repo_dir) { '/test_dir' }
      let(:current_branch) { 'hello' }
      let(:url_with_tree) { 'https://github.com/test/test/tree/hello' }

      it 'transforms the url, using the tree argument' do
        expect(Launchy).to receive(:open).with(url_with_tree)
        subject.browse repo_dir, remote, current_branch
      end
    end
  end
end
