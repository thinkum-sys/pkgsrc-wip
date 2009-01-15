# $NetBSD: buildlink3.mk,v 1.1.1.1 2009/01/15 22:59:12 phonohawk Exp $

BUILDLINK_DEPTH:=		${BUILDLINK_DEPTH}+
HASKELL_SRC_BUILDLINK3_MK:=	${HASKELL_SRC_BUILDLINK3_MK}+

.if ${BUILDLINK_DEPTH} == "+"
BUILDLINK_DEPENDS+=	haskell-src
.endif

BUILDLINK_PACKAGES:=	${BUILDLINK_PACKAGES:Nhaskell-src}
BUILDLINK_PACKAGES+=	haskell-src
BUILDLINK_ORDER:=	${BUILDLINK_ORDER} ${BUILDLINK_DEPTH}haskell-src

.if ${HASKELL_SRC_BUILDLINK3_MK} == "+"
BUILDLINK_DEPMETHOD.haskell-src?=	build
BUILDLINK_API_DEPENDS.haskell-src+=	haskell-src>=1.0.1.3
BUILDLINK_PKGSRCDIR.haskell-src?=	../../wip/haskell-src
.endif	# HASKELL_SRC_BUILDLINK3_MK

BUILDLINK_DEPTH:=		${BUILDLINK_DEPTH:S/+$//}
