# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_REPO_URI="git://github.com/cleanrock/flobby.git"
EGIT_BRANCH="master"
# FIXME: replaced by EGIT_SUBMODULES
# See https://devmanual.gentoo.org/eclass-reference/git-r3.eclass/index.html
EGIT_HAS_SUBMODULES="true"

# FIXME: deprecated 'fdo-mime' was inherited but not used
# xdg*.eclass should be used for mime DB update if needed
inherit git-r3 cmake flag-o-matic

DESCRIPTION="flobby is a spring (http://springrts.com) lobby client written in C++"
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
	cmake_src_configure
}

src_compile () {
	cmake_src_compile
}

src_install() {
	# Depreciation notice
	# games.eclass was removed from Gentoo mainstream
	# Files should not belong to root:games any more
	# See https://wiki.gentoo.org/wiki/Project:Games/Ebuild_howto
	cmake_src_install
}
