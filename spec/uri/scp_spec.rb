require_relative '../spec_helper'

describe URI do
  subject(:instance) { URI.parse(uri) }

  describe :scp do
    context 'standard port' do
      let(:uri) { 'scp://john@berkeley.com/downloads/myfile.pdf' }
      its(:port) { should eq(22) }
      its(:host) { should eq('berkeley.com') }
      its(:user) { should eq('john') }
      its(:path) { should eq('/downloads/myfile.pdf') }
      its(:scheme) { should eq('scp') }
    end

    context 'custom port' do
      let(:uri) { 'scp://john@berkeley.edu:22022/downloads/myfile.pdf' }
      its(:port) { should eq(22022) }
      its(:scheme) { should eq('scp') }
    end

  end
end
