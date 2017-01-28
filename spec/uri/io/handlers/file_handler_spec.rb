require File.expand_path('spec/spec_helper')

describe URI::IO::FileHandler do
  context '#read' do
    let(:spec_root) { URI::IO.gem_root + '/spec' }

    let(:resource_name) { "#{spec_root}/fixtures/data.json" }
    let(:resource_content) { File.read(resource_name) }

    let(:uri) { "file://#{resource_name}" }

    subject(:io) { URI::IO[uri] }

    its(:class) { should eq URI::IO::Proxy }

  end
end
