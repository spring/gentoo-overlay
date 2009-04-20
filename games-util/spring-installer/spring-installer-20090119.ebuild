# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils games

DESCRIPTION="Easy content installation"
HOMEPAGE="http://files.caspring.org"
SRC_URI="${HOMEPAGE}/release/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="nomirror"

RDEPEND="
	games-strategy/spring
"
DEPEND="${RDEPEND}
	dev-ml/extlib
	dev-ml/findlib
	dev-ml/lablgtk
	dev-ml/ocamlnet
	dev-lang/ocaml
"

src_compile() {
	emake -j1 || die "emake failed"
	prepall
}

src_install() {
	emake install DESTDIR=${D} PREFIX=/usr GAMESBIN=${GAMES_BINDIR#/usr/}
	prepgamesdirs
}