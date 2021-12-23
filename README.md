# Spring RTS Gentoo overlay

## Overlay

This overlay is registered in the Gentoo database as `spring` (see https://repos.gentoo.org).

## Spring RTS engine

Note: installing the engine through `emerge` is optional, most lobbies can automatically (and insecurely) download it on demand. To disable the later for SpringLobby, do `mkdir ~/.spring && touch ~/.spring/engine` (SpringLobby will still offer and try to download, but it will actually fail).

Version 105.0 is the current stable, and 9999 is the latest from the `develop` branch.

```
emerge -a '=games-strategy/spring-105.0'  # For stable
emerge -a '=games-strategy/spring-9999'   # For latest
```

## Install SpringLobby client

*Do not use the package from the Gentoo mainstream, it is outdated & broken, and has been requested for removal (see https://github.com/gentoo/gentoo/pull/23483).*

Version 0.273 is the current stable, and 9999 is the latest from the `master` branch.

```
emerge -a '=games-util/springlobby-0.273' # For stable
emerge -a '=games-util/springlobby-9999'  # For latest

```

If you installed the engine via the above procedure, then:
- open/run `SpringLobby`
- go to `Edit->Preferences->Spring->Add New`
- add the installed engine:
  - first by picking UnitSync path: `/usr/lib64/unitsync.so` (for AMD64)
  - then by picking the engine: `/usr/bin/spring`

## See also

- [Spring RTS Gentoo installation](https://springrts.com/wiki/Gentoo_install)
- [SpringLobby Gentoo installation](https://github.com/springlobby/springlobby/wiki/Install#Gentoo)
