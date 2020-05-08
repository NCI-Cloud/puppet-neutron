require 'puppet'
require 'puppet/type/neutron_plugin_nsx'

describe 'Puppet::Type.type(:neutron_plugin_nsx)' do

  before :each do
    @neutron_plugin_nsx = Puppet::Type.type(:neutron_plugin_nsx).new(:name => 'DEFAULT/foo', :value => 'bar')
  end

  it 'should autorequire the package that install the file' do
    catalog = Puppet::Resource::Catalog.new
    anchor = Puppet::Type.type(:anchor).new(:name => 'neutron::install::end')
    catalog.add_resource anchor, @neutron_plugin_nsx
    dependency = @neutron_plugin_nsx.autorequire
    expect(dependency.size).to eq(1)
    expect(dependency[0].target).to eq(@neutron_plugin_nsx)
    expect(dependency[0].source).to eq(anchor)
  end

end
