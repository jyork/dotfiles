# Function to search for deployed cookbooks in a Chef environment

function search_chef_env_and_show_deployed_cb_info()
{
  if [ -z "$1" ]; then
    echo Usage: You must pass the Chef Environment and a cookbook.
    echo Example: findnode int-dev-cert cme
    return
  fi
  local search="chef_environment:$1 AND deployed_cookbooks:$2"
  local attrs="-a chef_environment -a run_list -a ipaddress -a deployed_cookbooks.$2"

  # Default to Internal
  chef_config=~/.chef/knife.rb

  if [[ $1 == ext-* ]]; then
    chef_config=~/.chef/knife.external.rb
  fi

  echo knife search node $search $attr --config $chef_config
  knife search node "$search" --config $chef_config $attrs
}
alias findnode=search_chef_env_and_show_deployed_cb_info
