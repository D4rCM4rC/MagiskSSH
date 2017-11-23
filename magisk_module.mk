$(eval $(call start_package)) # not really a package, but we may reset stuff just in case

MAGISK_TEMPLATE_VERSION?=1400

.PHONY: module
module: $(BUILD_DIR)/magisk_ssh-$(VERSION).zip

$(ARCHIVE_DIR)/magisk_template-$(MAGISK_TEMPLATE_VERSION).tar.gz: $(ARCHIVE_DIR)
	wget -O $(ARCHIVE_DIR)/magisk_template-$(MAGISK_TEMPLATE_VERSION).tar.gz --no-use-server-timestamps "https://github.com/topjohnwu/magisk-module-template/archive/$(MAGISK_TEMPLATE_VERSION).tar.gz"
	# No checksum verification, as GitHub may recreate archives which changes its checksum

$(BUILD_DIR)/module/stamp.module-extracted: $(ARCHIVE_DIR)/magisk_template-$(MAGISK_TEMPLATE_VERSION).tar.gz
	mkdir -p $(BUILD_DIR)/module/magisk_ssh
	tar -xvf "$(ARCHIVE_DIR)/magisk_template-$(MAGISK_TEMPLATE_VERSION).tar.gz" -C "$(BUILD_DIR)/module/magisk_ssh" --strip 1
	rm $(BUILD_DIR)/module/magisk_ssh/system/placeholder
	touch $(BUILD_DIR)/module/stamp.module-extracted

$(BUILD_DIR)/module/stamp.module-prop: $(BUILD_DIR)/module/stamp.module-extracted
	cp $(ROOT_DIR)/module_data/module.prop $(BUILD_DIR)/module/magisk_ssh
	touch $(BUILD_DIR)/module/stamp.module-prop

$(BUILD_DIR)/module/stamp.module-readme: $(BUILD_DIR)/module/stamp.module-extracted
	cp $(ROOT_DIR)/module_data/README.md $(BUILD_DIR)/module/magisk_ssh
	touch $(BUILD_DIR)/module/stamp.module-readme

$(BUILD_DIR)/module/stamp.module-config: $(BUILD_DIR)/module/stamp.module-extracted
	$(ROOT_DIR)/module_data/modify_config.py $(BUILD_DIR)/module/magisk_ssh/config.sh
	touch $(BUILD_DIR)/module/stamp.module-config

$(BUILD_DIR)/module/stamp.module-sshdconfig: $(BUILD_DIR)/module/stamp.module-extracted
	cp $(ROOT_DIR)/module_data/sshd_config $(BUILD_DIR)/module/magisk_ssh/common/
	touch $(BUILD_DIR)/module/stamp.module-sshdconfig

$(BUILD_DIR)/module/stamp.module-service: $(BUILD_DIR)/module/stamp.module-extracted
	cp -f $(ROOT_DIR)/module_data/service.sh $(BUILD_DIR)/module/magisk_ssh/common/
	touch $(BUILD_DIR)/module/stamp.module-service

$(BUILD_DIR)/module/stamp.module-binaries: $(BUILD_DIR)/module/stamp.module-extracted \
                                           $(INSTALLED_FILES_arm)                     \
                                           $(INSTALLED_FILES_arm64)                   \
                                           $(INSTALLED_FILES_x86)                     \
                                           $(INSTALLED_FILES_x86_64)                  \
                                           $(INSTALLED_FILES_mips)                    \
                                           $(INSTALLED_FILES_mips64)
	cp -r $(BUILD_DIR)/arm/usr    $(BUILD_DIR)/module/magisk_ssh/common/arm
	cp -r $(BUILD_DIR)/arm64/usr  $(BUILD_DIR)/module/magisk_ssh/common/arm64
	cp -r $(BUILD_DIR)/x86/usr    $(BUILD_DIR)/module/magisk_ssh/common/x86
	cp -r $(BUILD_DIR)/x86_64/usr $(BUILD_DIR)/module/magisk_ssh/common/x86_64
	cp -r $(BUILD_DIR)/mips/usr   $(BUILD_DIR)/module/magisk_ssh/common/mips
	cp -r $(BUILD_DIR)/mips64/usr $(BUILD_DIR)/module/magisk_ssh/common/mips64
	touch $(BUILD_DIR)/module/stamp.module-binaries

$(BUILD_DIR)/module/stamp.module-initscript: $(BUILD_DIR)/arm/openssh/stamp.built       \
                                             $(BUILD_DIR)/module/stamp.module-extracted
	sed -e 's:#!/bin/sh:#!/system/bin/sh:'         \
	    -e 's#=/bin#=/system/bin#'                 \
	    -e 's#.*PidFile.*##'                       \
	    -e 's#sbin#bin#'                           \
	    -e 's#^prefix=.*#: $${MODDIR:=/magisk/ssh}\nexport LD_LIBRARY_PATH=\"$$MODDIR/usr/lib\"\nprefix=\"$$MODDIR/usr\"#' \
	    -e 's#@COMMENT_OUT_RSA1@.*##'              \
	    $(BUILD_DIR)/arm/openssh/opensshd.init     \
	    > $(BUILD_DIR)/module/magisk_ssh/common/opensshd.init
	touch $(BUILD_DIR)/module/stamp.module-initscript

$(BUILD_DIR)/module/stamp.module: $(BUILD_DIR)/module/stamp.module-extracted  \
                                  $(BUILD_DIR)/module/stamp.module-prop       \
                                  $(BUILD_DIR)/module/stamp.module-readme     \
                                  $(BUILD_DIR)/module/stamp.module-config     \
                                  $(BUILD_DIR)/module/stamp.module-binaries   \
                                  $(BUILD_DIR)/module/stamp.module-sshdconfig \
                                  $(BUILD_DIR)/module/stamp.module-service    \
                                  $(BUILD_DIR)/module/stamp.module-initscript
	touch $(BUILD_DIR)/module/stamp.module

$(BUILD_DIR)/magisk_ssh_$(VERSION).zip: $(BUILD_DIR)/module/stamp.module
	rm -f $(BUILD_DIR)/magisk_ssh_$(VERSION).zip
	cd $(BUILD_DIR)/module/magisk_ssh; zip -9 -r $(shell realpath $(BUILD_DIR)/magisk_ssh_$(VERSION).zip) *

.PHONY: zip
zip: $(BUILD_DIR)/magisk_ssh_$(VERSION).zip