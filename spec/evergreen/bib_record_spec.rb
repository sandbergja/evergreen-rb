# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Evergreen::BibRecord' do
  before do
    stub_request(:get, /fm_IDL\.xml/)
  end

  it 'has a convenience method for creation' do
    evergreen = Evergreen.new do |config|
      config.host = '123'
    end
    expect(evergreen.get_bib_record('456')).to be_instance_of(Evergreen::BibRecord)
  end
end
