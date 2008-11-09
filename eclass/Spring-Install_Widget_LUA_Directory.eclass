# Copyright 2008 SpringLobby.info
# Distributed under the terms of the GNU General Public License, v2 or later
# EClass Author: Kaot
# EMail: Kaot@SpringLobby.info

# This eclass provides some Methods in order to increase the Reusage of Code.

# Installs Widgets, that are packed without Parent Directory in it's Zip-File.

src_install() {
	cd "${WORKDIR}"

	insinto "${GAMES_DATADIR}/spring"
	doins -r "${WORKDIR}/LuaUI"

	prepgamesdirs
}
