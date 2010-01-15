# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/embassy-iprscan/embassy-iprscan-4.3.1-r1.ebuild,v 1.1 2009/09/01 21:34:12 ribosome Exp $

EBOV="6.1.0"

inherit embassy

DESCRIPTION="InterProScan motif detection add-on package for EMBOSS"
SRC_URI="ftp://emboss.open-bio.org/pub/EMBOSS/EMBOSS-${EBOV}.tar.gz
	mirror://gentoo/embassy-${EBOV}-${PN:8}-${PV}.tar.gz"

KEYWORDS="~amd64-linux ~x86-linux ~ppc-macos"