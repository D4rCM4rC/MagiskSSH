$(eval $(call start_package))
RSYNC?=rsync-3.1.2

PACKAGE:=rsync

ARCHIVE_NAME:=$(RSYNC).tar.gz
DOWNLOAD_URL:=https://download.samba.org/pub/rsync/src/$(ARCHIVE_NAME)

define pkg-targets
$(BUILD_DIR)/$(PACKAGE)/stamp.configured: $(SRC_DIR)/$(PACKAGE)/stamp.prepared
	mkdir -p $(BUILD_DIR)/$(PACKAGE)
	cd "$(BUILD_DIR)/$(PACKAGE)";                                  \
	$(SRC_DIR)/$(PACKAGE)/$(RSYNC)/configure                       \
	  --build x86_64-pc-linux-gnu --host $(CROSS)                  \
	  CFLAGS="$(CFLAGS)" CPPFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)"
	$(make-configured-stamp)
endef

$(eval $(package))