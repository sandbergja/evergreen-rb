# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Evergreen::BibRecord' do
  before do
    stub_request(:get, /fm_IDL\.xml/)
    stub_request(:post, 'https://my.evergreen.edu/osrf-http-translator')
      .with(
        body: 'osrf-msg=[{"__c":"osrfMessage","__p":{"threadTrace":0,"locale":"en-CA","type":"REQUEST","payload"' \
              ':{"__c":"osrfMessage","__p":{"method":"open-ils.pcrud.retrieve.bre",' \
              '"params":["ANONYMOUS","528642"]}}}}]',
        headers: {
          'X-Opensrf-Service' => 'open-ils.pcrud'
        }
      ).to_return(body: File.read(fixture_file('pcrud-bre.json')))
    stub_request(:post, 'https://my.evergreen.edu/osrf-http-translator')
      .with(
        body: 'osrf-msg=[{"__c":"osrfMessage","__p":{"threadTrace":0,"locale":"en-CA",' \
              '"type":"REQUEST","payload":{"__c":"osrfMessage","__p":{' \
              '"method":"open-ils.cat.asset.copy_tree.global.retrieve",' \
              '"params":["","528642"]}}}}]',
        headers: {
          'X-Opensrf-Service' => 'open-ils.cat'
        }
      )
      .to_return(body: File.read(fixture_file('copy_tree.global.retrieve.json')))
  end

  let(:bib_record) do
    configuration = Evergreen::Configuration.new
    configuration.host = 'my.evergreen.edu'
    Evergreen::BibRecord.new(id: 528_642, configuration: configuration, idl: {
                               'bre' => %w[call_numbers fixed_fields active create_date creator deleted
                                           edit_date editor fingerprint id last_xact_id marc quality source tcn_source
                                           tcn_value owner share_depth metarecord language notes keyword_field_entries
                                           subject_field_entries title_field_entries identifier_field_entries
                                           author_field_entries series_field_entries full_record_entries simple_record
                                           authority_links subscriptions attrs mattrs display_entries
                                           flat_display_entries compressed_display_entries wide_display_entry merge_date
                                           merged_to]
                             })
  end

  it 'has a convenience method for creation' do
    evergreen = Evergreen.new do |config|
      config.host = '123'
    end
    expect(evergreen.get_bib_record('456')).to be_instance_of(Evergreen::BibRecord)
  end

  describe '#tcn' do
    it 'returns the TCN from the IDL object' do
      expect(bib_record.tcn).to eq('528642')
    end
  end

  describe '#to_marc' do
    it 'provides a MARC::Record object' do
      expect(bib_record.to_marc).to be_a MARC::Record
    end

    it 'is parsed correctly' do
      expect(bib_record.to_marc['245']['a']).to eq 'México :'
    end
  end

  describe '#holdings' do
    it 'fetches holdings' do
      expect(bib_record.holdings).to be_a Hash
    end
  end
end
