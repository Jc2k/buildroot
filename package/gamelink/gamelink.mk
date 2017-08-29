GAMELINK_SITE_METHOD = local
GAMELINK_SITE = package/gamelink
GAMELINK_LICENSE = MIT

define GAMELINK_CONFIGURE_CMDS
endef

define GAMELINK_BUILD_CMDS
endef

define GAMELINK_INSTALL_TARGET_CMDS
	$(INSTALL) -D package/gamelink/gamelink.rules $(TARGET_DIR)/etc/udev/rules.d/gamelink.rules
	$(INSTALL) -D package/gamelink/gamelink.link $(TARGET_DIR)/usr/lib/systemd/network/gamelink.link
	$(INSTALL) -D package/gamelink/gamelink.network $(TARGET_DIR)/usr/lib/systemd/network/gamelink.network
endef

$(eval $(generic-package))
