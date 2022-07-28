# Managing Bot Cycles

This repository contains the sample folder structure to organize bot configurations and scripts to run your all your bots at once.

*For your context, this structure is only for bots running Pure Market Making strategy, for other strategy, please modify line 30 and 31 in `init_and_run_bots.sh` script to point to correct config file name and strategy.*



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
    └── start.sh
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

# How To Use This
The purpose of this folder structure and scripts is to make it easier to manage multiple bots and launch them all at once on your computer or server.

In order to do that, you need to do two things:

1. Organize your bot configurations into folders and manage it from there.
2. Manage the launch of your bot by using `bots_to_run` file and `init_and_run_bots.sh` script.

## Configuration Folders
For each of your bot or token pair, you should put your configuration as follow:
```
asd-eth-usdt/
├── hummingbot_conf/
│   ├── conf_fee_overrides.yml
│   ├── conf_global.yml
│   ├── conf_pure_mm_asd-eth-usdt.yml
│   ├── hummingbot_logs.yml
│   └── ... // Any encrypted keys
└── hummingbot_scripts/
    └── some_scripts.py
```
- Main folder should have the following naming convention: `[exchange]-[token]-[quote]_files`, in the above example, the folder is for the pair **ETH/USDT** on **AscendEX** exchange. This convention is for specifying which bot to run in `bots_to_run` file and lets `init_and_run_bots.sh` script to find the config folder correctly, also it lets you know which exchange the pair is on
- The config file for strategy `conf_pure_mm_asd-eth-usdt.yml` should follow the similar naming which is `conf_pure_mm_[exchange]-[token]-[quote].yml`
- `hummingbot_conf` is the place to store bot main configuration files and encrypted keys
- `hummingbot_scripts` is the place to store scripts, this is applicable only for Pure Market Making strategy at the moment

## Launching Bots
To launch bot you will need to specify what bot to run in `bots_to_run` file, for example, this is the current content of the file:
```
asd-eth-usdt
bin-bnb-busd
```
This means only 2 bots (`ETH/USDT` and `BNB/BUSD`) will be launched.

After specifying bots in `bots_to_run` file, you can run `init_and_run_bots.sh` script to launch your bots:
```
bash init_and_run_bots.sh
```
The script will do the following steps:
- Stop and remove all current bot instances
- Read `bots_to_run` file to get the list of bots to launch
- For each bot in the list, the script create new bot instance and run it, the bot instance will automatically start without any intervention
- There is a slight delay of 30 seconds between bot creation, this is for avoiding getting socket ban from the exchange


# Utility Scripts
- `start.sh` bash script to manually hook into your bot instance
- `remove_bots.sh` stop and remove all bot instances, this will not cancel your trade orders