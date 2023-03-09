# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Evergreen::Configuration' do
  before do
    stub_request(:get, /fm_IDL\.xml/)
  end

  it 'accepts configuration as a block' do
    evergreen = Evergreen.new do |config|
      config.host = 'bc.catalogue.libraries.coop'
      config.default_username = 'user1'
    end
    expect(evergreen.configuration.host).to be('bc.catalogue.libraries.coop')
  end

  it 'does not allow editing after config passed via block' do
    evergreen = Evergreen.new { |config| config.host = 'gapines.org' }
    expect do
      evergreen.configuration.read_only = true
    end.to raise_error(FrozenError)
  end

  it 'requires a hostname' do
    expect do
      Evergreen.new { |config| config.read_only = true }
    end.to raise_error(ArgumentError)
  end

  it 'requires a default username and password if not readonly' do
    expect do
      Evergreen.new do |config|
        config.host = 'bc.catalogue.libraries.coop'
        config.read_only = false
      end
    end.to raise_error(ArgumentError)
  end
end
