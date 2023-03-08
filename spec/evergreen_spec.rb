# frozen_string_literal: true

RSpec.describe Evergreen do
  it 'has a version number' do
    expect(Evergreen::VERSION).not_to be_nil
  end
end
