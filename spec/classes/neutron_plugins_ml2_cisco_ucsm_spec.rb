require 'spec_helper'

describe 'neutron::plugins::ml2::cisco::ucsm' do
  let :pre_condition do
    "class { 'neutron::keystone::authtoken':
      password => 'passw0rd',
     }
     class { 'neutron::server': }
     class { 'neutron':
      core_plugin     => 'ml2'
     }"
  end

  let :default_params do
    {
      :ucsm_ip            => '1.1.1.1',
      :ucsm_username      => 'admin',
      :ucsm_password      => 'password',
      :ucsm_host_list     => 'host1:profile1, host2:profile2',
      :supported_pci_devs => [ '2222:3333', '4444:5555' ],
      :ucsm_https_verify  => 'True',
      :sp_template_list   => 'SP_Template1_path:SP_Template1:S1,S2 SP_Template2_path:SP_Template2:S3,S4,S5',
      :vnic_template_list => 'physnet1:vnic_template_path1:vt1 physnet2:vnic_template_path2:vt2',
    }
  end

  let :params do
    {}
  end

  shared_examples 'neutron cisco ml2 ucsm plugin' do
    before do
      params.merge!(default_params)
    end

    it { should contain_class('neutron::params') }

    it do
      should contain_neutron_plugin_ml2('ml2_cisco_ucsm/ucsm_ip').with_value(params[:ucsm_ip])
      should contain_neutron_plugin_ml2('ml2_cisco_ucsm/ucsm_username').with_value(params[:ucsm_username])
      should contain_neutron_plugin_ml2('ml2_cisco_ucsm/ucsm_password').with_value(params[:ucsm_password]).with_secret(true)
      should contain_neutron_plugin_ml2('ml2_cisco_ucsm/ucsm_host_list').with_value(params[:ucsm_host_list])
      should contain_neutron_plugin_ml2('ml2_cisco_ucsm/supported_pci_devs').with_value(params[:supported_pci_devs])
      should contain_neutron_plugin_ml2('ml2_cisco_ucsm/sp_template_list').with_value(params[:sp_template_list])
      should contain_neutron_plugin_ml2('ml2_cisco_ucsm/vnic_template_list').with_value(params[:vnic_template_list])
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      if facts[:osfamily] == 'RedHat'
        it_behaves_like 'neutron cisco ml2 ucsm plugin'
      end
    end
  end
end
