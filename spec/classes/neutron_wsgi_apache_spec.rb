require 'spec_helper'

describe 'neutron::wsgi::apache' do
  shared_examples 'apache serving neutron with mod_wsgi' do
    context 'with default parameters' do
      it { should contain_class('neutron::params') }
      it { should contain_openstacklib__wsgi__apache('neutron_wsgi').with(
        :bind_port                   => 9696,
        :group                       => 'neutron',
        :path                        => '/',
        :priority                    => 10,
        :servername                  => facts[:fqdn],
        :ssl                         => false,
        :threads                     => 1,
        :user                        => 'neutron',
        :workers                     => facts[:os_workers],
        :wsgi_daemon_process         => 'neutron',
        :wsgi_process_group          => 'neutron',
        :wsgi_script_dir             => platform_params[:wsgi_script_path],
        :wsgi_script_file            => 'app',
        :wsgi_script_source          => platform_params[:wsgi_script_source],
        :custom_wsgi_process_options => {},
        :headers                     => nil,
        :request_headers             => nil,
        :access_log_file             => nil,
        :access_log_format           => nil,
      )}
    end

    context 'when overriding parameters' do
      let :params do
        {
          :servername                => 'dummy.host',
          :bind_host                 => '10.42.51.1',
          :port                      => 12345,
          :ssl                       => true,
          :wsgi_process_display_name => 'neutron',
          :workers                   => 37,
          :custom_wsgi_process_options => {
            'python_path' => '/my/python/path',
          },
          :headers                   => ['set X-XSS-Protection "1; mode=block"'],
          :request_headers           => ['set Content-Type "application/json"'],
          :access_log_file           => '/var/log/httpd/access_log',
          :access_log_format         => 'some format',
          :error_log_file            => '/var/log/httpd/error_log'
        }
      end
      it { should contain_class('neutron::params') }
      it { should contain_openstacklib__wsgi__apache('neutron_wsgi').with(
        :bind_host                   => '10.42.51.1',
        :bind_port                   => 12345,
        :group                       => 'neutron',
        :path                        => '/',
        :servername                  => 'dummy.host',
        :ssl                         => true,
        :threads                     => 1,
        :user                        => 'neutron',
        :workers                     => 37,
        :wsgi_daemon_process         => 'neutron',
        :wsgi_process_display_name   => 'neutron',
        :wsgi_process_group          => 'neutron',
        :wsgi_script_dir             => platform_params[:wsgi_script_path],
        :wsgi_script_file            => 'app',
        :wsgi_script_source          => platform_params[:wsgi_script_source],
        :headers                     => ['set X-XSS-Protection "1; mode=block"'],
        :request_headers             => ['set Content-Type "application/json"'],
        :custom_wsgi_process_options => {
          'python_path' => '/my/python/path',
        },
        :access_log_file             => '/var/log/httpd/access_log',
        :access_log_format           => 'some format',
        :error_log_file              => '/var/log/httpd/error_log'
      )}
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts({
          :os_workers     => 8,
          :concat_basedir => '/var/lib/puppet/concat',
          :fqdn           => 'some.host.tld'
        }))
      end

      let(:platform_params) do
        case facts[:osfamily]
        when 'Debian'
          {
            :httpd_service_name => 'apache2',
            :httpd_ports_file   => '/etc/apache2/ports.conf',
            :wsgi_script_path   => '/usr/lib/cgi-bin/neutron',
            :wsgi_script_source => '/usr/bin/neutron-api'
          }
        when 'RedHat'
          {
            :httpd_service_name => 'httpd',
            :httpd_ports_file   => '/etc/httpd/conf/ports.conf',
            :wsgi_script_path   => '/var/www/cgi-bin/neutron',
            :wsgi_script_source => '/usr/bin/neutron-api'
          }

        end
      end
      it_behaves_like 'apache serving neutron with mod_wsgi'
    end
  end
end
