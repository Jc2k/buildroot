###############################################################################
#
# osd-saio
#
###############################################################################

OSD_SAIO_VERSION = c482e46
OSD_SAIO_SITE = https://github.com/Jc2k/Super-AIO
OSD_SAIO_SITE_METHOD = git

define OSD_SAIO_INSTALL_INIT_SYSTEMD
	mkdir -p $(TARGET_DIR)/usr/lib/systemd/system/multi-user.target.wants

	$(INSTALL) -D package/osd-saio/osd-saio.service $(TARGET_DIR)/usr/lib/systemd/system/osd-saio.service
	ln -sf ../../../../../usr/lib/systemd/system/osd-saio.service $(TARGET_DIR)/usr/lib/systemd/system/multi-user.target.wants/osd-saio.service

	$(INSTALL) -D package/osd-saio/powerswitch.service $(TARGET_DIR)/usr/lib/systemd/system/powerswitch.service
	ln -sf ../../../../../usr/lib/systemd/system/powerswitch.service $(TARGET_DIR)/usr/lib/systemd/system/multi-user.target.wants/powerswitch.service
endef

define OSD_SAIO_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/release/saio/osd/osd $(TARGET_DIR)/bin/osd
	$(INSTALL) -D $(@D)/release/saio/osd/config.ini $(TARGET_DIR)/etc/osd.ini
	$(SED) 's|/home/pi/Super-AIO/release/saio/osd/|/lib/osd/|g' $(TARGET_DIR)/etc/osd.ini
	$(INSTALL) -d $(TARGET_DIR)/lib/osd
	$(INSTALL) -D $(@D)/release/saio/osd/*.png $(TARGET_DIR)/lib/osd/

	$(INSTALL) -D package/osd-saio/powerswitch.py $(TARGET_DIR)/bin/powerswitch

	$(INSTALL) -D $(@D)/release/saio/saio-osd.py $(TARGET_DIR)/bin/saio-osd.py
	$(SED) 's|^bin_dir .*|bin_dir = "/usr/bin"|g' $(TARGET_DIR)/bin/saio-osd.py
	$(SED) 's|^ini_data_file .*|ini_data_file = "/run/osd.ini"|g' $(TARGET_DIR)/bin/saio-osd.py
	$(SED) 's|^ini_config_file .*|ini_config_file = "/etc/osd.ini"|g' $(TARGET_DIR)/bin/saio-osd.py
	$(SED) 's|^osd_path .*|osd_path = "/usr/bin/osd"|g' $(TARGET_DIR)/bin/saio-osd.py
endef
	
$(eval $(generic-package))
