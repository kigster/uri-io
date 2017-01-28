require_relative '../spec_helper'

describe URI::IO do
  it 'has a version number' do
    expect(URI::IO::VERSION).not_to be nil
  end

  context '#register_handler' do
    before do
      module URI::IO::MommyHandler
      end
    end
    subject!(:mommy) { URI::IO.register_handler(URI::IO::MommyHandler) }
    its(:keys) { should match %i(class operations options) }
  end

  context 'gem_root' do
    it 'should be correctly defined' do
      expect(URI::IO.gem_root).to end_with('/uri-io')
    end
    it 'should exist' do
      expect(Dir.exist?(URI::IO.gem_root)).to eq true
    end
  end

  context '#handlers' do
    it 'should be defined and have "file"' do
      expect(URI::IO.handlers['file'][:class]).to eq URI::IO::FileHandler
    end
  end

end
