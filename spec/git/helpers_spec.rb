require 'spec_helper'

describe Git::Helpers do
  it 'has a version number' do
    expect(Git::Helpers::VERSION).not_to be nil
  end
end
