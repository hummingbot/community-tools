# Managing Bot Cycles

This repository contains the sample folder structure to organize bot configurations and scripts to run your all your bots at once.

*For your context, this structure is only for bots running Pure Market Making strategy, for other strategy, please modify line 48 and 49 in `init_and_run_bots.sh` script to point to correct config file name and strategy.*

*Only support HB client version dev-1.7.0, will not work with older version, i.e. 1.6.0*

```
.
└── manage-bot-cycles/
    ├── asd-eth-usdt_files/
    │   ├── hummingbot_conf/
    │   └── hummingbot_scripts/
    ├── bin-bnb-busd_files/
    ├── kucoin-btc-usdt_files/
    ├── bots_to_run
    ├── init_and_run_bots.sh
    ├── readme.md
    ├── remove_bots.sh
    ├── start.sh
    └── update.sh
```

- `manage-bot-cycles` is the root folder
- `asd-eth-usdt_files` folder or any `*_files` folder is the place to store bot configuration for any particular token pair
- `hummingbot_conf` is the place to store bot main configuration files
- `hummingbot_scripts` is the place to store scripts
- `bots_to_run` text file to specify which pair to run bot
- `init_and_run_bots.sh` bash script to init and run bots that are specified in `bots_to_run` file
- `readme.md` this read me
- `remove_bots.sh` stop and remove all bot instances, this will not cancel your trade orders
- `start.sh` bash script to manually hook into your bot instance
- `update.sh` bash script to manually update bot docker images

# How To Use This
The purpose of this folder structure and scripts is to make it easier to manage multiple bots and launch them all at once on your computer or server.

In order to do that, you need to do two things:

1. Organize your bot configurations into folders and manage it from there.
2. Manage the launch of your bot by using `bots_to_run` file and `init_and_run_bots.sh` script.

## Configuration Folders
For each of your bot or token pair, you should put your configuration as follow:
```
asd-eth-usdt/
├── gateway_conf/
├── gateway_logs/
├── hummingbot_certs/
├── hummingbot_conf/
│   ├── connectors/
│   ├── strategies/
│   │   └── conf_pure_mm_asd-eth-usdt.yml
│   ├── .password_verification
│   ├── conf_client.yml
│   ├── conf_fee_overrides.yml
│   └── hummingbot_logs.yml
├── hummingbot_data/
├── hummingbot_logs/
├── hummingbot_pmm_scripts/
└── hummingbot_scripts/
```
- Main folder should have the following naming convention: `[exchange]-[token]-[quote]_files`, in the above example, the folder is for the pair **ETH/USDT** on **AscendEX** exchange. This convention is for specifying which bot to run in `bots_to_run` file and lets `init_and_run_bots.sh` script to find the config folder correctly, also it lets you know which exchange the pair is on
- `connectors` is where you store your exchange API keys
- `strategies` is where you store your strategy config files
- The strategy config file `conf_pure_mm_asd-eth-usdt.yml` follows the naming convention `conf_pure_mm_[exchange]-[token]-[quote].yml`
- `hummingbot_conf` is the place to store bot main configuration files and encrypted keys
- `hummingbot_pmm_scripts` is the place to store scripts, this is applicable only for Pure Market Making strategy
- `hummingbot_scripts` is the place to store customized scripts, this is applicable only for the new script strategy available from bot client 1.6.0

## Launching Bots
To launch bot you will need to specify what bot to run in `bots_to_run` file and set environment variables in `init_and_run_bots.sh` script, for example, this is the current content of the file:
```
asd-eth-usdt
bin-bnb-busd
```
This means only 2 bots (`ETH/USDT` and `BNB/BUSD`) will be launched.

After specifying bots in `bots_to_run` file, please set the following environment variables in `init_and_run_bots.sh`, line 48 -> 50:

```bash
  export STRATEGY="pure_market_making" # Name of the strategy to auto run
  export CONFIG_FILE_NAME="conf_pure_mm_$1.yml" # Name of the config file to auto run, $1 is template for the name of the bots in bots_to_run file
  export CONFIG_PASSWORD='password' # Password to access your bot, it is for the login prompt when you first start the bot
```

 Then you can run `init_and_run_bots.sh` script to launch your bots:
```
bash init_and_run_bots.sh
```
The script will do the following steps:
- Stop and remove all current bot instances
- Read `bots_to_run` file to get the list of bots to launch
- For each bot in the list, the script create new bot instance and run it, the bot instance will automatically start without any intervention
- There is a slight delay of 30 seconds between bot creation, this is for avoiding getting socket ban from the exchange


# Utility Scripts
- `remove_bots.sh` stop and remove all bot instances, this will not cancel your trade orders
- `start.sh` bash script to manually hook into your bot instance
- `update.sh` bash script to manually update bot docker

# Change Logs
- `17 August 2022`: Reworked the folder sturcture, updated `init_and_run_bots.sh` to support dev-1.7.0 version.