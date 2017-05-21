# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

if [[ ${PV} = 9999* ]]; then
	GIT_ECLASS="git-r3"
	EGIT_REPO_URI="git://github.com/spring/spring.git"
	EGIT_BRANCH="develop"
else
	SRC_URI="mirror://sourceforge/springrts/${PN}_${PV}_src.tar.lzma"
fi
KEYWORDS="~x86 ~amd64 ~ia64"

inherit games cmake-utils eutils fdo-mime flag-o-matic games ${GIT_ECLASS} java-pkg-opt-2

DESCRIPTION="A 3D multiplayer real-time strategy game engine"
HOMEPAGE="http://springrts.com"
S="${WORKDIR}/${PN}-${PV}"

LICENSE="GPL-2"
SLOT="0"
IUSE="+ai +java +default headless dedicated test-ai debug -profile -custom-march -custom-cflags +tcmalloc +threaded bindist -lto test"
RESTRICT="nomirror strip"

REQUIRED_USE="
	|| ( default headless dedicated )
	java? ( ai )
"

GUI_DEPEND="
	media-libs/devil[jpeg,png,opengl,tiff,gif]
	>=media-libs/freetype-2.0.0
	>=media-libs/glew-1.6
	media-libs/libsdl2[X,opengl]
	x11-libs/libXcursor
	media-libs/openal
	media-libs/libvorbis
	media-libs/libogg
	virtual/glu
	virtual/opengl
"

RDEPEND="
	>=dev-libs/boost-1.35
	>=sys-libs/zlib-1.2.5.1[minizip]
	media-libs/devil[jpeg,png]
	java? ( virtual/jdk )
	default? ( ${GUI_DEPEND} )
"

DEPEND="${RDEPEND}
	>=sys-devel/gcc-4.2
	app-arch/p7zip
	>=dev-util/cmake-2.6.0
	tcmalloc? ( dev-util/google-perftools )
	java? ( >=virtual/jdk-1.6 )
"

### where to place content files which change each spring release (as opposed to mods, ota-content which go somewhere else)
VERSION_DATADIR="${GAMES_DATADIR}/${PN}"


src_test() {
	cmake-utils_src_test
}

src_prepare() {
	git submodule init || die
	git submodule update || die
}

src_configure() {

	# Custom cflags break online play
	if use custom-cflags ; then
		ewarn "\e[1;31m*********************************************************************\e[0m"
		ewarn "You enabled Custom-CFlags! ('custom-cflags' USE flag)"
		ewarn "It's \e[1;31mimpossible\e[0m that this build will work in online play."
		ewarn "Disable it before doing a bugreport."
		ewarn "\e[1;31m*********************************************************************\e[0m"
		ebeep 6
	else
		strip-flags
	fi

	# Custom march may break online play
	if use custom-march ; then
		ewarn "\e[1;31m*********************************************************************\e[0m"
		ewarn "You enabled Custom-march! ('custom-march' USE flag)"
		ewarn "It may break online play."
		ewarn "If so, disable it before doing a bugreport."
		ewarn "\e[1;31m*********************************************************************\e[0m"

		mycmakeargs="${mycmakeargs} -DMARCH_FLAG=$(get-flag march)"
	fi

	# tcmalloc
	mycmakeargs="${mycmakeargs} $(cmake-utils_use_use tcmalloc TCMALLOC)"

	# dxt recompression
	mycmakeargs="${mycmakeargs} $(cmake-utils_useno bindist USE_LIBSQUISH)"

	# threadpool
	mycmakeargs="${mycmakeargs} $(cmake-utils_use_use threaded THREADPOOL)"

	# LinkingTimeOptimizations
	mycmakeargs="${mycmakeargs} $(cmake-utils_use lto LTO)"
	if use lto; then
		ewarn "\e[1;31m*********************************************************************\e[0m"
		ewarn "You enabled LinkingTimeOptimizations! ('lto' USE flag)"
		ewarn "It's likely that the compilation fails and/or online play may break."
		ewarn "If so, disable it before doing a bugreport."
		ewarn "\e[1;31m*********************************************************************\e[0m"
	fi

	# AI
	if use ai ; then

		if use !java ; then
			# Don't build Java AI
			mycmakeargs="${mycmakeargs} -DAI_TYPES=NATIVE"
		fi

		if use !test-ai ; then
			# Don't build example AIs
			mycmakeargs="${mycmakeargs} -DAI_EXCLUDE_REGEX='Null|Test'"
		fi
	else
		if use !test-ai ; then
			mycmakeargs="${mycmakeargs} -DAI_TYPES=NONE"
		else
			mycmakeargs="${mycmakeargs} -DAI_TYPES=NATIVE"
			mycmakeargs="${mycmakeargs} -DAI_EXCLUDE_REGEX='^[^N].*AI'"
		fi
	fi

	# Selectivly enable/disable build targets
	for build_type in default headless dedicated
	do
		mycmakeargs="${mycmakeargs} $(cmake-utils_use ${build_type} BUILD_spring-${build_type})"
	done

	# Set common dirs
	LIBDIR="$(games_get_libdir)"
	mycmakeargs="${mycmakeargs} -DCMAKE_INSTALL_PREFIX=/usr -DBINDIR=${GAMES_BINDIR#/usr/} -DLIBDIR=${LIBDIR#/usr/} -DDATADIR=${VERSION_DATADIR#/usr/}"

	# Enable/Disable debug symbols
	if use profile ; then
		CMAKE_BUILD_TYPE="PROFILE"
	else
		if use debug ; then
			CMAKE_BUILD_TYPE="RELWITHDEBINFO"
		else
			CMAKE_BUILD_TYPE="RELEASE"
		fi
	fi

	# Configure
	cmake-utils_src_configure
}

src_compile () {
	cmake-utils_src_compile
}

src_install () {
	cmake-utils_src_install

	prepgamesdirs
}

pkg_postinst() {
	fdo-mime_mime_database_update
	games_pkg_postinst
}
