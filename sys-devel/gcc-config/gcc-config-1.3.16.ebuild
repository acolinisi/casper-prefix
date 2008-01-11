# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/gcc-config/gcc-config-1.3.16.ebuild,v 1.10 2007/06/02 11:43:58 armin76 Exp $

EAPI="prefix"

inherit eutils flag-o-matic toolchain-funcs multilib

# Version of .c wrapper to use
W_VER="1.4.8"

DESCRIPTION="Utility to change the gcc compiler being used"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc-aix ~x86-fbsd ~ia64-hpux ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

RDEPEND="!app-admin/eselect-compiler"

S=${WORKDIR}

src_unpack() {
	cp "${FILESDIR}"/wrapper-${W_VER}.c  "${S}/"
	cp "${FILESDIR}"/${PN}-${PV}  "${S}/"${PN}-${PV}
	cd "${S}"
	epatch "${FILESDIR}"/wrapper-${W_VER}-prefix.patch
	eprefixify wrapper-${W_VER}.c ${PN}-${PV}
}

src_compile() {
	strip-flags
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} -Wall -o wrapper \
		wrapper-${W_VER}.c || die "compile wrapper"
}

src_install() {
	newbin ${PN}-${PV} ${PN} || die "install gcc-config"
	sed -i \
		-e "s:PORTAGE-VERSION:${PVR}:g" \
		-e "s:GENTOO_LIBDIR:$(get_libdir):g" \
		"${ED}"/usr/bin/${PN}

	exeinto /usr/$(get_libdir)/misc
	newexe wrapper gcc-config || die "install wrapper"
}

pkg_postinst() {
	# Do we have a valid multi ver setup ?
	if gcc-config --get-current-profile &>/dev/null ; then
		# We not longer use the /usr/include/g++-v3 hacks, as
		# it is not needed ...
		[[ -L ${EROOT}/usr/include/g++ ]] && rm -f "${EROOT}"/usr/include/g++
		[[ -L ${EROOT}/usr/include/g++-v3 ]] && rm -f "${EROOT}"/usr/include/g++-v3
		gcc-config $(${EPREFIX}/usr/bin/gcc-config --get-current-profile)
	fi

	# Make sure old versions dont exist #79062
	rm -f "${EROOT}"/usr/sbin/gcc-config
}
