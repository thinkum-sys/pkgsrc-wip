# $NetBSD: buildlink3.mk,v 1.5 2011/06/30 11:08:25 reinoudz70 Exp $

BUILDLINK_TREE+=	xfce4-fsguard-plugin

.if !defined(XFCE4_FSGUARD_PLUGIN_BUILDLINK3_MK)
XFCE4_FSGUARD_PLUGIN_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.xfce4-fsguard-plugin+=	xfce4-fsguard-plugin>=1.0.0
BUILDLINK_ABI_DEPENDS.xfce4-fsguard-plugin?=	xfce4-fsguard-plugin>=1.0.0
BUILDLINK_PKGSRCDIR.xfce4-fsguard-plugin?=	../../wip/xfce4-fsguard-plugin

.include "../../wip/xfce4-panel/buildlink3.mk"
.include "../../devel/glib2/buildlink3.mk"
.endif # XFCE4_FSGUARD_PLUGIN_BUILDLINK3_MK

BUILDLINK_TREE+=	-xfce4-fsguard-plugin
