# SUPLA-PUSHOVER

This software is a fork from [`supla-core`](https://github.com/SUPLA/supla-core') used to send notifications from SUPLA to your phone via [`Pushover`](https://pushover.net/) service.
You can define the conditions under which the notification will be sent and its content. The possibilities of this solution are described below.

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

