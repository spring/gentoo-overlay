# SpringRTS Gentoo overlay

Usage:
##### Install SpringRTS engines:
Note: this step is optional, most lobbies can automatically (and insecurely) download them on demand.
To disable the later for e.g. SpringLobby, do ```mkdir ~/.spring && touch ~/.spring/engine```.
SpringLobby will still offer and try to download them, but it will fail.

Spring 103.0 is the current (2017.07.20) stable.
```
emerge -a '=games-strategy/spring-103.0'
emerge -a '=games-strategy/spring-100.0' # For games:PA,PD
```
Note: each engine installs to its own SLOT=$PV and into ```/opt/springrts.com/spring/$SLOT```

##### Install a lobby client:
```
emerge -a 'games-util/springlobby'
```

If you installed engines via the above procedure then open/run SpringLobby, go to Edit->Preferences->Spring->Add New
and add the installed engines, first by picking UnitSync path ```/opt/springrts.com/spring/$SLOT/lib/unitsync.so```
and then the spring engine itself ```/opt/springrts.com/spring/$SLOT/bin/spring```
