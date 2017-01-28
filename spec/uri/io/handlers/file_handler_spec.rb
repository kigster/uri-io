require File.expand_path('spec/spec_helper')

describe URI::IO::FileHandler do
  context 'handler registery' do
    subject { URI::IO.handlers['file'][:class] }
    its(:name) { should eq(URI::IO::FileHandler.name) }
  end
end
