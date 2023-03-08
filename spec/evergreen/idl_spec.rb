# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Evergreen::IDL' do
  before do
    mock_configuration = Evergreen::Configuration.new(host: '123')
    allow(Evergreen).to receive(:configuration).and_return(mock_configuration)
    allow(URI).to receive(:open).and_yield(File.new(File.join(File.dirname(__FILE__), '../fixtures/files/idl.xml')))
  end

  it 'can parse the IDL from XML' do
    idl = Evergreen::IDL.new
    expect(idl.fields).to eq({ 'acn' => %w[copies
                                           create_date creator deleted edit_date
                                           editor id label owning_lib record notes
                                           uri_maps uris label_sortkey label_class prefix
                                           suffix] })
  end
end
