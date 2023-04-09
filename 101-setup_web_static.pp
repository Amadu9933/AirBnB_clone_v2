# Install Nginx if not already installed
class nginx {
  package { 'nginx':
    ensure => installed,
  }
}

# Create necessary directories
class web_static {
  file { ['/data', '/data/web_static', '/data/web_static/releases', '/data/web_static/shared', '/data/web_static/releases/test']:
    ensure => 'directory',
    owner  => 'ubuntu',
    group  => 'ubuntu',
    mode   => '0755',
    recurse => true,
  }

  # Create a fake HTML file for testing Nginx configuration
  file { '/data/web_static/releases/test/index.html':
    ensure => 'file',
    content => '<html><body>Hello World!</body></html>',
    owner  => 'ubuntu',
    group  => 'ubuntu',
    mode   => '0644',
  }

  # Create a symbolic link to the test release
  file { '/data/web_static/current':
    ensure => 'link',
    target => '/data/web_static/releases/test',
    owner  => 'ubuntu',
    group  => 'ubuntu',
    mode   => '0755',
  }
}

# Update Nginx configuration
class nginx_config {
  file { '/etc/nginx/sites-available/default':
    ensure => 'file',
    content => template('nginx/default.erb'),
    notify => Service['nginx'],
  }
}

# Restart Nginx service
class nginx_service {
  service { 'nginx':
    ensure => running,
    enable => true,
    require => [Class['nginx'], Class['nginx_config']],
  }
}

# Apply the classes to the server
class {['nginx', 'web_static', 'nginx_config', 'nginx_service']:}

