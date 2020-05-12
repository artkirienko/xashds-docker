[![GitHub Actions Docker Image CI](https://github.com/artkirienko/xashds-docker/workflows/Docker%20Image%20CI/badge.svg)](https://github.com/artkirienko/xashds-docker/actions)
[![HitCount](http://hits.dwyl.com/artkirienko/xashds-docker.svg)](http://hits.dwyl.com/artkirienko/xashds-docker)

![banner](banner.png)

# Xash3D FWGS Dedicated Server Docker

## Xash3D FWGS Half-Life Dedicated Server as a Docker image

Probably the fastest and easiest way to set up an old-school Xash3D FWGS
Half-Life Deathmatch Dedicated Server (XashDS). You don't need to know
anything about Linux or XashDS to start a server. You just need Docker and
this image.

## Quick Start

Start a new server by running:

```bash
docker run -it --rm -d -p27015:27015 -p27015:27015/udp artkirienko/xashds
```

Change the player slot size, map or `rcon_password` by running:

```
docker run -it --rm -d --name xash -p27015:27015 -p27015:27015/udp artkirienko/xashds +maxplayers 12 +rcon_password SECRET_PASSWORD
```

> **Note:** Any [server config command](http://sr-team.clan.su/K_stat/hlcommandsfull.html)
  can be passed by using `+`. But it has to follow after the image name `artkirienko/xashds`.

## What is included

* Latest game assets via **SteamCMD** and
  [HLDS Build](https://github.com/DevilBoy-eXe/hlds) version `8308`

* [Xash3D] dedicated server

  ```
  Xash3D FWGS (build 1032, Linux-i386)
  ```

* [Metamod-p](https://github.com/mittorn/metamod-p) for Xash3D by mittorn
  version `1.21p37`

* [AMX Mod X](https://github.com/alliedmodders/amxmodx) version `1.8.2`

* [jk_botti](https://github.com/Bots-United/jk_botti) version `1.43`

* Minimal config present, such as `mp_timelimit`, `public 1` and mapcycle

## Default mapcycle

* crossfire.bsp
* bounce.bsp
* datacore.bsp
* frenzy.bsp
* gasworks.bsp
* lambda_bunker.bsp
* rapidcore.bsp
* snark_pit.bsp
* stalkyard.bsp
* subtransit.bsp
* undertow.bsp
* boot_camp.bsp

## Advanced

In order to use a custom server config file, add your settings
to `valve/config/server.cfg` of this project and mount the directory as volume
to `/opt/steam/xashds/valve/config` by running:

```bash
docker run -it --rm -d -p27015:27015 -p27015:27015/udp -v $(pwd)/valve/config:/opt/steam/xashds/valve/config artkirienko/xashds
```
