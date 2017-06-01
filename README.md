# udpreplay

## Overview

`udpreplay` is a simple application for forwarding UDP stateless traffic. The
application is a `gopiper` pipeline, so gopiper is required.

## Running

```bash
gopiper --pipe udpreplay.lua
```

### Using Docker

```bash
docker run -e DEVICE='eth0' -e ADDRESS_LIST='192.168.1.1' redborder/udpreplay
```

## Requirements

`gopiper` is required to run the application. Also the `pcap` gopiper component
and `multiudp` gopiper component are required.

## Configuration

You can configure the application using environment variables:

| Environment  | Description                               |
|--------------|-------------------------------------------|
| ADDRESS_LIST | CSV list of addresses to forward traffic  |
| FILTER       | BPF filter used to capture packets        |
| DEVICE       | Device used to capture packets            |

Example:

```bash
env ADDRESS_LIST='192.168.1.15,192.168.1.25' DEVICE='eth0' FILTER='udp port 2055 and host 10.0.150.6' gopiper --pipe udpreplay.lua
```

** *NOTE:* If the same interface is used to capture and send packets you should
use a BPF filter to avoid loops. **
