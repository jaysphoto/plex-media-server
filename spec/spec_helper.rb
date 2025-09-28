require 'rspec-puppet'
require 'rspec-puppet-utils'

require 'webmock/rspec'

fixture_path = File.expand_path(File.join(__FILE__, '..', 'fixtures'))

RSpec.configure do |config|
  config.module_path = File.join(fixture_path, 'modules')
  config.before(:each) do
    stub_request(:get, /plex.tv/)
       .with(headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby'})
       .to_return(
         status: 301,
         headers: {
           location: 'https://plex.tv/downloads/plexmediaserver_latest_version-hash_amd64.deb'
         })
  end
end
