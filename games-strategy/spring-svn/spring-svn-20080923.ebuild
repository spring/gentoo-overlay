# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion games eutils cmake-utils fdo-mime

DESCRIPTION="a 3D multiplayer real time strategy game engine"
HOMEPAGE="http://spring.clan-sy.com"
ESVN_REPO_URI="https://spring.clan-sy.com/svn/spring/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug python-bindings"

RDEPEND="
	!virtual/game_spring
	!games-strategy/taspring-linux-release
	>=dev-libs/boost-1.35
	media-libs/devil
	>=media-libs/freetype-2.0.0
	media-libs/glew
	>=media-libs/libsdl-1.2.0
	media-libs/openal
	sys-libs/zlib
	virtual/glu
	virtual/opengl
	python-bindings? ( >=dev-lang/python-2.5 )
"

DEPEND="${RDEPEND}
	app-arch/zip
	>=dev-util/cmake-2.6.0
"

### where to place content files which change each spring release (as opposed to mods, ota-content which go somewhere else)
VERSION_DATADIR="${GAMES_DATADIR}/${PN}"

pkg_setup () {
	built_with_use media-libs/libsdl X opengl
}

src_compile () {
	ewarn "This ebuild installs directly from a development repository."
	ewarn "The code might not even compile some times."
	einfo "If anything is weird, please file a bug report at ${HOMEPAGE}."
	
	mycmakeargs="${mycmakeargs} -DCMAKE_INSTALL_PREFIX="/" -DBINDIR="${GAMES_BINDIR}" -DLIBDIR="$(games_get_libdir)" -DDATADIR="${VERSION_DATADIR}" -DSPRING_DATADIR="${VERSION_DATADIR}" -DAPPLICATIONS_DIR="/usr/share/applications/" -DPIXMAPS_DIR="/usr/share/pixmaps/" -DMIME_DIR="/usr/share/mime""
	if use debug ; then
		mycmakeargs="${mycmakeargs} -DCMAKE_BUILD_TYPE=DEBUG"
	else
		mycmakeargs="${mycmakeargs} -DCMAKE_BUILD_TYPE=RELEASE"
	fi
	cmake-utils_src_compile
}

src_install () {
	cmake-utils_src_install

	cd "${D%%/}${GAMES_BINDIR}"
	mv spring ${PN}
	mv dedicated dedicated-svn

	cd "${D%%/}$(games_get_libdir())"
	mv libunitsync.so libunitsync-svn.so
	
	insinto /etc/spring
		echo '$HOME/.spring' > ${WORKDIR}/datadir
		echo "${GAMES_DATADIR}/spring" >> ${WORKDIR}/datadir
	doins ${WORKDIR}/datadir
	
	prepgamesdirs
	ewarn "The location and structure of spring data has changed, you may need to adjust your lobby configs."
}


pkg_postinst() {
	fdo-mime_mime_database_update
}