# == Class: neutron
#
# Installs the neutron package and configures
# /etc/neutron/neutron.conf
#
# === Parameters:
#
# [*package_ensure*]
#   (optional) The state of the package
#   Defaults to 'present'
#
# [*bind_host*]
#   (optional) The IP/interface to bind to
#   Defaults to $facts['os_service_default']
#
# [*bind_port*]
#   (optional) The port to use
#   Defaults to $facts['os_service_default']
#
# [*core_plugin*]
#   (optional) Neutron plugin provider
#   Defaults to ml2
#
# [*service_plugins*]
#   (optional) Advanced service modules.
#   Could be an array that can have these elements:
#   router, firewall, vpnaas, metering, qos
#   Defaults to $facts['os_service_default']
#
# [*auth_strategy*]
#   (optional) How to authenticate
#   Defaults to 'keystone'. 'noauth' and 'keystone' are the only valid options
#
# [*base_mac*]
#   (optional) The MAC address pattern to use.
#   Defaults to $facts['os_service_default']
#
# [*dhcp_lease_duration*]
#   (optional) DHCP lease
#   Defaults to $facts['os_service_default']
#
# [*host*]
#   (optional) Hostname to be used by the server, agents and services.
#   Defaults to $facts['os_service_default']
#
# [*dns_domain*]
#   (optional) Domain to use for building the hostnames
#   Defaults to $facts['os_service_default']
#
# [*dhcp_agents_per_network*]
#   (optional) Number of DHCP agents scheduled to host a network.
#   This enables redundant DHCP agents for configured networks.
#   Defaults to $facts['os_service_default']
#
# [*global_physnet_mtu*]
#   (optional) The MTU size for the interfaces managed by neutron
#   Defaults to $facts['os_service_default']
#
# [*dhcp_agent_notification*]
#   (optional) Allow sending resource operation notification to DHCP agent.
#   Defaults to $facts['os_service_default']
#
# [*allow_bulk*]
#   (optional) Enable bulk crud operations
#   Defaults to $facts['os_service_default']
#
# [*api_extensions_path*]
#   (optional) Specify additional paths for API extensions that the
#   module in use needs to load.
#   Defaults to $facts['os_service_default']
#
# [*root_helper*]
#  (optional) Use "sudo neutron-rootwrap /etc/neutron/rootwrap.conf" to use the real
#  root filter facility. Change to "sudo" to skip the filtering and just run the command
#  directly
#  Defaults to 'sudo neutron-rootwrap /etc/neutron/rootwrap.conf'.
#
# [*root_helper_daemon*]
#  (optional) Root helper daemon application to use when possible.
#  Defaults to $facts['os_service_default'].
#
# [*report_interval*]
#   (optional) Seconds between nodes reporting state to server; should be less than
#   agent_down_time, best if it is half or less than agent_down_time.
#   agent_down_time is a config for neutron-server, set by class neutron::server
#   report_interval is a config for neutron agents, set by class neutron
#   Defaults to: $facts['os_service_default']
#
# [*control_exchange*]
#   (optional) What RPC queue/exchange to use
#   Defaults to $facts['os_service_default']
#
# [*executor_thread_pool_size*]
#   (optional) Size of executor thread pool when executor is threading or eventlet.
#   Defaults to $facts['os_service_default'].
#
# [*default_transport_url*]
#    (optional) A URL representing the messaging driver to use and its full
#    configuration. Transport URLs take the form:
#      transport://user:pass@host1:port[,hostN:portN]/virtual_host
#    Defaults to $facts['os_service_default']
#
# [*rpc_response_timeout*]
#   (optional) Seconds to wait for a response from a call
#   Defaults to $facts['os_service_default']
#
# [*rabbit_ha_queues*]
#   (Optional) Use HA queues in RabbitMQ.
#   Defaults to $facts['os_service_default']
#
# [*rabbit_heartbeat_timeout_threshold*]
#   (optional) Number of seconds after which the RabbitMQ broker is considered
#   down if the heartbeat keepalive fails.  Any value >0 enables heartbeats.
#   Heartbeating helps to ensure the TCP connection to RabbitMQ isn't silently
#   closed, resulting in missed or lost messages from the queue.
#   (Requires kombu >= 3.0.7 and amqp >= 1.4.0)
#   Defaults to $facts['os_service_default']
#
# [*rabbit_heartbeat_rate*]
#   (optional) How often during the rabbit_heartbeat_timeout_threshold period to
#   check the heartbeat on RabbitMQ connection.  (i.e. rabbit_heartbeat_rate=2
#   when rabbit_heartbeat_timeout_threshold=60, the heartbeat will be checked
#   every 30 seconds.
#   Defaults to $facts['os_service_default']
#
# [*rabbit_heartbeat_in_pthread*]
#   (Optional) EXPERIMENTAL: Run the health check heartbeat thread
#   through a native python thread. By default if this
#   option isn't provided the  health check heartbeat will
#   inherit the execution model from the parent process. By
#   example if the parent process have monkey patched the
#   stdlib by using eventlet/greenlet then the heartbeat
#   will be run through a green thread.
#   Defaults to $facts['os_service_default']
#
# [*rabbit_quorum_queue*]
#   (Optional) Use quorum queues in RabbitMQ.
#   Defaults to $facts['os_service_default']
#
# [*rabbit_quorum_delivery_limit*]
#   (Optional) Each time a message is rdelivered to a consumer, a counter is
#   incremented. Once the redelivery count exceeds the delivery limit
#   the message gets dropped or dead-lettered.
#   Defaults to $facts['os_service_default']
#
# [*rabbit_quorum_max_memory_length*]
#   (Optional) Limit the number of messages in the quorum queue.
#   Defaults to $facts['os_service_default']
#
# [*rabbit_quorum_max_memory_bytes*]
#   (Optional) Limit the number of memory bytes used by the quorum queue.
#   Defaults to $facts['os_service_default']
#
# [*rabbit_use_ssl*]
#   (optional) Connect over SSL for RabbitMQ
#   Defaults to $facts['os_service_default']
#
# [*rabbit_transient_queues_ttl*]
#   (optional) Positive integer representing duration in seconds for queue
#   TTL (x-expires). Queues which are unused for the duration of the TTL are
#   automatically deleted. The parameter affects only reply and fanout queues.
#   Defaults to $facts['os_service_default']
#
# [*amqp_durable_queues*]
#   (optional) Define queues as "durable" to rabbitmq.
#   Defaults to $facts['os_service_default']
#
# [*kombu_ssl_ca_certs*]
#   (optional) SSL certification authority file (valid only if SSL enabled).
#   Defaults to $facts['os_service_default']
#
# [*kombu_ssl_certfile*]
#   (optional) SSL cert file (valid only if SSL enabled).
#   Defaults to $facts['os_service_default']
#
# [*kombu_ssl_keyfile*]
#   (optional) SSL key file (valid only if SSL enabled).
#   Defaults to $facts['os_service_default']
#
# [*kombu_ssl_version*]
#   (optional) SSL version to use (valid only if SSL enabled).
#   Valid values are TLSv1, SSLv23 and SSLv3. SSLv2 may be
#   available on some distributions.
#   Defaults to $facts['os_service_default']
#
# [*kombu_reconnect_delay*]
#   (optional) The amount of time to wait before attempting to reconnect
#   to MQ provider. This is used in some cases where you may need to wait
#   for the provider to properly promote the master before attempting to
#   reconnect. See https://review.opendev.org/#/c/76686
#   Defaults to $facts['os_service_default']
#
# [*kombu_missing_consumer_retry_timeout*]
#   (Optional) How long to wait a missing client before abandoning to send it
#   its replies. This value should not be longer than rpc_response_timeout.
#   (integer value)
#   Defaults to $facts['os_service_default']
#
# [*kombu_failover_strategy*]
#   (Optional) Determines how the next RabbitMQ node is chosen in case the one
#   we are currently connected to becomes unavailable. Takes effect only if
#   more than one RabbitMQ node is provided in config. (string value)
#   Defaults to $facts['os_service_default']
#
# [*kombu_compression*]
#   (optional) Possible values are: gzip, bz2. If not set compression will not
#   be used. This option may not be available in future versions. EXPERIMENTAL.
#   (string value)
#   Defaults to $facts['os_service_default']
#
# [*amqp_server_request_prefix*]
#   (Optional) Address prefix used when sending to a specific server
#   Defaults to $facts['os_service_default'].
#
# [*amqp_broadcast_prefix*]
#   (Optional) address prefix used when broadcasting to all servers
#   Defaults to $facts['os_service_default'].
#
# [*amqp_group_request_prefix*]
#   (Optional) address prefix when sending to any server in group
#   Defaults to $facts['os_service_default'].
#
# [*amqp_container_name*]
#   (Optional) Name for the AMQP container
#   Defaults to $facts['os_service_default'].
#
# [*amqp_idle_timeout*]
#   (Optional) Timeout for inactive connections
#   Defaults to $facts['os_service_default'].
#
# [*amqp_trace*]
#   (Optional) Debug: dump AMQP frames to stdout
#   Defaults to $facts['os_service_default'].
#
# [*amqp_ssl_ca_file*]
#   (Optional) CA certificate PEM file to verify server certificate
#   Defaults to $facts['os_service_default'].
#
# [*amqp_ssl_cert_file*]
#   (Optional) Identifying certificate PEM file to present to clients
#   Defaults to $facts['os_service_default'].
#
# [*amqp_ssl_key_file*]
#   (Optional) Private key PEM file used to sign cert_file certificate
#   Defaults to $facts['os_service_default'].
#
# [*amqp_ssl_key_password*]
#   (Optional) Password for decrypting ssl_key_file (if encrypted)
#   Defaults to $facts['os_service_default'].
#
# [*amqp_sasl_mechanisms*]
#   (Optional) Space separated list of acceptable SASL mechanisms
#   Defaults to $facts['os_service_default'].
#
# [*amqp_sasl_config_dir*]
#   (Optional) Path to directory that contains the SASL configuration
#   Defaults to $facts['os_service_default'].
#
# [*amqp_sasl_config_name*]
#   (Optional) Name of configuration file (without .conf suffix)
#   Defaults to $facts['os_service_default'].
#
# [*amqp_username*]
#   (Optional) User name for message broker authentication
#   Defaults to $facts['os_service_default'].
#
# [*amqp_password*]
#   (Optional) Password for message broker authentication
#   Defaults to $facts['os_service_default'].
#
# [*use_ssl*]
#   (optional) Enable SSL on the API server
#   Defaults to $facts['os_service_default']
#
# [*cert_file*]
#   (optional) certificate file to use when starting api server securely
#   defaults to $facts['os_service_default']
#
# [*key_file*]
#   (optional) Private key file to use when starting API server securely
#   Defaults to $facts['os_service_default']
#
# [*ca_file*]
#   (optional) CA certificate file to use to verify connecting clients
#   Defaults to $facts['os_service_default']
#
# [*state_path*]
#   (optional) Where to store state files. This directory must be writable
#   by the user executing the agent
#   Defaults to: $facts['os_service_default']
#
# [*lock_path*]
#   (optional) Where to store lock files. This directory must be writeable
#   by the user executing the agent
#   Defaults to: '$state_path/lock'
#
# [*purge_config*]
#   (optional) Whether to set only the specified config options
#   in the neutron config.
#   Defaults to false.
#
# [*notification_driver*]
#   (optional) Driver or drivers to handle sending notifications.
#   Value can be a string or a list.
#   Defaults to $facts['os_service_default'].
#
# [*notification_topics*]
#   (optional) AMQP topic used for OpenStack notifications
#   Defaults to facts['os_service_default']
#
# [*notification_transport_url*]
#   (optional) A URL representing the messaging driver to use for
#   notifications and its full configuration. Transport URLs
#   take the form:
#      transport://user:pass@host1:port[,hostN:portN]/virtual_host
#   Defaults to $facts['os_service_default'].
#
# [*max_allowed_address_pair*]
#   (optional) Maximum number of allowed address pairs per port
#   Defaults to $facts['os_service_default'].
#
# [*vlan_transparent*]
#   (optional) Allow plugins that support it to create VLAN transparent networks
#   Defaults to $facts['os_service_default']
#
class neutron (
  $package_ensure                       = 'present',
  $bind_host                            = $facts['os_service_default'],
  $bind_port                            = $facts['os_service_default'],
  $core_plugin                          = 'ml2',
  $service_plugins                      = $facts['os_service_default'],
  $auth_strategy                        = 'keystone',
  $base_mac                             = $facts['os_service_default'],
  $dhcp_lease_duration                  = $facts['os_service_default'],
  $host                                 = $facts['os_service_default'],
  $dns_domain                           = $facts['os_service_default'],
  $dhcp_agents_per_network              = $facts['os_service_default'],
  $global_physnet_mtu                   = $facts['os_service_default'],
  $dhcp_agent_notification              = $facts['os_service_default'],
  $allow_bulk                           = $facts['os_service_default'],
  $api_extensions_path                  = $facts['os_service_default'],
  $root_helper                          = 'sudo neutron-rootwrap /etc/neutron/rootwrap.conf',
  $root_helper_daemon                   = $facts['os_service_default'],
  $report_interval                      = $facts['os_service_default'],
  $control_exchange                     = $facts['os_service_default'],
  $executor_thread_pool_size            = $facts['os_service_default'],
  $default_transport_url                = $facts['os_service_default'],
  $rpc_response_timeout                 = $facts['os_service_default'],
  $rabbit_ha_queues                     = $facts['os_service_default'],
  $rabbit_heartbeat_timeout_threshold   = $facts['os_service_default'],
  $rabbit_heartbeat_rate                = $facts['os_service_default'],
  $rabbit_heartbeat_in_pthread          = $facts['os_service_default'],
  $rabbit_quorum_queue                  = $facts['os_service_default'],
  $rabbit_quorum_delivery_limit         = $facts['os_service_default'],
  $rabbit_quorum_max_memory_length      = $facts['os_service_default'],
  $rabbit_quorum_max_memory_bytes       = $facts['os_service_default'],
  $rabbit_use_ssl                       = $facts['os_service_default'],
  $rabbit_transient_queues_ttl          = $facts['os_service_default'],
  $amqp_durable_queues                  = $facts['os_service_default'],
  $kombu_ssl_ca_certs                   = $facts['os_service_default'],
  $kombu_ssl_certfile                   = $facts['os_service_default'],
  $kombu_ssl_keyfile                    = $facts['os_service_default'],
  $kombu_ssl_version                    = $facts['os_service_default'],
  $kombu_reconnect_delay                = $facts['os_service_default'],
  $kombu_missing_consumer_retry_timeout = $facts['os_service_default'],
  $kombu_failover_strategy              = $facts['os_service_default'],
  $kombu_compression                    = $facts['os_service_default'],
  $amqp_server_request_prefix           = $facts['os_service_default'],
  $amqp_broadcast_prefix                = $facts['os_service_default'],
  $amqp_group_request_prefix            = $facts['os_service_default'],
  $amqp_container_name                  = $facts['os_service_default'],
  $amqp_idle_timeout                    = $facts['os_service_default'],
  $amqp_trace                           = $facts['os_service_default'],
  $amqp_ssl_ca_file                     = $facts['os_service_default'],
  $amqp_ssl_cert_file                   = $facts['os_service_default'],
  $amqp_ssl_key_file                    = $facts['os_service_default'],
  $amqp_ssl_key_password                = $facts['os_service_default'],
  $amqp_sasl_mechanisms                 = $facts['os_service_default'],
  $amqp_sasl_config_dir                 = $facts['os_service_default'],
  $amqp_sasl_config_name                = $facts['os_service_default'],
  $amqp_username                        = $facts['os_service_default'],
  $amqp_password                        = $facts['os_service_default'],
  $use_ssl                              = $facts['os_service_default'],
  $cert_file                            = $facts['os_service_default'],
  $key_file                             = $facts['os_service_default'],
  $ca_file                              = $facts['os_service_default'],
  $state_path                           = $facts['os_service_default'],
  $lock_path                            = '$state_path/lock',
  Boolean $purge_config                 = false,
  $notification_driver                  = $facts['os_service_default'],
  $notification_topics                  = $facts['os_service_default'],
  $notification_transport_url           = $facts['os_service_default'],
  $max_allowed_address_pair             = $facts['os_service_default'],
  $vlan_transparent                     = $facts['os_service_default'],
) {

  include neutron::deps
  include neutron::params

  if ! is_service_default($use_ssl) and ($use_ssl) {
    if is_service_default($cert_file) {
      fail('The cert_file parameter is required when use_ssl is set to true')
    }
    if is_service_default($key_file) {
      fail('The key_file parameter is required when use_ssl is set to true')
    }
  }

  if ! is_service_default($use_ssl) and !($use_ssl) {
    if ! is_service_default($ca_file) and ($ca_file) {
      fail('The ca_file parameter requires that use_ssl to be set to true')
    }
  }

  package { 'neutron':
    ensure => $package_ensure,
    name   => $::neutron::params::package_name,
    tag    => ['openstack', 'neutron-package'],
  }

  resources { 'neutron_config':
    purge => $purge_config,
  }

  neutron_config {
    'DEFAULT/bind_host':                value => $bind_host;
    'DEFAULT/bind_port':                value => $bind_port;
    'DEFAULT/auth_strategy':            value => $auth_strategy;
    'DEFAULT/core_plugin':              value => $core_plugin;
    'DEFAULT/base_mac':                 value => $base_mac;
    'DEFAULT/dhcp_lease_duration':      value => $dhcp_lease_duration;
    'DEFAULT/host':                     value => $host;
    'DEFAULT/dns_domain':               value => $dns_domain;
    'DEFAULT/dhcp_agents_per_network':  value => $dhcp_agents_per_network;
    'DEFAULT/dhcp_agent_notification':  value => $dhcp_agent_notification;
    'DEFAULT/allow_bulk':               value => $allow_bulk;
    'DEFAULT/api_extensions_path':      value => $api_extensions_path;
    'DEFAULT/state_path':               value => $state_path;
    'DEFAULT/global_physnet_mtu':       value => $global_physnet_mtu;
    'DEFAULT/max_allowed_address_pair': value => $max_allowed_address_pair;
    'DEFAULT/vlan_transparent':         value => $vlan_transparent;
    'agent/root_helper':                value => $root_helper;
    'agent/root_helper_daemon':         value => $root_helper_daemon;
    'agent/report_interval':            value => $report_interval;
  }

  oslo::messaging::default { 'neutron_config':
    executor_thread_pool_size => $executor_thread_pool_size,
    transport_url             => $default_transport_url,
    rpc_response_timeout      => $rpc_response_timeout,
    control_exchange          => $control_exchange,
  }

  oslo::concurrency { 'neutron_config': lock_path => $lock_path }

  oslo::messaging::notifications { 'neutron_config':
    driver        => $notification_driver,
    topics        => $notification_topics,
    transport_url => $notification_transport_url,
  }

  neutron_config {
    'DEFAULT/service_plugins': value => join(any2array($service_plugins), ',')
  }

  oslo::messaging::rabbit {'neutron_config':
    heartbeat_timeout_threshold          => $rabbit_heartbeat_timeout_threshold,
    heartbeat_rate                       => $rabbit_heartbeat_rate,
    heartbeat_in_pthread                 => $rabbit_heartbeat_in_pthread,
    rabbit_use_ssl                       => $rabbit_use_ssl,
    rabbit_transient_queues_ttl          => $rabbit_transient_queues_ttl,
    kombu_reconnect_delay                => $kombu_reconnect_delay,
    kombu_missing_consumer_retry_timeout => $kombu_missing_consumer_retry_timeout,
    kombu_failover_strategy              => $kombu_failover_strategy,
    kombu_compression                    => $kombu_compression,
    kombu_ssl_ca_certs                   => $kombu_ssl_ca_certs,
    kombu_ssl_certfile                   => $kombu_ssl_certfile,
    kombu_ssl_keyfile                    => $kombu_ssl_keyfile,
    amqp_durable_queues                  => $amqp_durable_queues,
    rabbit_ha_queues                     => $rabbit_ha_queues,
    kombu_ssl_version                    => $kombu_ssl_version,
    rabbit_quorum_queue                  => $rabbit_quorum_queue,
    rabbit_quorum_delivery_limit         => $rabbit_quorum_delivery_limit,
    rabbit_quorum_max_memory_length      => $rabbit_quorum_max_memory_length,
    rabbit_quorum_max_memory_bytes       => $rabbit_quorum_max_memory_bytes,
  }

  oslo::messaging::amqp { 'neutron_config':
    server_request_prefix => $amqp_server_request_prefix,
    broadcast_prefix      => $amqp_broadcast_prefix,
    group_request_prefix  => $amqp_group_request_prefix,
    container_name        => $amqp_container_name,
    idle_timeout          => $amqp_idle_timeout,
    trace                 => $amqp_trace,
    ssl_ca_file           => $amqp_ssl_ca_file,
    ssl_cert_file         => $amqp_ssl_cert_file,
    ssl_key_file          => $amqp_ssl_key_file,
    ssl_key_password      => $amqp_ssl_key_password,
    sasl_mechanisms       => $amqp_sasl_mechanisms,
    sasl_config_dir       => $amqp_sasl_config_dir,
    sasl_config_name      => $amqp_sasl_config_name,
    username              => $amqp_username,
    password              => $amqp_password,
  }

  # SSL Options
  neutron_config {
    'DEFAULT/use_ssl': value => $use_ssl;
    'ssl/cert_file':   value => $cert_file;
    'ssl/key_file':    value => $key_file;
    'ssl/ca_file':     value => $ca_file;
  }

}
