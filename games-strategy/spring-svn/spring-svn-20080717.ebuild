# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion games eutils cmake-utils

DESCRIPTION="a 3D multiplayer real time strategy game engine"
HOMEPAGE="http://spring.clan-sy.com"
ESVN_REPO_URI="https://spring.clan-sy.com/svn/spring/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="
!virtual/game_spring
!games-strategy/taspring-linux-release
>=dev-libs/boost-1.34
media-libs/devil
>=media-libs/freetype-2.0.0
media-libs/glew
>=media-libs/libsdl-1.2.0
media-libs/openal
sys-libs/zlib
virtual/glu
virtual/jdk
virtual/opengl
"

DEPEND="${RDEPEND}
app-arch/zip
>=dev-util/cmake-2.6.0
"


pkg_setup () {
	built_with_use media-libs/libsdl X opengl
	if ! has_version \>=dev-libs/boost-1.34.0 ; then
		built_with_use dev-libs/boost threads
	fi
}

src_compile () {
	ewarn "This ebuild installs directly from a development repository."
	ewarn "The code might not even compile some times."
	einfo "If anything is weird, please file a bug report at ${HOMEPAGE}."
	INSTALL_LOCATION="/opt/spring/svn"
	
	mycmakeargs="${mycmakeargs} -DCMAKE_INSTALL_PREFIX=${INSTALL_LOCATION} -DSPRING_DATADIR=${INSTALL_LOCATION}"
	cmake-utils_src_compile
}

src_install () {
	cmake-utils_src_install
	newicon "${FILESDIR}/spring.png" ${PN}.png
	make_desktop_entry ${PN} "Spring RTS - svn" ${PN}.png
	
	insinto /etc/spring
	echo '$HOME'"/.spring" > ${WORKDIR}/datadir
	echo "${GAMES_DATADIR}/${PN}" >> ${WORKDIR}/datadir
	doins ${WORKDIR}/datadir
	
	prepgamesdirs
	ewarn "The location and structure of spring data has changed, you may need to adjust your lobby configs."
}