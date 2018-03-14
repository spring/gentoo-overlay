# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

WX_GTK_VER="3.0"
inherit cmake-utils eutils flag-o-matic wxwidgets

DESCRIPTION="lobby client for spring rts engine"
HOMEPAGE="http://springlobby.info"
SRC_URI="http://www.springlobby.info/tarballs/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
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
	unpack $A
	cd "$S"
}

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
