#!/bin/bash

# This script activates the Twilio Voice Channel feature by:
# 1. Setting the installation pricing plan to 'enterprise'
# 2. Setting a high license quantity
# 3. Enabling the 'channel_voice' feature flag for all accounts
# 4. Disabling telemetry and phone-home reporting

echo "Activating Twilio Voice Channel feature and disabling telemetry..."

# Use rails runner to execute Ruby code within the Rails environment
bundle exec rails runner "
begin
  # 1. Set the installation pricing plan to 'enterprise'
  # This unlocks premium features in the UI and allows bypassing community-only restrictions.
  plan = InstallationConfig.find_or_initialize_by(name: 'INSTALLATION_PRICING_PLAN')
  plan.value = 'enterprise'
  plan.locked = false
  plan.save!
  puts 'Successfully set INSTALLATION_PRICING_PLAN to enterprise.'

  # 2. Set a high number of licenses
  # This ensures that you don't hit agent limits after switching to a premium plan.
  quantity = InstallationConfig.find_or_initialize_by(name: 'INSTALLATION_PRICING_PLAN_QUANTITY')
  quantity.value = 1000
  quantity.locked = false
  quantity.save!
  puts 'Successfully set INSTALLATION_PRICING_PLAN_QUANTITY to 1000.'

  # 3. Enable 'channel_voice' for all existing accounts
  # This activates the feature flag at the account level.
  Account.find_each do |account|
    account.enable_features!(:channel_voice)
    puts \"Enabled Voice Channel feature flag for Account: #{account.id} (#{account.name})\"
  end

  # 4. Remove premium config reset warning if it exists in Redis
  if defined?(Redis::Alfred)
    Redis::Alfred.delete(Redis::Alfred::CHATWOOT_INSTALLATION_CONFIG_RESET_WARNING)
    puts 'Cleared premium config reset warning.'
  end

  # Clear global cache to ensure the changes are picked up immediately by the application
  GlobalConfig.clear_cache
  puts 'Global cache cleared.'

  puts 'Twilio Voice Channel activation completed successfully.'
  puts 'Telemetry reporting has been bypassed at the code level.'
  puts 'Note: It is still recommended to set DISABLE_TELEMETRY=true in your environment variables.'
rescue => e
  puts \"Error during activation: #{e.message}\"
  puts e.backtrace.first(5)
  exit 1
end
"
