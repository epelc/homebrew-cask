cask "datadog-agent" do
  version "7.50.0-1"
  sha256 "dea1b7a8e8af85923764e91ecc758393b49152d6274514a0befb3976aed29c11"

  url "https://s3.amazonaws.com/dd-agent/datadog-agent-#{version}.dmg",
      verified: "s3.amazonaws.com/dd-agent/"
  name "Datadog Agent"
  desc "Monitoring and security across systems, apps, and services"
  homepage "https://www.datadoghq.com/"

  livecheck do
    url "https://s3.amazonaws.com/dd-agent/"
    regex(%r{<Key>datadog-agent-([\d.-]+)\.dmg</Key>}i)
  end

  installer manual: "datadog-agent-#{version}.pkg"

  uninstall quit:      "com.datadoghq.agent",
            launchctl: "com.datadoghq.agent",
            pkgutil:   "com.datadoghq.agent",
            delete:    [
              "/Applications/Datadog Agent.app",
              "/usr/local/bin/datadog-agent",
            ]

  zap trash: [
    "~/.datadog-agent",
    "~/Library/LaunchAgents/com.datadoghq.agent.plist",
    "/opt/datadog-agent",
  ]

  caveats <<~EOS
    You will need to update /opt/datadog-agent/etc/datadog.yaml and replace
    APIKEY with your api key

    If you ever want to start/stop the Agent, please use the Datadog Agent App
    or datadog-agent command.
    It will start automatically at login, if you want to enable it at startup,
    run these commands:

      sudo cp '/opt/datadog-agent/etc/com.datadoghq.agent.plist.example' \
      /Library/LaunchDaemons/com.datadoghq.agent.plist

      sudo launchctl load -w /Library/LaunchDaemons/com.datadoghq.agent.plist
  EOS
end
