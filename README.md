# SUPLA-PUSHOVER

This software is a fork from [`supla-core`](https://github.com/SUPLA/supla-core) used to send notifications from SUPLA to your android or ios device via [`Pushover`](https://pushover.net/) service. This is not official SUPLA software. There are plans to have native notification support in SUPLA in near future. 

In order to use this software you need to have Pushover account, SUPLA account and a device like Raspberry Pi (3,4,Zero) or computer with linux installed (like Ubuntu).

The possibilities of this solution are described below. 

# Installation
```
sudo apt-get update
sudo apt-get install -y git libssl-dev build-essential curl bc
git clone https://github.com/lukbek/supla-pushover.git
cd supla-pushover
./install.sh
```

### Upgrade

Stop `supla-pushover` and execute:

```
cd supla-pushover
./install.sh
```

### Configuration

After installing there should be a supla-pushover-config.yaml file generated for you. You need to adjust your SUPLA account data, Pushover account data and configure conditions for notifications. 
Remeber that you need to enable SUPLA client device registration (smartphone) before starting this software and after starting it you need to assign an access id to the 'Supla pushover' client device witch appeared in SUPLA cloud.
The Pushover user key (not e-mail address) of your user (or you), viewable when logged into Pushover dashboard, token is your application's API token viewable when clicked on your Pushover application.

```
supla:
  port: 2016
  host: 'srvX.supla.org'
  email: 'email@supla.org'
  protocol_version: 10

pushover:
  user: 'XXXXXXXX'
  token: 'XXXXXXX'

notifications:
  - trigger: 'onchange'
    condition: '%channel_1% == 1'
    message: 'kitchen lamp is on!'

  - trigger: 'ontime'
    time: '* * 22 * * *'
    condition: '%channel_2% == 1 || %channel_3% == 1'
    message: 'porch lights are on!'
  
  - trigger: 'onchange'
    condition: '%channel_12% > 23.4'
    message: 'it is hot!'
```

Let's concentrate on notification conditions. There are two trigger types `onchange` and `ontime`.
First occurs when one of the conditionized channel change, second triggers when time condition is set.

# Condition language

In `condition` property you set an condition that must be set to trigger notification.
When you use %channel_N% (N is an channel id viewable in SUPLA cloud), parser will replace it with current channel value.
It'is using [`bc tool`](https://pl.wikipedia.org/wiki/Bc_(Unix)) for parsing expressions.

Example: 

Let's channel_1 is an temperature sensor. if you define condition like `%channel_1% > 15` parser will replace `%channel_1%` with value of current temperature and check if condition is set. If is it will trigger an notification.

Moreover conditions can be more sofisticated:

Assume that channel_2, channel_3, channel_4 are lamps. 
Condition `(%channel_2% == 1 || %channel_3 == 1) && %channel_4% == 0` will be true if `%channel_2%` or `%channel_3%` value is `1` and `%channel_4%` value is `0`.

You can test your condition with `bc` application that should be installed in your device. 
if you write `echo "(1 == 1 || 0 == 1) && 1 == 0" | bc` (channel values are example set of them) it will return a 1 if condition is set and 0 if it's not. Otherwise it will report and syntax error means that condition is wrong. In above example it will return 0 because 0 == 1 expression is false.

# Time condition format 

If you want use `ontime` trigger type you need to set `time` property. It is in [`cron`](https://en.wikipedia.org/wiki/Cron) format but with seconds support. Seconds are in first position of six character set.

Examples:

* `time='* * * * * *'` will trigger every second
* `time='\5 * * * * *'` will trigger on every 5 second
* `time='0 5 * * * *'` will trigger on every file minute of every hour
* `time='* * 22 * * *'` will trigger every day on 22:00 hour

You can test your value on [`crontab-generator`](https://crontab.guru/#*_*_*_*_*) website but remeber that default cron format does not support seconds. Minimum cron value is minute so you need to know that if you set in `crontab-generator` a value `* * * * *` you should add an aditional seconds mark in front of it before using it in supla-pushover expression. You can assign seconds mark just like a minute mark. 

# Support

Feel free to ask on forum.supla.org for this software and report issues on github.

