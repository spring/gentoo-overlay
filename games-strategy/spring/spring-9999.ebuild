# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_REPO_URI="https://github.com/spring/spring.git"
EGIT_BRANCH="master"
KEYWORDS="~amd64 ~x86"
S="${WORKDIR}/${PN}-$PV"

inherit git-r3 cmake flag-o-matic java-pkg-opt-2 xdg-utils

DESCRIPTION="A 3D multiplayer real-time strategy game engine"
HOMEPAGE="https://springrts.com"
LICENSE="GPL-2"
SLOT="0"
IUSE="+ai java +default headless dedicated test-ai debug -profile -custom-march -custom-cflags +tcmalloc +threaded bindist -lto test"
RESTRICT="mirror strip"

REQUIRED_USE="
	|| ( default headless dedicated )
	java? ( ai )
"

GUI_DEPEND="
	media-libs/devil[jpeg,png,opengl,tiff,gif]
	>=media-libs/freetype-2.0.0
	>=media-libs/glew-1.6:*
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
	java? ( >=virtual/jdk-1.8:* )
	default? ( ${GUI_DEPEND} )
"

DEPEND="${RDEPEND}
	>=sys-devel/gcc-4.2
	app-arch/p7zip
	>=dev-util/cmake-2.6.0
	tcmalloc? ( dev-util/google-perftools )
	sys-libs/libunwind
"

# LIBDIR is badly hardcoded in main CMakeLists.txt
# Should be replaced by CMAKE_INSTALL_LIBDIR

PATCHES=(
	"${FILESDIR}/spring-105.0-libdir.patch"
	)

src_test() {
	cmake_src_test
}

src_prepare() {
	if use java; then
		java-pkg-opt-2_src_prepare
	else
		cmake_src_prepare
	fi
}

src_configure() {
	local -a mycmakeargs

	# Custom cflags break online play
	if use custom-cflags ; then
		ewarn "\e[1;31m*********************************************************************\e[0m"
		ewarn "You enabled Custom-CFlags! ('custom-cflags' USE flag)"
		ewarn "It's \e[1;31mimpossible\e[0m that this build will work in online play."
		ewarn "Disable it before doing a bugreport."
		ewarn "\e[1;31m*********************************************************************\e[0m"
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

		mycmakeargs+=("-DMARCH_FLAG=$(get-flag march)")
	fi

	# tcmalloc
	mycmakeargs+=(-DUSE_TCMALLOC=$(usex tcmalloc))

	# dxt recompression
	mycmakeargs+=(-DUSE_LIBSQUISH=$(usex bindist no yes))

	# threadpool
	mycmakeargs+=(-DUSE_THREADPOOL=$(usex threaded))

	# LinkingTimeOptimizations
	mycmakeargs+=(-DLTO=$(usex lto))
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
			mycmakeargs+=("-DAI_TYPES=NATIVE")
		fi

		if use !test-ai ; then
			# Don't build example AIs
			mycmakeargs+=("-DAI_EXCLUDE_REGEX='Null|Test'")
		fi
	else
		if use !test-ai ; then
			mycmakeargs+=("-DAI_TYPES=NONE")
		else
			mycmakeargs+=("-DAI_TYPES=NATIVE")
			mycmakeargs+=("-DAI_EXCLUDE_REGEX='^[^N].*AI'")
		fi
	fi

	# Selectivly enable/disable build targets
	for build_type in default headless dedicated
	do
		mycmakeargs+=(-DBUILD_spring-${build_type}=$(usex $build_type))
	done

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
	cmake_src_configure
}

src_compile () {
	cmake_src_compile
}

src_install () {
	cmake_src_install
}

pkg_postinst() {
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}
