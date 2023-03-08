# frozen_string_literal: true

RSpec.describe Evergreen::ILS do
  it 'has a version number' do
    expect(Evergreen::ILS::VERSION).not_to be nil
  end
end
