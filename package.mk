
# $(1) PACKAGE
# $(2) ARCHIVE_DIR
# $(3) SRC_DIR
# $(4) BUILD_DIR
# $(5) ARCHIVE_NAME
# $(6) DOWNLOAD_URL
define package
.PHONY: download_$(PACKAGE)
download_$(PACKAGE): $(ARCHIVE_DIR)/$(ARCHIVE_NAME)
.PHONY: unpack$(PHONY_TARGET_PREFIX)_$(PACKAGE)
unpack_$(PACKAGE): $(SRC_DIR)/$(PACKAGE)/stamp.unpacked
.PHONY: prepare_$(PACKAGE)
prepare_$(PACKAGE): $(SRC_DIR)/$(PACKAGE)/stamp.prepared
.PHONY: configure$(PHONY_TARGET_PREFIX)_$(PACKAGE)
configure$(PHONY_TARGET_PREFIX)_$(PACKAGE): $(BUILD_DIR)/$(PACKAGE)/stamp.configured
.PHONY: build$(PHONY_TARGET_PREFIX)_$(PACKAGE)
build$(PHONY_TARGET_PREFIX)_$(PACKAGE): $(BUILD_DIR)/$(PACKAGE)/stamp.built
.PHONY: copy$(PHONY_TARGET_PREFIX)_$(PACKAGE)
copy$(PHONY_TARGET_PREFIX)_$(PACKAGE): $(PACKAGE_INSTALLED_FILES)

$(PACKAGE)_INSTALLED_FILES=$(PACKAGE_INSTALLED_FILES)

$(eval $(pkg-targets))

ifneq ($(IS_ARCHIVE_$(PACKAGE)_TARGET_CREATED),true)
IS_ARCHIVE_$(PACKAGE)_TARGET_CREATED:=true
$(ARCHIVE_DIR)/$(ARCHIVE_NAME): $(ARCHIVE_DIR)
	wget -O $(ARCHIVE_DIR)/$(ARCHIVE_NAME) --no-use-server-timestamps "$(DOWNLOAD_URL)"
	cd "$(ARCHIVE_DIR)";                                                                    \
	sha512sum -c $(ROOT_DIR)/checksums/$(ARCHIVE_NAME).sha512 ||                            \
	(mv "$(ARCHIVE_DIR)/$(ARCHIVE_NAME)" "$(ARCHIVE_DIR)/$(ARCHIVE_NAME).invalid_checksum"; \
	 false)
endif

ifneq ($(IS_SRC_$(PACKAGE)_TARGET_CREATED),true)
IS_SRC_$(PACKAGE)_TARGET_CREATED:=true
$(SRC_DIR)/$(PACKAGE)/stamp.unpacked: $(ARCHIVE_DIR)/$(ARCHIVE_NAME)
	#TODO: verify hash
	mkdir -p "$(SRC_DIR)/$(PACKAGE)/"
	tar -xvf "$(ARCHIVE_DIR)/$(ARCHIVE_NAME)" -C "$(SRC_DIR)/$(PACKAGE)"
	touch $(SRC_DIR)/$(PACKAGE)/stamp.unpacked
endif

ifneq ($(IS_SRC_$(PACKAGE)_TARGET_PREPARED),true)
IS_SRC_$(PACKAGE)_TARGET_PREPARED:=true
ifneq ($(PACKAGE_WANT_PREPARE),true)
$(SRC_DIR)/$(PACKAGE)/stamp.prepared: $(SRC_DIR)/$(PACKAGE)/stamp.unpacked
	touch $(SRC_DIR)/$(PACKAGE)/stamp.prepared
endif
endif

$(BUILD_DIR)/$(PACKAGE)/stamp.built: $(BUILD_DIR)/$(PACKAGE)/stamp.configured
	$(MAKE) -C "$(BUILD_DIR)/$(PACKAGE)"
	touch $(BUILD_DIR)/$(PACKAGE)/stamp.built
endef

make-prepared-stamp=touch $(SRC_DIR)/$(PACKAGE)/stamp.prepared
make-configured-stamp=touch $(BUILD_DIR)/$(PACKAGE)/stamp.configured

depend-built=$(BUILD_DIR)/$(1)/stamp.built