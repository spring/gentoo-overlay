# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

ESVN_REPO_URI="http://qtlobby.googlecode.com/svn/trunk/"

inherit games subversion eutils

DESCRIPTION="Qt-Lobby"
HOMEPAGE="http://code.google.com/p/qtlobby/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	x11-libs/qt-gui
	x11-libs/qt-network
"

DEPEND="${RDEPEND}
"

src_prepare () {
	qmake
}


 
