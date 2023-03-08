# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Evergreen::Configuration' do
  before do
    Evergreen.configuration = nil
  end

  it 'accepts configuration as a block' do
    Evergreen.configure do |config|
      config.host = 'bc.catalogue.libraries.coop'
      config.default_username = 'user1'
    end
    expect(Evergreen.configuration.host).to be('bc.catalogue.libraries.coop')
  end

  it 'does not allow editing after config passed via block' do
    Evergreen.configure { |config| config.host = 'gapines.org' }
    expect do
      Evergreen.configuration.read_only = true
    end.to raise_error(FrozenError)
  end

  it 'accepts configuration as an initializer' do
    my_config = Evergreen::Configuration.new(host: 'libweb.cityofalbany.net')
    expect(my_config.host).to be('libweb.cityofalbany.net')
  end

  it 'does not allow editing after it is configured in the initializer' do
    my_config = Evergreen::Configuration.new(host: '123')
    expect do
      my_config.read_only = true
    end.to raise_error(FrozenError)
  end

  it 'requires a hostname' do
    expect do
      Evergreen::Configuration.new(read_only: true)
    end.to raise_error(ArgumentError)
  end

  it 'requires a default username and password if not readonly' do
    expect do
      Evergreen.configure do |config|
        config.host = 'bc.catalogue.libraries.coop'
        config.read_only = false
      end
    end.to raise_error(ArgumentError)
  end
end
