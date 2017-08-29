###############################################################################
#
# libretro-picodrive
#
###############################################################################

LIBRETRO_PICODRIVE_VERSION = cbc93b6
LIBRETRO_PICODRIVE_SITE = git://github.com/libretro/picodrive.git
LIBRETRO_PICODRIVE_GIT_SUBMODULES = YES
LIBRETRO_PICODRIVE_SITE_METHOD = git
LIBRETRO_PICODRIVE_DEPENDENCIES = retroarch

define LIBRETRO_PICODRIVE_BUILD_CMDS
	$(MAKE) -C $(@D)/cpu/cyclone CONFIG_FILE=$(@D)/cpu/cyclone_config.h

	CFLAGS="$(TARGET_CFLAGS)" \
	CXXFLAGS="$(TARGET_CXXFLAGS)" \
	$(MAKE) CXX="$(TARGET_CXX)" \
	CC="$(TARGET_CC)" \
	LD="$(TARGET_LD)" \
	-C $(@D) -f Makefile.libretro platform=raspberrypi
endef

define LIBRETRO_PICODRIVE_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/picodrive_libretro.so \
		$(TARGET_DIR)/usr/lib/libretro/libretro_picodrive.so
endef
	
$(eval $(generic-package))
