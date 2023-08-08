# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Evergreen::Configuration' do
  before do
    stub_request(:get, /fm_IDL\.xml/)
  end

  it 'provides read access to a configuration object' do
    Evergreen.new(host: 'bc.catalogue.libraries.coop', username: 'user1') do |evergreen|
      expect(evergreen.configuration.host).to be('bc.catalogue.libraries.coop')
    end
  end

  it 'does not allow editing configuration values' do
    Evergreen.new(host: 'gapines.org') do |evergreen|
      expect do
        evergreen.configuration.read_only = true
      end.to raise_error(NoMethodError)
    end
  end

  it 'requires a hostname' do
    expect do
      Evergreen.new(read_only: true)
    end.to raise_error(ArgumentError)
  end

  context 'when not readonly' do
    it 'requires a username and password' do
      expect do
        Evergreen.new(host: 'bc.catalogue.libraries.coop', read_only: false)
      end.to raise_error(ArgumentError)
    end
  end
end
