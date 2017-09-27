#define package
#	include $(ROOT_DIR)/package.mk
#endef

define submk
	include $(ROOT_DIR)/$(1)
endef

define save_flags
	SAVED_CFLAGS=$(CFLAGS)
	SAVED_LDFLAGS=$(LDFLAGS)
	SAVED_CC=$(CC)
	SAVED_LD=$(LD)
	SAVED_AR=$(AR)
	SAVED_AS=$(AS)
endef

define start_package
	CFLAGS:=$(SAVED_CFLAGS)
	LDFLAGS:=$(SAVED_LDFLAGS)
	CC:=$(SAVED_CC)
	LD:=$(SAVED_LD)
	AR:=$(SAVED_AR)
	AS:=$(SAVED_AS)
	PACKAGE=
	ARCHIVE_NAME=
	DOWNLOAD_URL=
	PACKAGE_WANT_PREPARE=
	pkg-targets=
endef

$(eval $(call submk,package.mk))