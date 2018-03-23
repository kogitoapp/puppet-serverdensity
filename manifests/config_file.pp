# == Class: serverdensity_agent::config_file
#
# Defines the agent config file
#
# === Authors
#
# Server Density <hello@serverdensity.com>
#
# === Copyright
#
# Copyright 2014 Server Density
#

class serverdensity_agent::config_file (
  $api_token,
  $sd_account,
  $server_group,
  $use_fqdn,
  $provided_agent_key = $::sd_agent_key,
  $proxy_host = undef,
  $proxy_port = undef,
  $proxy_user = undef,
  $proxy_password = undef,
  $proxy_forbid_method_switch = undef,
  $server_name = undef,
  $plugin_directory = '',
  $log_level = undef,
  $collector_log_file = undef,
  $forwarder_log_file = undef,
  $log_to_syslog = undef,
  $syslog_host = undef,
  $syslog_port = undef,
  $use_sdstatsd = false,
  $statsd_fw_host = undef,
  $statsd_fw_port = undef,
  ) {
  $agent_key = agent_key(
    $api_token,
    $provided_agent_key,
    $server_name,
    $server_group,
    $use_fqdn )

  file { '/etc/sd-agent/conf.d':
    ensure => 'directory',
    mode   => '0755',
    notify => Class['serverdensity_agent::service'],
  }

  file { '/etc/sd-agent/config.cfg':
    ensure  => 'file',
    content => template('serverdensity_agent/config.cfg.erb'),
    mode    => '0644',
    notify  => Class['serverdensity_agent::service'],
  }

  # Legacy configurations for V1 plugins
  file { '/etc/sd-agent/plugins.d':
    ensure => 'directory',
    mode   => '0755',
    notify => Class['serverdensity_agent::service'],
  }

  # Write the agent key to a file so no api lookups are required
  file { '/var/run/sd-agent-key':
    ensure  => 'present',
    replace => 'no',
    content => $agent_key,
    mode    => '0644',
  }
}
