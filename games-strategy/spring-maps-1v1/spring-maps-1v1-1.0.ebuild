# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit games

DESCRIPTION="Small collection of 1v1 maps for Spring RTS"
HOMEPAGE="https://launchpad.net/~spring/+archive/ppa/+files/"
SRC_URI="${HOMEPAGE}${PN}_1.0ubuntu3.tar.gz"
LICENSE="unknown"
SLOT="0"
KEYWORDS="amd64 x86"
RESTRICT="nomirror"

DEPEND="${RDEPEND}
	app-arch/tar
"

src_install(){
	insinto	"${GAMES_DATADIR}/spring/maps"
	doins ${WORKDIR}/${PN}-1.0ubuntu3/*.sd7
	doins ${WORKDIR}/${PN}-1.0ubuntu3/*.sdz
	prepgamesdirs
}
