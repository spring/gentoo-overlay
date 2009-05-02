# Copyright 2008 SpringLobby.info
# Distributed under the terms of the GNU General Public License, v2 or later
# EClass Author: Kaot
# EMail: Kaot@SpringLobby.info

# This eclass provides some Methods in order to increase the Reusage of Code

src_unpack() {
	FILENAME="${A/download.*file=/}"
	cp "${DISTDIR}/${A}" "${WORKDIR}/${FILENAME}"
}

src_install() {
	FILENAME="${A/download.*file=/}"

	cd "${WORKDIR}"

	insinto	"${GAMES_DATADIR}/spring/mods"
	doins -r "${WORKDIR}/${FILENAME}"

	prepgamesdirs
}
