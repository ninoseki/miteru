# Miteru

[![Gem Version](https://badge.fury.io/rb/miteru.svg)](https://badge.fury.io/rb/miteru)
[![Ruby CI](https://github.com/ninoseki/miteru/actions/workflows/test.yml/badge.svg)](https://github.com/ninoseki/miteru/actions/workflows/test.yml)
[![CodeFactor](https://www.codefactor.io/repository/github/ninoseki/miteru/badge)](https://www.codefactor.io/repository/github/ninoseki/miteru)
[![Coverage Status](https://coveralls.io/repos/github/ninoseki/miteru/badge.svg?branch=master)](https://coveralls.io/github/ninoseki/miteru?branch=master)

Miteru is an experimental phishing kit detection tool.

## Disclaimer

This tool is for research purposes only. The use of this tool is your responsibility.
I take no responsibility and/or liability for how you choose to use this tool.

## How it works

- It collects phishy URLs from the following feeds:
  - [CertStream-Suspicious feed via urlscan.io](https://urlscan.io/search/#task.source%3Acertstream-suspicious)
  - [OpenPhish feed via urlscan.io](https://urlscan.io/search/#task.source%3Aopenphish)
  - [PhishTank feed via urlscan.io](https://urlscan.io/search/#task.source%3Aphishtank)
  - [URLhaus feed via urlscan.io](https://urlscan.io/search/#task.source%3Aurlhaus)
  - urlscan.io phish feed (available for Pro users)
  - [Ayashige feed](https://github.com/ninoseki/ayashige)
  - [Phishing Database feed](https://github.com/mitchellkrogza/Phishing.Database)
  - [PhishStats feed](https://phishstats.info/)
- It checks each phishy URL whether it enables directory listing and contains a phishing kit (compressed file) or not.
  - Note: Supported compressed files are: `*.zip`, `*.rar`, `*.7z`, `*.tar` and `*.gz`.

## Features

- [x] Phishing kit detection & collection
- [x] Slack notification
- [x] Threading

## Docs

- [Requirements & Installation](https://github.com/ninoseki/miteru/wiki/Requirements-&-Installation)
- [Usage](https://github.com/ninoseki/miteru/wiki/Usage)
- [Configuration](https://github.com/ninoseki/miteru/wiki/Configuration)
- [Alternatives](https://github.com/ninoseki/miteru/wiki/Alternatives)
