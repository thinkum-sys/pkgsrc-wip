# $NetBSD: buildlink3.mk,v 1.1.1.1 2005/06/21 18:59:34 marttikuparinen Exp $

BUILDLINK_DEPTH:=	${BUILDLINK_DEPTH}+
LIBXEN_BUILDLINK3_MK:=	${LIBXEN_BUILDLINK3_MK}+

.if !empty(BUILDLINK_DEPTH:M+)
BUILDLINK_DEPENDS+=	libxen
.endif

BUILDLINK_PACKAGES:=	${BUILDLINK_PACKAGES:Nlibxen}
BUILDLINK_PACKAGES+=	libxen

.if !empty(LIBXEN_BUILDLINK3_MK:M+)
BUILDLINK_DEPENDS.libxen+=	libxen>=2.0.6
BUILDLINK_PKGSRCDIR.libxen?=	../../wip/libxen
.endif	# LIBXEN_BUILDLINK3_MK

BUILDLINK_DEPTH:=     ${BUILDLINK_DEPTH:S/+$//}
