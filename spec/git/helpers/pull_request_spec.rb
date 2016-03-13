require 'spec_helper'
require 'git/helpers/browse'

describe Git::Helpers do
  describe '#browse' do
    let(:git_mock) { double('Git::Base') }
    let(:source_remote) { 'origin' }
    let(:source_remote_name) { 'source_user' }
    let(:target_remote) { 'upstream' }
    let(:current_branch) { 'test_branch' }
    let(:test_url) { 'git@github.com:test/test.git' }
    let(:transformed_url) { 'https://github.com/test/test' }
    let(:comparison_url) { 'https://github.com/test/test/compare/test_branch...source_user:test_branch?expand=1' }
    let(:remote_mock) { double('Git::Remote') }
    before :each do
      allow(git_mock).to receive(:current_branch).and_return current_branch
      allow(remote_mock).to receive(:url).and_return test_url
      allow(Git::Helpers::Utils).to receive(:remote?).and_return(true)
      allow(Git::Helpers::Utils).to receive(:remotes_hash).and_return(target_remote => remote_mock, source_remote => remote_mock)
      allow(Git::Helpers::Utils).to receive(:transform_url).and_return transformed_url
      allow(Git::Helpers::Utils).to receive(:true_name).and_return source_remote_name
      allow(Git).to receive(:open).and_return git_mock
      allow(Launchy).to receive :open
    end

    context 'when no arguments are given' do
      it 'opens the Git repo in the current working dir' do
        expect(Git).to receive(:open).with(Dir.pwd).and_return git_mock
        subject.pull_request
      end

      it 'uses the "upstream" and "origin" remotes by default' do
        expect(Git::Helpers::Utils).to receive(:remote?).with(git_mock, source_remote)
        expect(Git::Helpers::Utils).to receive(:remote?).with(git_mock, target_remote)
        subject.pull_request
      end

      it 'creates a url for a comparison between upstream and origin' do
        expect(Launchy).to receive(:open).with(comparison_url)
        subject.pull_request
      end
    end

    context 'when a repo_dir is given' do
      let(:repo_dir) { '/test_dir' }
      it 'opens the Git repo in the current working dir' do
        expect(Git).to receive(:open).with(repo_dir).and_return git_mock
        subject.pull_request repo_dir
      end
    end

    context 'when a target remote is given' do
      let(:repo_dir) { '/test_dir' }

      it 'retreives the correct remote' do
        expect(Git::Helpers::Utils).to receive(:remote?).with(git_mock, target_remote)
        subject.pull_request repo_dir, target_remote
      end

      it 'raises an exception if the target remote doesnt exist' do
        allow(Git::Helpers::Utils).to receive(:remote?).and_return(false)
        expect { subject.pull_request repo_dir, target_remote }.to raise_exception 'upstream is not a known remote'
      end

      it 'raises an exception if the source remote doesnt exist' do
        allow(Git::Helpers::Utils).to receive(:remote?).with(git_mock, source_remote).and_return(false)
        expect { subject.pull_request repo_dir, target_remote }.to raise_exception 'origin is not a known remote'
      end
    end

    context 'when a target remote and branch are given' do
      let(:repo_dir) { '/test_dir' }
      let(:current_branch) { 'hello' }
      let(:comparison_url) { 'https://github.com/test/test/compare/hello...source_user:hello?expand=1' }

      it 'opens the correct comparison Url' do
        expect(Launchy).to receive(:open).with(comparison_url)
        subject.pull_request repo_dir, target_remote, current_branch
      end
    end

    context 'when a target remote and branch and a source remote and branch are given' do
      let(:repo_dir) { '/test_dir' }
      let(:current_branch) { 'hello' }
      let(:target_branch) { 'target' }
      let(:source_branch) { 'source' }
      let(:comparison_url) { 'https://github.com/test/test/compare/target...source_user:source?expand=1' }

      it 'checks the given remotes' do
        expect(Git::Helpers::Utils).to receive(:remote?).with(git_mock, target_remote)
        expect(Git::Helpers::Utils).to receive(:remote?).with(git_mock, source_remote)
        subject.pull_request repo_dir, target_remote, target_branch, source_remote, source_branch
      end

      it 'opens the correct comparison Url' do
        allow(Git::Helpers::Utils).to receive(:true_name).and_return source_remote_name

        expect(Launchy).to receive(:open).with(comparison_url)
        subject.pull_request repo_dir, target_remote, target_branch, source_remote, source_branch
      end
    end
  end
end
