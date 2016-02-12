require 'spec_helper'

describe Git::Helpers do
  it 'has a version number' do
    expect(Git::Helpers::VERSION).not_to be nil
  end

  it 'does something useful' do
    expect(false).to eq(true)
  end
end
