# frozen_string_literal: true

require 'spec_helper'
require 'open-uri'

RSpec.describe 'Evergreen::IDL' do
  let(:config) do
    config = Evergreen::Configuration.new
    config.host = '123'
    config
  end

  before do
    stub_request(:get,
                 'https://123/reports/fm_IDL.xml').to_return(body: File.read(File.join(File.dirname(__FILE__),
                                                                                       '../fixtures/files/idl.xml')))
  end

  it 'can parse the IDL from XML' do
    idl = Evergreen::IDL.new config
    expect(idl.fields).to eq({ 'acn' => %w[copies
                                           create_date creator deleted edit_date
                                           editor id label owning_lib record notes
                                           uri_maps uris label_sortkey label_class prefix
                                           suffix] })
  end
end
