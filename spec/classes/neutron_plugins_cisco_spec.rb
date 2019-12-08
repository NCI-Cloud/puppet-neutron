require 'spec_helper'

describe 'neutron::plugins::cisco' do
  let :pre_condition do
    "class { 'neutron::keystone::authtoken':
      password => 'passw0rd',
     }
     class { 'neutron::server': }
     class { 'neutron': }"
  end

  let :params do
    {
      :keystone_username => 'neutron',
      :keystone_password => 'neutron_pass',
      :keystone_auth_url => 'http://127.0.0.1:5000/v3/',
      :keystone_tenant   => 'tenant',
      :database_name     => 'neutron',
      :database_pass     => 'dbpass',
      :database_host     => 'localhost',
      :database_user     => 'neutron'
    }
  end

  let :params_default do
    {
      :vswitch_plugin    => 'neutron.plugins.openvswitch.ovs_neutron_plugin.OVSNeutronPluginV2',
      :vlan_start        => '100',
      :vlan_end          => '3000',
      :vlan_name_prefix  => 'q-',
      :model_class       => 'neutron.plugins.cisco.models.virt_phy_sw_v2.VirtualPhysicalSwitchModelV2',
      :max_ports         => '100',
      :max_port_profiles => '65568',
      :max_networks      => '65568',
      :manager_class     => 'neutron.plugins.cisco.segmentation.l2network_vlan_mgr_v2.L2NetworkVLANMgr',
      :purge_config      => false,
    }
  end

  shared_examples 'default cisco plugin' do
    before do
      params.merge!(params_default)
    end

    it 'should create plugin symbolic link' do
      should contain_file('/etc/neutron/plugin.ini').with(
        :ensure  => 'link',
        :target  => '/etc/neutron/plugins/cisco/cisco_plugins.ini',
      )
      should contain_file('/etc/neutron/plugin.ini').that_requires('Anchor[neutron::config::begin]')
      should contain_file('/etc/neutron/plugin.ini').that_notifies('Anchor[neutron::config::end]')
    end

    it 'should have a plugin config folder' do
      should contain_file('/etc/neutron/plugins').with(
        :ensure => 'directory',
        :owner  => 'root',
        :group  => 'neutron',
        :mode   => '0640'
      )
    end

    it 'should have a cisco plugin config folder' do
      should contain_file('/etc/neutron/plugins/cisco').with(
        :ensure => 'directory',
        :owner  => 'root',
        :group  => 'neutron',
        :mode   => '0640'
      )
    end

    it 'passes purge to resource plugin_cisco' do
      should contain_resources('neutron_plugin_cisco').with({
        :purge => false
      })
    end

    it 'passes purge to resource cisco_db_conn' do
      should contain_resources('neutron_plugin_cisco_db_conn').with({
        :purge => false
      })
    end

    it 'passes purge to resource cisco_l2network' do
      should contain_resources('neutron_plugin_cisco_l2network').with({
        :purge => false
      })
    end

    it 'passes purge to resource cisco_credentials' do
      should contain_resources('neutron_plugin_cisco_credentials').with({
        :purge => false
      })
    end

    it 'should perform default l2 configuration' do
      should contain_neutron_plugin_cisco_l2network('VLANS/vlan_start').\
        with_value(params[:vlan_start])
      should contain_neutron_plugin_cisco_l2network('VLANS/vlan_end').\
        with_value(params[:vlan_end])
      should contain_neutron_plugin_cisco_l2network('VLANS/vlan_name_prefix').\
        with_value(params[:vlan_name_prefix])
      should contain_neutron_plugin_cisco_l2network('MODEL/model_class').\
        with_value(params[:model_class])
      should contain_neutron_plugin_cisco_l2network('PORTS/max_ports').\
        with_value(params[:max_ports])
      should contain_neutron_plugin_cisco_l2network('PORTPROFILES/max_port_profiles').\
        with_value(params[:max_port_profiles])
      should contain_neutron_plugin_cisco_l2network('NETWORKS/max_networks').\
        with_value(params[:max_networks])
      should contain_neutron_plugin_cisco_l2network('SEGMENTATION/manager_class').\
        with_value(params[:manager_class])
    end

    it 'should create a dummy inventory item' do
      should contain_neutron_plugin_cisco('INVENTORY/dummy').\
        with_value('dummy')
    end

    it 'should configure the db connection' do
      should contain_neutron_plugin_cisco_db_conn('DATABASE/name').\
        with_value(params[:database_name])
      should contain_neutron_plugin_cisco_db_conn('DATABASE/user').\
        with_value(params[:database_user])
      should contain_neutron_plugin_cisco_db_conn('DATABASE/pass').\
        with_value(params[:database_pass])
      should contain_neutron_plugin_cisco_db_conn('DATABASE/host').\
        with_value(params[:database_host])
    end

    it 'should configure the admin credentials' do
      should contain_neutron_plugin_cisco_credentials('keystone/username').\
        with_value(params[:keystone_username])
      should contain_neutron_plugin_cisco_credentials('keystone/password').\
        with_value(params[:keystone_password])
      should contain_neutron_plugin_cisco_credentials('keystone/password').with_secret( true )
      should contain_neutron_plugin_cisco_credentials('keystone/auth_url').\
        with_value(params[:keystone_auth_url])
      should contain_neutron_plugin_cisco_credentials('keystone/tenant').\
        with_value(params[:keystone_tenant])
    end

    it 'should perform vswitch plugin configuration' do
      should contain_neutron_plugin_cisco('PLUGINS/vswitch_plugin').\
          with_value('neutron.plugins.openvswitch.ovs_neutron_plugin.OVSNeutronPluginV2')
    end

    describe 'with nexus plugin' do
      before do
        params.merge!(:nexus_plugin => 'neutron.plugins.cisco.nexus.cisco_nexus_plugin_v2.NexusPlugin')
      end

      it 'should perform nexus plugin configuration' do
        should contain_neutron_plugin_cisco('PLUGINS/nexus_plugin').\
          with_value('neutron.plugins.cisco.nexus.cisco_nexus_plugin_v2.NexusPlugin')
      end
    end
  end

  shared_examples 'neutron::plugins::cisco on Ubuntu' do
    it 'configures /etc/default/neutron-server' do
      should contain_file_line('/etc/default/neutron-server:NEUTRON_PLUGIN_CONFIG').with(
        :path    => '/etc/default/neutron-server',
        :match   => '^NEUTRON_PLUGIN_CONFIG=(.*)$',
        :line    => 'NEUTRON_PLUGIN_CONFIG=/etc/neutron/plugins/cisco/cisco_plugins.ini',
        :tag     => 'neutron-file-line',
      )
      should contain_file_line('/etc/default/neutron-server:NEUTRON_PLUGIN_CONFIG').that_requires('Anchor[neutron::config::begin]')
      should contain_file_line('/etc/default/neutron-server:NEUTRON_PLUGIN_CONFIG').that_notifies('Anchor[neutron::config::end]')
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'default cisco plugin'

      if facts[:operatingsystem] == 'Ubuntu'
        it_behaves_like 'neutron::plugins::cisco on Ubuntu'
      end
    end
  end
end
