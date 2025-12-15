require 'spec_helper'
require 'rspec-puppet-utils'

describe 'plexmediaserver', type: :class do
  let(:plex_latest_pkg) { 'plexmediaserver_1.42.2.10156-f737b826c_amd64.deb' }
  let :pre_condition do
    [
      'define staging::deploy ( $source = nil, $target = nil ) {}',
      'define staging::file ( $source = nil, $target = nil ) {}',
      "function latest_version( String \$distro ) { { 'url' => 'uri_split[0]', 'pkg' => '#{plex_latest_pkg}' } }",
    ]
  end

  context 'on all operating systems' do
    let(:facts) do
      {
        os: {
          name: 'CentOS',
          family: 'Redhat',
          architecture: 'x86_64'
        }
      }
    end

    it { is_expected.to contain_class('plexmediaserver') }
    it { is_expected.to contain_file('plexconfig') }
    it { is_expected.to contain_service('plexmediaserver').with('ensure' => 'running') }
  end

  context 'without custom parameters' do
    let(:facts) do
      {
        os: {
          name: 'CentOS',
          family: 'Redhat',
          architecture: 'x86_64'
        }
      }
    end

    it { is_expected.to contain_file('plexconfig').with_content %r{^PLEX_USER=plex$} }
    it { is_expected.to contain_file('plexconfig').with_content %r{^PLEX_MEDIA_SERVER_HOME=/usr/lib/plexmediaserver$} }
  end

  context 'with custom parameters' do
    let :facts do
      {
        os: {
          name: 'CentOS',
          family: 'Redhat',
          architecture: 'x86_64'
        }
      }
    end
    let :params do
      {
        plex_media_server_max_plugin_procs: '7',
        plex_media_server_max_stack_size: '20000'
      }
    end

    it { is_expected.to contain_file('plexconfig').with_content %r{^PLEX_MEDIA_SERVER_MAX_PLUGIN_PROCS=7$} }
    it { is_expected.to contain_file('plexconfig').with_content %r{^PLEX_MEDIA_SERVER_MAX_STACK_SIZE=20000$} }
  end

  context 'on a CentOS 32-bit system' do
    let :facts do
      {
        os: {
          name: 'CentOS',
          family: 'Redhat',
          architecture: 'i386'
        }
      }
    end

    it { is_expected.to contain_staging__file('plexmediaserver-0.9.12.19.1537-f38ac80.i386.rpm') }
  end

  context 'on a CentOS 64-bit system' do
    let :facts do
      {
        os: {
          name: 'CentOS',
          family: 'Redhat',
          architecture: 'x86_64'
        }
      }
    end

    it { is_expected.to contain_staging__file('plexmediaserver-0.9.12.19.1537-f38ac80.x86_64.rpm') }
  end

  context 'on a Darwin system' do
    let :facts do
      {
        os: {
          name: 'Darwin',
          family: 'OSX',
          architecture: 'x86_64'
        }
      }
    end

    it { is_expected.to contain_staging__deploy('PlexMediaServer-0.9.12.19.1537-f38ac80-OSX.zip') }
  end

  context 'on a Ubuntu 32-bit system' do
    let :facts do
      {
        os: {
          name: 'Ubuntu',
          family: 'Debian',
          architecture: 'i386',
        }
      }
    end

    it { is_expected.to contain_staging__file('plexmediaserver_0.9.12.19.1537-f38ac80_i386.deb') }
  end

  context 'on a Ubuntu 64-bit system' do
    let :facts do
      {
        os: {
          name: 'Ubuntu',
          family: 'Debian',
          architecture: 'amd64',
        }
      }
    end

    it { is_expected.to contain_staging__file('plexmediaserver_0.9.12.19.1537-f38ac80_amd64.deb') }
  end

  context 'latest version on a Ubuntu 64-bit system' do
    let :facts do
      {
        os: {
          name: 'Ubuntu',
          family: 'Debian',
          architecture: 'amd64',
        }
      }
    end
    let :params do
      {
        plex_install_latest: true
      }
    end

    it { is_expected.to contain_staging__file(plex_latest_pkg) }
  end
end
