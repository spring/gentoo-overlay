# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

GIT_ECLASS="git-2"
EGIT_REPO_URI="git://github.com/cleanrock/flobby.git"
EGIT_BRANCH="master"

inherit games cmake-utils eutils fdo-mime flag-o-matic games ${GIT_ECLASS}

DESCRIPTION="flobby is a Spring (http://springrts.com) lobby client written in C++."
HOMEPAGE=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="nomirror"
IUSE=""


RDEPEND="
	games-strategy/spring
"

DEPEND="${RDEPEND}
	>=sys-devel/gcc-4.6.0
	>=dev-util/cmake-2.6.0
	x11-libs/libXpm
	x11-libs/libXScrnSaver
	x11-libs/fltk[threads,xft]
	media-gfx/imagemagick
	dev-libs/boost
"

src_configure() {
	mycmakeargs="${mycmakeargs} -DAUX_VERSION=(Gentoo,$ARCH) -DCMAKE_INSTALL_PREFIX=/usr/games/"
	cmake-utils_src_configure
}

src_compile () {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	prepgamesdirs
}

