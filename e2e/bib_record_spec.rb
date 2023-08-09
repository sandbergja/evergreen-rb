require 'evergreen'

RSpec.describe 'Bib records' do
  Evergreen.new(host: 'evergreen') do |evergreen|
    bib = evergreen.get_bib_record(223)
    expect(bib.to_marc['245']['a']).to eq('Throne of the Crescent Moon / ')
  end
end
