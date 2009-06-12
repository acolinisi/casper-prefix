# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/apr/apr-1.3.5.ebuild,v 1.5 2009/06/11 14:19:43 klausman Exp $

EAPI="2"

inherit autotools eutils libtool multilib

DESCRIPTION="Apache Portable Runtime Library"
HOMEPAGE="http://apr.apache.org/"
SRC_URI="mirror://apache/apr/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="1"
KEYWORDS="~ppc-aix ~x86-freebsd ~ia64-hpux ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="debug doc +urandom"
RESTRICT="test"

DEPEND="doc? ( app-doc/doxygen )"
RDEPEND=""

src_prepare() {
	AT_M4DIR="build" eautoreconf
	elibtoolize

	epatch "${FILESDIR}/config.layout.patch"
}

src_configure() {
	local myconf

	[[ ${CHOST} == *-interix* ]] && export ac_cv_func_poll=no
	[[ ${CHOST} == *-mint* ]] && export ac_cv_func_poll=no

	if use debug; then
		myconf+=" --enable-maintainer-mode --enable-pool-debug=all"
	fi

	if use urandom; then
		myconf+=" --with-devrandom=/dev/urandom"
	else
		myconf+=" --with-devrandom=/dev/random"
	fi

	[[ ${CHOST} == *-mint* ]] && myconf="${myconf} --disable-dso"

	# shl_load does not search runpath, but hpux11 supports dlopen
	[[ ${CHOST} == *-hpux11* ]] && myconf="${myconf} --enable-dso=dlfcn"

	if [[ ${CHOST} == *-solaris2.10 ]]; then
		case $(<$([[ ${CHOST} != ${CBUILD} ]] && echo "${EPREFIX}/usr/${CHOST}")/usr/include/atomic.h) in
		*atomic_cas_ptr*) ;;
		*)
			elog "You do not have Solaris Patch ID "$(
				[[ ${CHOST} == sparc* ]] && echo 118884 || echo 118885
			)" (Problem 4954703) installed on your host ($(hostname)),"
			elog "using generic atomic operations instead."
			myconf="${myconf} --disable-nonportable-atomics"
			;;
		esac
	fi

	econf --enable-layout=gentoo \
		--enable-nonportable-atomics \
		--enable-threads \
		${myconf}

	local g=
	[[ ${CHOST} == *-darwin* ]] && g=g

	# Make sure we use the system libtool.
	sed -i 's,$(apr_builddir)/libtool,'"${EPREFIX}"'/usr/bin/'"${g}"'libtool,' build/apr_rules.mk
	sed -i 's,${installbuilddir}/libtool,'"${EPREFIX}"'/usr/bin/'"${g}"'libtool,' apr-1-config
	rm -f libtool
}

src_compile() {
	emake || die "emake failed"

	if use doc; then
		emake dox || die "emake dox failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc CHANGES NOTICE

	if use doc; then
		dohtml docs/dox/html/* || die "dohtml failed"
	fi

	# This file is only used on AIX systems, which Gentoo is not,
	# and causes collisions between the SLOTs, so remove it.
	rm -f "${ED}usr/$(get_libdir)/apr.exp"
}
