# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

GIT_ECLASS="git-2"
EGIT_REPO_URI="git://github.com/cleanrock/flobby.git"
EGIT_BRANCH="master"
EGIT_HAS_SUBMODULES="true"

inherit games cmake-utils eutils fdo-mime flag-o-matic games ${GIT_ECLASS}

DESCRIPTION="flobby is a Spring (http://springrts.com) lobby client written in C++."
HOMEPAGE="https://github.com/cleanrock/flobby"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"
IUSE="pr-downloader"

RDEPEND="
	games-strategy/spring:*
"

DEPEND="${RDEPEND}
	>=sys-devel/gcc-4.6.0
	>=dev-util/cmake-2.6.0
	x11-libs/libXpm
	x11-libs/libXScrnSaver
	x11-libs/fltk[threads,xft]
	media-gfx/graphicsmagick[png]
	dev-libs/boost
	net-misc/curl
	dev-libs/jsoncpp
"

src_configure() {
	if !use pr-downloader ; then
		mycmakeargs="${mycmakeargs} -DWITH_PRD=NO"
	fi
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
