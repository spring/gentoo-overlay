# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

WX_GTK_VER="3.0-gtk3"
inherit git-r3 cmake eutils flag-o-matic wxwidgets

EGIT_REPO_URI="https://github.com/springlobby/springlobby.git"
EGIT_BRANCH="master"

DESCRIPTION="The official lobby client for SpringRTS community games"
HOMEPAGE="https://springlobby.springrts.com"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
RESTRICT="mirror"
IUSE="+sound debug libnotify"

RDEPEND="
	dev-libs/boost
	dev-libs/openssl:*
	libnotify? ( x11-libs/libnotify )
	media-libs/libpng:*
	net-misc/curl
	sound? ( media-libs/alure
	         media-libs/openal
	)
	sys-libs/zlib[minizip]
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libXext
	x11-libs/wxGTK:${WX_GTK_VER}[X]
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

	cmake_src_configure
}

src_compile () {
	cmake_src_compile
}

src_install() {
	cmake_src_install
	# bad
	dodir /usr/share/games/icons/hicolor/scalable/apps/
	mv "${D}/usr/games/share/icons/hicolor/scalable/apps/springlobby.svg" "${D}/usr/share/games/icons/hicolor/scalable/apps/springlobby.svg"
	rm "${D}/usr/share/games/pixmaps/" -fr
	dodir /usr/share/games/applications/
	mv "${D}/usr/games/share/applications/springlobby.desktop" "${D}/usr/share/games/applications/springlobby.desktop"
	rm "${D}/usr/games/share/applications/" -fr
	dodir /etc/env.d/
	echo 'XDG_DATA_DIRS="/usr/share/games"' >> "${D}/etc/env.d/99games"
}
