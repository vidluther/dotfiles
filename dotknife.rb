# See https://docs.chef.io/config_rb_knife.html for more information on knife configuration options

current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "vidluther"
client_key               "#{current_dir}/vidluther.pem"
validation_client_name   "pressable-validator"
validation_key           "#{current_dir}/pressable-validator.pem"
chef_server_url          "https://api.opscode.com/organizations/#{ENV['CHEF_ORG']}"
cache_type               'BasicFile'
cache_options( :path => "#{ENV['HOME']}/.chef/checksums" )
cookbook_path            ["#{current_dir}/../cookbooks"]


knife[:rackspace_api_username] = "#{ENV['RACKSPACE_USERNAME']}"
knife[:rackspace_api_key] = "#{ENV['RACKSPACE_API_KEY']}"
knife[:rackspace_region] = "#{ENV['RACKSPACE_REGION']}"
knife[:rackspace_version] = 'v2'


knife[:aws_access_key_id] = "AKIAJGBQOEMJFHTL4BRQ"
knife[:aws_secret_access_key] = "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"
