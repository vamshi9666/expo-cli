$LOAD_PATH.unshift File.expand_path(__dir__, __FILE__)

require 'funcs'
require 'spaceship'
require 'json'
# This provides the ask function which asks enduser for creds
require 'highline/import'

$appleId, $password = ARGV

json_reply = with_captured_stderr{
  begin
    account = Spaceship::Portal.login($appleId, $password)
    $stderr.puts (JSON.generate({result:'success', teams:account.teams}))
  rescue Spaceship::Client::InvalidUserCredentialsError => invalid_cred
    $stderr.puts (JSON.generate({
      result:'failure',
      reason:'Invalid credentials',
      rawDump:invalid_cred.message
    }))
  rescue Exception => e
    $stderr.puts (JSON.generate({
      result:'failure',
      reason:'Unknown reason',
      rawDump:e.message
    }))
  end
}

$stderr.puts json_reply
