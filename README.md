# Miteru

[![Gem Version](https://badge.fury.io/rb/miteru.svg)](https://badge.fury.io/rb/miteru)
[![Ruby CI](https://github.com/ninoseki/miteru/actions/workflows/test.yml/badge.svg)](https://github.com/ninoseki/miteru/actions/workflows/test.yml)
[![CodeFactor](https://www.codefactor.io/repository/github/ninoseki/miteru/badge)](https://www.codefactor.io/repository/github/ninoseki/miteru)
[![Coverage Status](https://coveralls.io/repos/github/ninoseki/miteru/badge.svg?branch=master)](https://coveralls.io/github/ninoseki/miteru?branch=master)

A phishing kit collector for scavengers.

## Disclaimer

This tool is for research purposes only. The use of this tool is your responsibility.
I take no responsibility and/or liability for how you choose to use this tool.

## How It Works

- It collects phishy URLs from the following feeds:
  - urlscan.io's automatic submissions. (`task.method:automatic`)
  - urlscan.io phish feed. (available for Pro users)
  - [mitchellkrogza/Phishing.Database](https://github.com/mitchellkrogza/Phishing.Database)'s `phishing-links-ACTIVE-NOW.txt`.
  - [ninoseki/ayashige](https://github.com/ninoseki/ayashige) feed.
- It checks each phishy URL whether it enables directory listing and contains phishing kits (compressed files) or not.
  - Note: Supported compressed files are: `*.zip`, `*.rar`, `*.7z`, `*.tar` and `*.gz`.

## Docs

- [Requirements & Installation](https://github.com/ninoseki/miteru/wiki/Requirements-&-Installation)
- [Usage](https://github.com/ninoseki/miteru/wiki/Usage)
- [Configuration](https://github.com/ninoseki/miteru/wiki/Configuration)
- [Alternatives](https://github.com/ninoseki/miteru/wiki/Alternatives)
