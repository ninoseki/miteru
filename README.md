# Miteru

[![Gem Version](https://badge.fury.io/rb/miteru.svg)](https://badge.fury.io/rb/miteru)
[![Build Status](https://travis-ci.org/ninoseki/miteru.svg?branch=master)](https://travis-ci.org/ninoseki/miteru)
[![Maintainability](https://api.codeclimate.com/v1/badges/d90e1b5bbdd9663a17d1/maintainability)](https://codeclimate.com/github/ninoseki/miteru/maintainability)
[![Coverage Status](https://coveralls.io/repos/github/ninoseki/miteru/badge.svg?branch=master)](https://coveralls.io/github/ninoseki/miteru?branch=master)

Miteru is an experimental phishing kit detection tool.

## How it works

- It collects phishing suspicious URLs from the following feeds:
  - [urlscan.io certstream-suspicious feed](https://urlscan.io/search/#certstream-suspicious)
  - [OpenPhish feed via urlscan.io](https://urlscan.io/search/#OpenPhish)
  - [PhishTank feed via urlscan.io](https://urlscan.io/search/#PhishTank)
- It checks a suspicious URL whether it enables directory listing and contains a phishing kit (compressed file) or not.
  - Note: compressed file = `*.zip`, `*.rar`, `*.7z`, `*.tar` and `*.gz`.

## Features

- [x] Phishing kit detection & collection.
- [x] Slack integration. (Posting a message to Slack if the tool detects a phishing kit.)
- [x] Threading.

## Installation

```sh
$ gem install miteru
```

## Usage

```sh
$ miteru
Commands:
  miteru execute         # Execute the crawler
  miteru help [COMMAND]  # Describe available commands or one specific command
```

```sh
$ miteru help execute
Usage:
  miteru execute

Options:
  [--auto-download], [--no-auto-download]              # Enable or disable auto-download of compressed file(s)
  [--directory-traveling], [--no-directory-traveling]  # Enable or disable directory traveling
  [--download-to=DOWNLOAD_TO]                          # Directory to download file(s)
                                                       # Default: /tmp
  [--post-to-slack], [--no-post-to-slack]              # Post a message to Slack if it detects a phishing kit
  [--size=N]                                           # Number of urlscan.io's results. (Max: 10,000)
                                                       # Default: 100
  [--threads=N]                                        # Number of threads to use
                                                       # Default: 10
  [--verbose], [--no-verbose]
                                                       # Default: true

Execute the crawler
```

```sh
$ miteru execute
...
https://dummy1.com: it doesn't contain a phishing kit.
https://dummy2.com: it doesn't contain a phishing kit.
https://dummy3.com: it doesn't contain a phishing kit.
https://dummy4.com: it might contain a phishing kit (dummy.zip).
```

## Aasciinema cast

[![asciicast](https://asciinema.org/a/ga6ZbwuK1HOLOyELb23QrSvJP.svg)](https://asciinema.org/a/ga6ZbwuK1HOLOyELb23QrSvJP)

Note: Stoped the process during the execution because it takes minutes to finish.

## Note

For using `--post-to-slack` feature, you should set the following environment variables:

- `SLACK_WEBHOOK_URL`: Your Slack Webhook URL.
- `SLACK_CHANNEL`: Slack channel to post a message (default: "#general").

## Alternatives

- [t4d/StalkPhish](https://github.com/t4d/StalkPhish): The Phishing kits stalker, harvesting phishing kits for investigations.
- [duo-labs/phish-collect](https://github.com/duo-labs/phish-collect): Python script to hunt phishing kits.
