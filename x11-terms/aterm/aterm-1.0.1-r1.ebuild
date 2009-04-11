# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/aterm/aterm-1.0.1-r1.ebuild,v 1.11 2008/09/10 15:06:07 darkside Exp $

inherit flag-o-matic

DESCRIPTION="A terminal emulator with transparency support as well as rxvt backwards compatibility"
HOMEPAGE="http://aterm.sourceforge.net"
SRC_URI="ftp://ftp.afterstep.org/apps/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris"
IUSE="background cjk xgetdefault"

RDEPEND="media-libs/jpeg
	media-libs/libpng
	background? ( x11-wm/afterstep )
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libICE"

DEPEND="${RDEPEND}
	x11-libs/libXt
	x11-proto/xproto"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Security bug #219746
	epatch "${FILESDIR}/${P}-display-security-issue.patch"
}

src_compile() {
	local myconf

	use cjk && myconf="$myconf
		--enable-kanji
		--enable-thai
		--enable-big5"

	case "${CHOST}" in
	*-darwin*) myconf="${myconf} --enable-wtmp" ;;
	*-interix*) ;;
	*) myconf="${myconf} --enable-utmp --enable-wtmp"
	esac

	econf \
		$(use_enable xgetdefault) \
		$(use_enable background background-image) \
		--with-terminfo="${EPREFIX}"/usr/share/terminfo \
		--enable-transparency \
		--enable-fading \
		--enable-background-image \
		--enable-menubar \
		--enable-graphics \
		--with-x \
		${myconf} || die "econf failed"

	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"

	fowners root:utmp /usr/bin/aterm
	fperms g+s /usr/bin/aterm

	doman doc/aterm.1
	dodoc ChangeLog doc/FAQ doc/README.*
	docinto menu
	dodoc doc/menu/*
	dohtml -r .
}

pkg_postinst() {
	echo
	ewarn "The transparent background will only work if you have the 'real'"
	ewarn "root wallpaper set. Some tools that might help include: Esetroot"
	ewarn "(x11-terms/eterm), wmsetbg (x11-wm/windowmaker), and/or"
	ewarn "media-gfx/feh."
	echo
}
