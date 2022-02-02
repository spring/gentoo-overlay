# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

WX_GTK_VER="3.0-gtk3"
inherit git-r3 cmake xdg-utils wxwidgets

EGIT_REPO_URI="https://github.com/springlobby/springlobby.git"
EGIT_BRANCH="master"

DESCRIPTION="The official lobby client for SpringRTS community games"
HOMEPAGE="https://springlobby.springrts.com"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug +libnotify +nls +sound"

RDEPEND="
	>=dev-libs/boost-1.35:=
	dev-libs/openssl:=
	net-misc/curl
	sys-libs/zlib[minizip]
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libXext
	x11-libs/wxGTK:${WX_GTK_VER}[X]
	libnotify? ( x11-libs/libnotify )
	sound? ( media-libs/alure
		media-libs/openal
	)
"

DEPEND="${RDEPEND}"

BDEPEND="nls? ( sys-devel/gettext )"

src_configure() {
	setup-wxwidgets
	local mycmakeargs=(
		-DOPTION_NOTIFY=$(usex libnotify)
		-DOPTION_SOUND=$(usex sound)
		-DOPTION_TRANSLATION_SUPPORT=$(usex nls)
		-DAUX_VERSION="(Gentoo,${ARCH})"
		)
	cmake_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
