# Copyright 2008 SpringLobby.info
# Distributed under the terms of the GNU General Public License, v2 or later
# EBuild Author: Kaot
# EMail: Kaot@SpringLobby.info
# Widget Author: very_bad_soldier

inherit games Spring-Install_Widget_LUA_Directory

DESCRIPTION="Spring - Widget - Defense Range 4.13"
HOMEPAGE="http://spring.jobjol.nl/958"
LICENSE="CCPL-Attribution-ShareAlike-NonCommercial-2.5"

SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="fetch"

NAME="DefenseRange"
VERSION="413"

pkg_nofetch() {
    einfo "Please download"
    einfo "${NAME}${VERSION}.zip"
    einfo "from ${HOMEPAGE} and place them in ${DISTDIR}"
}

SRC_URI="${NAME}${VERSION}.zip"

src_install() {
	cd "${WORKDIR}"

	insinto	"${GAMES_DATADIR}/spring/LuaUI"
	rm -f "${WORKDIR}/LuaUI/Widgets/gui_defenseRange_units.inc"
	doins -r "${WORKDIR}/LuaUI/Images"
	doins -r "${WORKDIR}/LuaUI/Widgets"
	
	prepgamesdirs
}
