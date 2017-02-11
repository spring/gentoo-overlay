# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

if [[ ${PV} = 9999* ]]; then
	GIT_ECLASS="git-2"
	EGIT_REPO_URI="git://github.com/spring/pr-downloader.git"
	EGIT_BRANCH="master"
else
	SRC_URI="https://github.com/downloads/abma/pr-downloader/${PN}-${PV}.7z"
	KEYWORDS="~amd64 ~x86"
fi

inherit games cmake-utils eutils fdo-mime flag-o-matic games ${GIT_ECLASS}

DESCRIPTION="A content download for the Spring RTS engine"
HOMEPAGE="https://github.com/spring/pr-downloader"
S="${WORKDIR}/${PN}_${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="nomirror"


DEPEND="
	dev-libs/libzip
	net-misc/curl
"


src_test() {
	cmake-utils_src_test
}


src_configure() {
	cmake-utils_src_configure
}

src_compile () {
	cmake-utils_src_compile
}

src_install () {
	cmake-utils_src_install
}

pkg_postinst() {
	fdo-mime_mime_database_update
	games_pkg_postinst
}
