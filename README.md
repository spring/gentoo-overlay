# Spring RTS Gentoo overlay

## Overlay

This overlay is registered in the Gentoo database as `spring` (see https://repos.gentoo.org).

How to use that overlay:

- If `eselect-repository` is not installed: `emerge eselect-repository`
- Enable the `spring` repository: `eselect repository enable spring`
- *Optional*: check the repository is now declared in `/etc/portage/repos.conf/eselect-repo.conf`
- Update that repository: `emerge --sync spring`
- *Optional*: check the repository has been downloaded in `/var/db/repos/spring`
- Unmask the `spring` and `springlobby` packages:

```
echo "games-strategy/spring ~amd64" >> /etc/portage/package.accept_keywords
echo "games-util/springlobby ~amd64" >> /etc/portage/package.accept_keywords
```

Note: `package.accept_keywords` can be either a file or a directory (see `man portage` for details).

## Spring RTS engine

Note: installing the engine through `emerge` is optional, most lobbies can automatically (and insecurely) download it on demand. To disable the later for SpringLobby, do `mkdir ~/.spring && touch ~/.spring/engine` (SpringLobby will still offer and try to download, but it will actually fail).

Version 105.0 is the current stable, and 9999 is the latest from the `master` (= `maintenance`) branch.

Update on 2022-01-02: `spring-105.0` is currently broken because of an incomplete source tarball (tracked by https://springrts.com/mantis/view.php?id=6446). Use `spring-9999` that is also pointing today to the 105.0 version.

```
emerge -a '=games-strategy/spring-105.0'  # For stable
emerge -a '=games-strategy/spring-9999'   # For latest
```

## Install SpringLobby client

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
