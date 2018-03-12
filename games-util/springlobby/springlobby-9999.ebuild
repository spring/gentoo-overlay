# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

WX_GTK_VER="3.0"
inherit git-r3 cmake-utils eutils flag-o-matic wxwidgets

EGIT_REPO_URI="git://github.com/springlobby/springlobby.git"
EGIT_BRANCH="master"

DESCRIPTION="lobby client for spring rts engine - git version"
HOMEPAGE="http://springlobby.info"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
RESTRICT="mirror"
IUSE="+sound debug libnotify"

RDEPEND="
	dev-libs/boost
	x11-libs/wxGTK:${WX_GTK_VER}[X]
	net-misc/curl
	libnotify? (    x11-libs/libnotify )
	sound? (
			media-libs/openal
			media-libs/libvorbis
			media-libs/flac
			media-sound/mpg123
			media-libs/alure
	)
"

DEPEND="${RDEPEND}
	>=dev-util/cmake-2.6.0
"
src_unpack() {
		git-r3_src_unpack
}

BUILD_DIR="${WORKDIR}/${P}_build"
src_configure() {
	mycmakeargs=(
		-DOPTION_SOUND=$(usex sound)
		-DAUX_VERSION="(Gentoo,$ARCH)"
		-DCMAKE_INSTALL_PREFIX=/usr/games/
	)

	cmake-utils_src_configure
}

src_compile () {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	# bad
	mv "${D}/usr/games/share/icons/hicolor/scalable/apps/springlobby.svg" "${D}/usr/share/games/icons/hicolor/scalable/apps/springlobby.svg"
	rm "${D}/usr/share/games/pixmaps/" -fr
	dodir /usr/share/games/applications/
	mv "${D}/usr/games/share/applications/springlobby.desktop" "${D}/usr/share/games/applications/springlobby.desktop"
	rm "${D}/usr/games/share/applications/" -fr
	dodir /etc/env.d/
	echo 'XDG_DATA_DIRS="/usr/share/games"' >> "${D}/etc/env.d/99games"
}
