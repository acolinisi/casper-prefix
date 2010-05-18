# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/usbutils/usbutils-0.87.ebuild,v 1.2 2010/04/25 18:02:09 aballier Exp $

EAPI="2"

inherit eutils autotools

DESCRIPTION="USB enumeration utilities"
HOMEPAGE="http://linux-usb.sourceforge.net/"
SRC_URI="mirror://kernel/linux/utils/usb/usbutils/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64-linux ~x86-linux"
IUSE="network-cron zlib"

RDEPEND="virtual/libusb:0
	zlib? ( sys-libs/zlib )"
DEPEND="${DEPEND}
	dev-util/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.87-fbsd.patch #275052 #316671
	sed -i '/^pkgconfigdir/s:datadir:datarootdir:' Makefile.am #287206
	eautoreconf
}

src_configure() {
	econf \
		--datarootdir="${EPREFIX}"/usr/share \
		--datadir="${EPREFIX}"/usr/share/misc \
		$(use_enable zlib)
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	mv "${ED}"/usr/sbin/update-usbids{.sh,} || die
	newbin "${FILESDIR}"/usbmodules.sh usbmodules || die
	dodoc AUTHORS ChangeLog NEWS README

	use network-cron || return 0
	exeinto /etc/cron.monthly
	cp "${FILESDIR}"/usbutils.cron "${T}"
	sed -i -e "s|exec /|exec ${EPREFIX}/|" "${T}"/usbutils.cron || die "sed failed"
	newexe "${T}"/usbutils.cron update-usbids || die
}