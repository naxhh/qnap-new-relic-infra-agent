# New Relic Infra Agent Qpackage

This is a qpackage of the NR Infrastructure agent.

## Installation

Download the `qpkg` file from the [releases](https://github.com/naxhh/qnap-new-relic-infra-agent/releases) tab.
The version matches the NR agent versioning.

After installation you need to modify the configuration file `NewRelicInfraAgent.conf` to add your license.
And restart the agent using `sudo NR-Infra-Agent.sh restart`

You can find the root of those files using:
```
cd `/sbin/getcfg NR-Infra-Agent Install_Path -f /etc/config/qpkg.conf`
```

To get a license key go to [New Relic](http://newrelic.com/), click on the user menu. Go to `Add more data`.
Select `Operating System > Ubuntu` and it should give your license.

## Devices tested on

- QNAP TS-251


## Building the package manually

Clone the repo inside the qnap and run `qbuild` and grab the `.qpkg` file from the `build` folder

It requires having `QDK` installed.

## Future improvements

- Make it pick the logos correctly
- Make the license configurable via web interface
- Make it work with other architectures (no qnap's to test it on..)
- Automate agent updates (pre-release)