# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $


EAPI="4"
EGIT_REPO_URI="git://github.com/springlobby/springlobby.git"
EGIT_BRANCH="master"
EGIT_HAS_SUBMODULES="true"

inherit git-2 cmake-utils eutils flag-o-matic games

DESCRIPTION="lobby client for spring rts engine - git version"
HOMEPAGE="http://springlobby.info"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
RESTRICT="nomirror"
IUSE="+sound debug libnotify gstreamer"

RDEPEND="
        dev-libs/boost
	x11-libs/wxGTK:3.0
	net-misc/curl
	libnotify? (    x11-libs/libnotify )
	sound? (
			media-libs/openal
			media-libs/libvorbis
			media-libs/flac
			media-sound/mpg123
			media-libs/alure
	)
	gstreamer? (    media-libs/gstreamer )
"

DEPEND="${RDEPEND}
	>=dev-util/cmake-2.6.0
"
src_unpack() {
		git-2_src_unpack
}

BUILD_DIR="${WORKDIR}/${P}_build"
src_configure() {
	if ! use sound ; then
		mycmakeargs="${mycmakeargs} -DOPTION_SOUND=OFF"
	fi
	if use gstreamer ; then
		mycmakeargs="${mycmakeargs} -DGSTREAMER=ON"
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
	# bad
	dodir /usr/share/games/icons/hicolor/scalable/apps/
	mv ${D}/usr/games/share/icons/hicolor/scalable/apps/springlobby.svg ${D}/usr/share/games/icons/hicolor/scalable/apps/springlobby.svg
	rm ${D}/usr/share/games/pixmaps/ -fr
	dodir /usr/share/games/applications/
	mv ${D}/usr/games/share/applications/springlobby.desktop ${D}/usr/share/games/applications/springlobby.desktop
	rm ${D}/usr/games/share/applications/ -fr
	dodir /etc/env.d/
	echo 'XDG_DATA_DIRS="/usr/share/games"' >> ${D}/etc/env.d/99games
}

