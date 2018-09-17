# Miteru

[![Build Status](https://travis-ci.org/ninoseki/miteru.svg?branch=master)](https://travis-ci.org/ninoseki/miteru)
[![Maintainability](https://api.codeclimate.com/v1/badges/d90e1b5bbdd9663a17d1/maintainability)](https://codeclimate.com/github/ninoseki/miteru/maintainability)
[![Coverage Status](https://coveralls.io/repos/github/ninoseki/miteru/badge.svg?branch=master)](https://coveralls.io/github/ninoseki/miteru?branch=master)

Miteru is an experimental phishing kit detection tool.

## How it works

- It collects phishing suspicious URLs from [urlscan.io](https://urlscan.io/search/#certstream-suspicious).
- It checks a suspicious URL whether it contains a phishing kit (`*.zip` file) or not.

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
