# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/pgf/pgf-2.00.ebuild,v 1.11 2009/05/30 07:14:59 ulm Exp $

inherit latex-package

DESCRIPTION="pgf -- The TeX Portable Graphic Format"
HOMEPAGE="http://sourceforge.net/projects/pgf"
SRC_URI="mirror://sourceforge/pgf/${P}.tar.gz"

LICENSE="GPL-2 LPPL-1.3c FDL-1.2"
SLOT="0"
KEYWORDS="~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="doc"

DEPEND="dev-texlive/texlive-latexrecommended
	>=dev-tex/xcolor-2.11"

TEXMF="/usr/share/texmf-site"

src_install() {
	insinto ${TEXMF}/tex/
	doins -r generic latex plain context || die "Failed installing"

	cd "${S}/doc/generic/pgf"
	dodoc AUTHORS ChangeLog README TODO licenses/LICENSE
	if use doc ; then
		insinto /usr/share/doc/${PF}
		doins pgfmanual.pdf
		doins -r images macros text-en version-for-dvipdfm version-for-dvips \
			version-for-pdftex version-for-tex4ht version-for-vtex || die \
			"Failed to install documentation"
	fi
}
