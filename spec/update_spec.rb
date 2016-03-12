require 'spec_helper'
require 'git/helpers/update'

describe Git::Helpers do
  describe '#update_repository' do
    let(:git_mock) { double('Git::Base') }
    let(:current_branch) { 'test_branch' }
    before :each do
      allow(git_mock).to receive :pull
      allow(git_mock).to receive :push
      allow(git_mock).to receive(:current_branch).and_return current_branch
      allow(Git::Helpers::Utils).to receive(:remote?).and_return(true)
      allow(Git).to receive(:open).and_return git_mock
      allow(Git::Helpers).to receive :puts
      allow(Git::Helpers).to receive :print
    end

    context 'when no repo_dir is given' do
      it 'opens the Git repo in the current working dir' do
        expect(Git).to receive(:open).with(Dir.pwd).and_return git_mock
        subject.update_repository
      end
    end

    context 'when a repo_dir is given' do
      let(:repo_dir) { 'test_dir' }

      it 'opens the Git repo in the current working dir' do
        expect(Git).to receive(:open).with(repo_dir).and_return git_mock
        subject.update_repository repo_dir
      end
    end

    context 'when upstream exists as a remote' do
      it 'checks if upstream exists' do
        expect(Git::Helpers::Utils).to receive(:remote?).with(git_mock, 'upstream').and_return(true)
        subject.update_repository
      end

      it 'pulls from upstream' do
        expect(git_mock).to receive(:pull).with('upstream', current_branch)
        subject.update_repository
      end

      it 'pushes to origin' do
        expect(git_mock).to receive(:push).with('origin', current_branch)
        subject.update_repository
      end
    end

    context 'when upstream does not exist as a remote' do
      before :each do
        allow(Git::Helpers::Utils).to receive(:remote?).and_return(false)
      end
      it 'checks if upstream exists' do
        expect(Git::Helpers::Utils).to receive(:remote?).with(git_mock, 'upstream').and_return(false)
        subject.update_repository
      end

      it 'pulls from origin' do
        expect(git_mock).to receive(:pull).with('origin', current_branch)
        subject.update_repository
      end

      it 'does not push to origin' do
        expect(git_mock).not_to receive(:push).with('origin', current_branch)
        subject.update_repository
      end
    end
  end
end
