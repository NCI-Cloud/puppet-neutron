require 'spec_helper'

describe 'neutron::agents::ml2::ovs' do
  let :pre_condition do
    "class { 'neutron': }"
  end

  let :default_params do
    { :package_ensure  => 'present',
      :enabled         => true,
      :bridge_uplinks  => [],
      :bridge_mappings => [],
      :local_ip        => false,
      :tunnel_types    => [],
      :firewall_driver => 'iptables_hybrid',
      :manage_vswitch  => true,
      :purge_config    => false,
      :enable_dpdk     => false,
      }
  end

  let :params do
    {}
  end

  shared_examples 'neutron plugin ovs agent with ml2 plugin' do
    let :p do
      default_params.merge(params)
    end

    it { should contain_class('neutron::params') }

    it 'passes purge to resource' do
      should contain_resources('neutron_agent_ovs').with({
        :purge => false
      })
    end

    it 'configures plugins/ml2/openvswitch_agent.ini' do
      should contain_neutron_agent_ovs('ovs/bridge_mappings').with_ensure('absent')
      should contain_neutron_agent_ovs('agent/polling_interval').with_value('<SERVICE DEFAULT>')
      should contain_neutron_agent_ovs('agent/report_interval').with_value('<SERVICE DEFAULT>')
      should contain_neutron_agent_ovs('DEFAULT/rpc_response_max_timeout').with_value('<SERVICE DEFAULT>')
      should contain_neutron_agent_ovs('agent/l2_population').with_value('<SERVICE DEFAULT>')
      should contain_neutron_agent_ovs('agent/arp_responder').with_value('<SERVICE DEFAULT>')
      should contain_neutron_agent_ovs('agent/drop_flows_on_start').with_value('<SERVICE DEFAULT>')
      should contain_neutron_agent_ovs('agent/extensions').with_value('<SERVICE DEFAULT>')
      should contain_neutron_agent_ovs('agent/minimize_polling').with_value('<SERVICE DEFAULT>')
      should contain_neutron_agent_ovs('agent/tunnel_csum').with_value('<SERVICE DEFAULT>')
      should contain_neutron_agent_ovs('ovs/datapath_type').with_value('<SERVICE DEFAULT>')
      should contain_neutron_agent_ovs('ovs/vhostuser_socket_dir').with_value('<SERVICE DEFAULT>')
      should contain_neutron_agent_ovs('ovs/ovsdb_timeout').with_value('<SERVICE DEFAULT>')
      should contain_neutron_agent_ovs('ovs/of_listen_address').with_value('<SERVICE DEFAULT>')
      should contain_neutron_agent_ovs('ovs/of_listen_port').with_value('<SERVICE DEFAULT>')
      should contain_neutron_agent_ovs('ovs/of_connect_timeout').with_value('<SERVICE DEFAULT>')
      should contain_neutron_agent_ovs('ovs/of_request_timeout').with_value('<SERVICE DEFAULT>')
      should contain_neutron_agent_ovs('ovs/of_inactivity_probe').with_value('<SERVICE DEFAULT>')
      should contain_neutron_agent_ovs('ovs/integration_bridge').with_value('<SERVICE DEFAULT>')
      should contain_neutron_agent_ovs('securitygroup/firewall_driver').\
        with_value(p[:firewall_driver])
      should contain_neutron_agent_ovs('securitygroup/enable_security_group').\
        with_value('<SERVICE DEFAULT>')
      should contain_neutron_agent_ovs('securitygroup/permitted_ethertypes').\
        with_value('<SERVICE DEFAULT>')
      should contain_neutron_agent_ovs('ovs/tunnel_bridge').with_ensure('absent')
      should contain_neutron_agent_ovs('ovs/local_ip').with_ensure('absent')
      should contain_neutron_agent_ovs('ovs/int_peer_patch_port').with_ensure('absent')
      should contain_neutron_agent_ovs('ovs/tun_peer_patch_port').with_ensure('absent')
      should contain_neutron_agent_ovs('agent/tunnel_types').with_ensure('absent')
      should contain_neutron_agent_ovs('agent/vxlan_udp_port').with_ensure('absent')
      should contain_neutron_agent_ovs('ovs/bridge_mac_table_size').with_value('<SERVICE DEFAULT>')
      should contain_neutron_agent_ovs('ovs/igmp_snooping_enable').with_value('<SERVICE DEFAULT>')
      should contain_neutron_agent_ovs('ovs/resource_provider_bandwidths').\
        with_value('<SERVICE DEFAULT>')
      should contain_neutron_agent_ovs('ovs/resource_provider_hypervisors').\
        with_value('<SERVICE DEFAULT>')
      should contain_neutron_agent_ovs('ovs/resource_provider_packet_processing_without_direction').\
        with_value('<SERVICE DEFAULT>')
      should contain_neutron_agent_ovs('ovs/resource_provider_packet_processing_with_direction').\
        with_value('<SERVICE DEFAULT>')
      should contain_neutron_agent_ovs('ovs/resource_provider_default_hypervisor').\
        with_value('<SERVICE DEFAULT>')
      should contain_neutron_agent_ovs('ovs/resource_provider_inventory_defaults').\
        with_value('<SERVICE DEFAULT>')
      should contain_neutron_agent_ovs('ovs/resource_provider_packet_processing_inventory_defaults').\
        with_value('<SERVICE DEFAULT>')
      should contain_neutron_agent_ovs('agent/explicitly_egress_direct').with_value('<SERVICE DEFAULT>')
      should contain_neutron_agent_ovs('network_log/rate_limit').with_value('<SERVICE DEFAULT>')
      should contain_neutron_agent_ovs('network_log/burst_limit').with_value('<SERVICE DEFAULT>')
      should contain_neutron_agent_ovs('network_log/local_output_log_base').with_value('<SERVICE DEFAULT>')
    end

    it 'installs neutron ovs agent package' do
      should contain_package('neutron-ovs-agent').with(
        :name   => platform_params[:ovs_agent_package],
        :ensure => p[:package_ensure],
        :tag    => ['openstack', 'neutron-package'],
      )
    end

    it 'configures neutron ovs agent service' do
      should contain_service('neutron-ovs-agent-service').with(
        :name    => platform_params[:ovs_agent_service],
        :enable  => true,
        :ensure  => 'running',
        :tag     => ['neutron-service'],
      )
      should contain_service('neutron-ovs-agent-service').that_subscribes_to('Anchor[neutron::service::begin]')
      should contain_service('neutron-ovs-agent-service').that_notifies('Anchor[neutron::service::end]')
    end

    context 'with manage_service as false' do
      before :each do
        params.merge!(:manage_service => false)
      end
      it 'should not manage the service' do
        should_not contain_service('neutron-ovs-agent-service')
      end
    end

    context 'when supplying permitted ethertypes by an array' do
      before :each do
        params.merge!(:permitted_ethertypes => ['0x4008', '0x5'])
      end
      it 'should configured ethertypes' do
        should contain_neutron_agent_ovs('securitygroup/permitted_ethertypes').with_value('0x4008,0x5')
      end
    end

    context 'when supplying permitted ethertypes by a string' do
      before :each do
        params.merge!(:permitted_ethertypes => '0x4008,0x5')
      end
      it 'should configured ethertypes' do
        should contain_neutron_agent_ovs('securitygroup/permitted_ethertypes').with_value('0x4008,0x5')
      end
    end

    context 'when supplying a firewall driver' do
      before :each do
        params.merge!(:firewall_driver => false)
      end
      it 'should configure firewall driver' do
        should contain_neutron_agent_ovs('securitygroup/firewall_driver').with_ensure('absent')
      end
    end

    context 'when disabling security groups' do
      before :each do
        params.merge!(:enable_security_group => false)
      end
      it 'should disable securitygroups' do
        should contain_neutron_agent_ovs('securitygroup/enable_security_group').with_value('false')
      end
    end


    context 'when enabling ARP responder' do
      before :each do
        params.merge!(:arp_responder => true)
      end
      it 'should enable ARP responder' do
        should contain_neutron_agent_ovs('agent/arp_responder').with_value(true)
      end
    end

    context 'when enabling DVR' do
      before :each do
        params.merge!(:enable_distributed_routing => true,
                      :l2_population              => true )
      end
      it 'should enable DVR' do
        should contain_neutron_agent_ovs('agent/enable_distributed_routing').with_value(true)
      end
    end

    context 'when supplying bridge mappings for provider networks' do
      before :each do
        params.merge!(:bridge_uplinks => ['br-ex:eth2'],:bridge_mappings => ['default:br-ex'])
      end

      it 'should require vswitch::ovs' do
        should contain_class('vswitch::ovs')
      end

      it 'configures bridge mappings' do
        should contain_neutron_agent_ovs('ovs/bridge_mappings').with_value(params[:bridge_mappings].join(','))
      end

      it 'should configure bridge mappings' do
        params[:bridge_mappings].each do |bridge_mapping|
          should contain_neutron__plugins__ovs__bridge(bridge_mapping).with(
            :before => 'Service[neutron-ovs-agent-service]'
          )
        end
      end

      it 'should configure bridge uplinks' do
        params[:bridge_uplinks].each do |bridge_uplink|
          should contain_neutron__plugins__ovs__port(bridge_uplink).with(
            :before => 'Service[neutron-ovs-agent-service]'
          )
        end
      end
    end

    context 'when supplying bridge mappings for provider networks with manage vswitch set to false' do
      before :each do
        params.merge!(:bridge_uplinks => ['br-ex:eth2'],:bridge_mappings => ['default:br-ex'], :manage_vswitch => false)
      end

      it 'should not require vswitch::ovs' do
        should_not contain_class('vswitch::ovs')
      end

      it 'configures bridge mappings' do
        should contain_neutron_agent_ovs('ovs/bridge_mappings').with_value(params[:bridge_mappings].join(','))
      end

      it 'should not configure bridge mappings' do
        params[:bridge_mappings].each do |bridge_mapping|
          should_not contain_neutron__plugins__ovs__bridge(bridge_mapping)
        end
      end

      it 'should not configure bridge uplinks' do
        params[:bridge_uplinks].each do |bridge_uplink|
          should_not contain_neutron__plugins__ovs__port(bridge_uplink)
        end
      end
    end

    context 'when supplying multiple bridge mappings' do
      before :each do
        params.merge!({
          :bridge_uplinks  => ['br-ex:eth2','br-tenant:eth3'],
          :bridge_mappings => ['default:br-ex','tenant:br-tenant'],
        })
      end

      it 'should require vswitch::ovs' do
        should contain_class('vswitch::ovs')
      end

      it 'configures bridge mappings' do
        should contain_neutron_agent_ovs('ovs/bridge_mappings').with_value(params[:bridge_mappings].join(','))
      end

      it 'should configure bridge mappings' do
        params[:bridge_mappings].each do |bridge_mapping|
          should contain_neutron__plugins__ovs__bridge(bridge_mapping).with(
            :before => 'Service[neutron-ovs-agent-service]'
          )
        end
      end

      it 'should configure bridge uplinks' do
        params[:bridge_uplinks].each do |bridge_uplink|
          should contain_neutron__plugins__ovs__port(bridge_uplink).with(
            :before => 'Service[neutron-ovs-agent-service]'
          )
        end
      end
    end

    context 'when setting ovsdb_timeout' do
      before :each do
        params.merge!( :ovsdb_timeout => 30 )
      end

      it 'configures ovsdb_timeout' do
        should contain_neutron_agent_ovs('ovs/ovsdb_timeout').with_value(params[:ovsdb_timeout])
      end
    end

    context 'when setting of_listen_address and of_listen_port' do
      before :each do
        params.merge!(
          :of_listen_address => '127.0.0.1',
          :of_listen_port    => 6633,
        )
      end

      it 'configures of_listen_address' do
        should contain_neutron_agent_ovs('ovs/of_listen_address').with_value(params[:of_listen_address])
      end

      it 'configures of_listen_port' do
        should contain_neutron_agent_ovs('ovs/of_listen_port').with_value(params[:of_listen_port])
      end
    end

    context 'when setting of_connect_timeout and of_request_timeout' do
      before :each do
        params.merge!(
          :of_connect_timeout => 30,
          :of_request_timeout => 20
        )
      end

      it 'configures of_connect_timeout' do
        should contain_neutron_agent_ovs('ovs/of_connect_timeout').with_value(params[:of_connect_timeout])
      end

      it 'configures of_request_timeout' do
        should contain_neutron_agent_ovs('ovs/of_request_timeout').with_value(params[:of_request_timeout])
      end
    end

    context 'when setting of_inactivity_probe' do
      before :each do
        params.merge!( :of_inactivity_probe => 20 )
      end

      it 'configures of_inactivity_probe' do
        should contain_neutron_agent_ovs('ovs/of_inactivity_probe').with_value(params[:of_inactivity_probe])
      end
    end

    context 'when supplying extensions for ML2 plugin' do
      before :each do
        params.merge!(:extensions => ['qos'])
      end

      it 'configures extensions' do
        should contain_neutron_agent_ovs('agent/extensions').with_value(params[:extensions].join(','))
      end
    end

    context 'when supplying DPDK specific options' do
      before :each do
        params.merge!(:datapath_type => 'netdev', :vhostuser_socket_dir => '/var/run/openvswitch')
      end

      it 'configures ovs for DPDK' do
        should contain_neutron_agent_ovs('ovs/datapath_type').with_value(params[:datapath_type])
        should contain_neutron_agent_ovs('ovs/vhostuser_socket_dir').with_value(params[:vhostuser_socket_dir])
      end
    end

    context 'when enabling tunneling' do
      context 'without local ip address' do
        before :each do
          params.merge!({
            :tunnel_types => ['vxlan']
          })
        end

        it { should raise_error(Puppet::Error, /Local ip for ovs agent must be set when tunneling is enabled/) }
      end

      context 'with default params' do
        before :each do
          params.merge!({
            :tunnel_types => ['vxlan'],
            :local_ip     => '127.0.0.1'
          })
        end
        it 'should configure ovs for tunneling' do
          should contain_neutron_agent_ovs('ovs/tunnel_bridge').with_value('<SERVICE DEFAULT>')
          should contain_neutron_agent_ovs('ovs/local_ip').with_value('127.0.0.1')
          should contain_neutron_agent_ovs('ovs/int_peer_patch_port').with_value('<SERVICE DEFAULT>')
          should contain_neutron_agent_ovs('ovs/tun_peer_patch_port').with_value('<SERVICE DEFAULT>')
          should contain_neutron_agent_ovs('agent/vxlan_udp_port').with_value('<SERVICE DEFAULT>')
        end
      end

      context 'with vxlan tunneling' do
        before :each do
          params.merge!({
            :tunnel_types   => ['vxlan'],
            :local_ip       => '127.0.0.1',
            :vxlan_udp_port => 49155
          })
        end

        it 'should perform vxlan network configuration' do
          should contain_neutron_agent_ovs('agent/tunnel_types').with_value(params[:tunnel_types])
          should contain_neutron_agent_ovs('agent/vxlan_udp_port').with_value(params[:vxlan_udp_port])
        end
      end

      context 'when l2 population is disabled and DVR and tunneling enabled' do
        before :each do
          params.merge!({
            :enable_distributed_routing => true,
            :l2_population              => false,
            :tunnel_types               => ['vxlan'],
            :local_ip                   => '127.0.0.1'
          })
        end

        it { should raise_error(Puppet::Error, /L2 population must be enabled when DVR and tunneling are enabled/) }
      end

      context 'when DVR is enabled and l2 population and tunneling are disabled' do
        before :each do
          params.merge!({
            :enable_distributed_routing => true,
            :l2_population              => false,
            :tunnel_types               => []
          })
        end

        it 'should enable DVR without L2 population' do
          should contain_neutron_agent_ovs('agent/enable_distributed_routing').with_value(true)
          should contain_neutron_agent_ovs('agent/l2_population').with_value(false)
        end
      end
    end

    context 'when enabling dpdk with manage vswitch disabled' do
      before :each do
        params.merge!(:enable_dpdk => true, :manage_vswitch => false)
      end

      it { should raise_error(Puppet::Error, /Enabling DPDK without manage vswitch does not have any effect/) }
    end

    context 'when parameters for resource providers are set' do
      before :each do
        params.merge!(
          :resource_provider_bandwidths         => ['provider-a', 'provider-b'],
          :resource_provider_hypervisors        => ['provider-a:compute-a', 'provider-b:compute-b'],
          :resource_provider_packet_processing_without_direction => [':1000:1000'],
          :resource_provider_packet_processing_with_direction    => [':2000:2000'],
          :resource_provider_default_hypervisor => 'compute-c',
          :resource_provider_inventory_defaults => ['allocation_ratio:1.0', 'min_unit:1', 'step_size:1'],
          :resource_provider_packet_processing_inventory_defaults => ['allocation_ratio:2.0', 'min_unit:2', 'step_size:2'],
        )
      end

      it 'configures resource providers' do
        should contain_neutron_agent_ovs('ovs/resource_provider_bandwidths').\
          with_value('provider-a,provider-b')
        should contain_neutron_agent_ovs('ovs/resource_provider_hypervisors').\
          with_value('provider-a:compute-a,provider-b:compute-b')
        should contain_neutron_agent_ovs('ovs/resource_provider_packet_processing_without_direction').\
          with_value(':1000:1000')
        should contain_neutron_agent_ovs('ovs/resource_provider_packet_processing_with_direction').\
          with_value(':2000:2000')
        should contain_neutron_agent_ovs('ovs/resource_provider_default_hypervisor').\
          with_value('compute-c')
        should contain_neutron_agent_ovs('ovs/resource_provider_inventory_defaults').\
          with_value('allocation_ratio:1.0,min_unit:1,step_size:1')
        should contain_neutron_agent_ovs('ovs/resource_provider_packet_processing_inventory_defaults').\
          with_value('allocation_ratio:2.0,min_unit:2,step_size:2')
      end
    end

    context 'when parameters for resource providers are set by hash' do
      before :each do
        params.merge!(
          :resource_provider_inventory_defaults => {
            'allocation_ratio' => '1.0',
            'min_unit'         => '1',
            'step_size'        => '1'
          },
          :resource_provider_packet_processing_inventory_defaults => {
            'allocation_ratio' => '2.0',
            'min_unit'         => '2',
            'step_size'        => '2'
          }
        )
      end

      it 'configures resource providers' do
        should contain_neutron_agent_ovs('ovs/resource_provider_inventory_defaults').\
          with_value('allocation_ratio:1.0,min_unit:1,step_size:1')
        should contain_neutron_agent_ovs('ovs/resource_provider_packet_processing_inventory_defaults').\
          with_value('allocation_ratio:2.0,min_unit:2,step_size:2')
      end
    end
  end

  shared_examples 'neutron::agents::ml2::ovs on Debian' do
    # placeholder for debian specific tests
  end

  shared_examples 'neutron::agents::ml2::ovs on RedHat' do
    it 'configures neutron ovs cleanup service' do
      should contain_service('ovs-cleanup-service').with(
        :name    => platform_params[:ovs_cleanup_service],
        :enable  => true,
        :ensure  => nil,
        :require => 'Anchor[neutron::service::begin]',
        :before  => 'Anchor[neutron::service::end]',
      )
    end

    it 'configures neutron destroy patch ports service' do
      should contain_service('neutron-destroy-patch-ports-service').with(
        :name    => platform_params[:destroy_patch_ports_service],
        :enable  => true,
        :ensure  => nil,
        :require => 'Anchor[neutron::service::begin]',
        :before  => 'Anchor[neutron::service::end]',
      )
    end

    context 'when enabling dpdk with manage vswitch is default' do
      let :pre_condition do
        "class { 'vswitch::dpdk': host_core_list => '1,2', memory_channels => '1' }"
      end
      before :each do
        params.merge!(:enable_dpdk => true,
                      :datapath_type => 'netdev',
                      :vhostuser_socket_dir => '/var/run/openvswitch')
      end

      it 'should require vswitch::dpdk' do
        should contain_class('vswitch::dpdk')
      end
    end

    context 'with mac table size on an ovs bridge set' do
      before :each do
        params.merge!(:bridge_mac_table_size => 50000)
      end

      it 'configure neutron/plugins/ml2/ml2_conf.ini' do
        should contain_neutron_agent_ovs('ovs/bridge_mac_table_size').with_value(50000)
      end
    end

    context 'with IGMP snooping enabled' do
      before :each do
        params.merge!(:igmp_snooping_enable => true)
      end

      it 'configure neutron/plugins/ml2/ml2_conf.ini' do
        should contain_neutron_agent_ovs('ovs/igmp_snooping_enable').with_value(true)
      end
    end

    context 'with direct output enabled for egress flows' do
      before :each do
        params.merge!(:explicitly_egress_direct => true)
      end

      it 'configure neutron/plugins/ml2/ml2_conf.ini' do
        should contain_neutron_agent_ovs('agent/explicitly_egress_direct').with_value(true)
      end
    end

  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      let (:platform_params) do
        case facts[:os]['family']
        when 'Debian'
          { :ovs_agent_package => 'neutron-openvswitch-agent',
            :ovs_agent_service => 'neutron-openvswitch-agent' }
        when 'RedHat'
          { :ovs_agent_package           => 'openstack-neutron-openvswitch',
            :ovs_cleanup_service         => 'neutron-ovs-cleanup',
            :ovs_agent_service           => 'neutron-openvswitch-agent',
            :destroy_patch_ports_service => 'neutron-destroy-patch-ports' }
        end
      end

      it_behaves_like 'neutron plugin ovs agent with ml2 plugin'
      it_behaves_like "neutron::agents::ml2::ovs on #{facts[:os]['family']}"
    end
  end
end
