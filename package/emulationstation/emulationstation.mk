################################################################################
#
# Emulation Station
#
################################################################################
EMULATIONSTATION_VERSION = 5725876736e0b611280dbbafd5d944b9739b209d
EMULATIONSTATION_SITE = https://github.com/Jc2k/emulationstation
EMULATIONSTATION_SITE_METHOD = git
EMULATIONSTATION_LICENSE = MIT
EMULATIONSTATION_DEPENDENCIES = sdl2 sdl2_mixer boost libfreeimage freetype eigen alsa-lib libgles openssl
EMULATIONSTATION_INSTALL_STAGING = no


define EMULATIONSTATION_RPI_FIXUP
	$(SED) 's|/opt/vc/include|$(STAGING_DIR)/usr/include|g' $(@D)/CMakeLists.txt
	$(SED) 's|/opt/vc/lib|$(STAGING_DIR)/usr/lib|g' $(@D)/CMakeLists.txt
	$(SED) 's|EGL|EGL vchostif GLESv2|g' $(@D)/CMakeLists.txt
endef

EMULATIONSTATION_PRE_CONFIGURE_HOOKS += EMULATIONSTATION_RPI_FIXUP


define EMULATIONSTATION_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D package/emulationstation/emulationstation.service $(TARGET_DIR)/usr/lib/systemd/system/emulationstation.service
	mkdir -p $(TARGET_DIR)/usr/lib/systemd/system/multi-user.target.wants
	ln -sf ../../../../../usr/lib/systemd/system/emulationstation.service $(TARGET_DIR)/usr/lib/systemd/system/multi-user.target.wants/emulationstation.service
endef

define EMULATIONSTATION_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/emulationstation $(TARGET_DIR)/usr/bin/emulationstation
	$(INSTALL) -D package/emulationstation/es_systems.cfg $(TARGET_DIR)/etc/emulationstation/es_systems.cfg
	$(INSTALL) -D package/emulationstation/es_input.cfg $(TARGET_DIR)/.emulationstation/es_input.cfg
	rm -rf $(TARGET_DIR)/.emulationstation/themes
	cp -rv package/emulationstation/themes $(TARGET_DIR)/.emulationstation/themes
endef

$(eval $(cmake-package))
