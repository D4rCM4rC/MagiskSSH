$(eval $(call start_package))
OPENSSL?=openssl-1.0.2l

PACKAGE:=openssl

ARCHIVE_NAME:=$(OPENSSL).tar.gz
DOWNLOAD_URL:=https://www.openssl.org/source/$(ARCHIVE_NAME)

define pkg-targets
$(BUILD_DIR)/$(PACKAGE)/stamp.configured: $(SRC_DIR)/$(PACKAGE)/stamp.prepared
	mkdir -p $(BUILD_DIR)/$(PACKAGE)
	cp -R "$(SRC_DIR)/$(PACKAGE)/$(OPENSSL)/." "$(BUILD_DIR)/$(PACKAGE)"
	cd "$(BUILD_DIR)/$(PACKAGE)"; CC=$(CC) LD=$(LD) AS=$(AS) AR=$(AR) ./Configure -DOPENSSL_NO_HEARTBEATS shared "linux-$(OPENSSL_ARCH)" $(CFLAGS) $(LDFLAGS)
	$(make-configured-stamp)
endef

$(eval $(package))