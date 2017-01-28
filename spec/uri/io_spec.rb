require_relative '../spec_helper'

describe URI::IO do
  it 'has a version number' do
    expect(URI::IO::VERSION).not_to be nil
  end
  context 'new handler' do
    module URI::IO::MommyHandler

    end
  end
end
