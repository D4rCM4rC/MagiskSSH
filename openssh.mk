$(eval $(call start_package))
OPENSSH?=openssh-7.5p1

PACKAGE=openssh

ARCHIVE_NAME:=$(OPENSSH).tar.gz
#TODO: randomly select mirror?
DOWNLOAD_URL:=ftp://mirror.hs-esslingen.de/pub/OpenBSD/OpenSSH/portable/$(ARCHIVE_NAME)

CFLAGS+=-I$(BUILD_DIR)/openssl/include
LDFLAGS+=-L$(BUILD_DIR)/openssl/

PACKAGE_WANT_PREPARE=true

define pkg-targets
$(BUILD_DIR)/$(PACKAGE)/stamp.configured: $(SRC_DIR)/$(PACKAGE)/stamp.prepared $(call depend-built,openssl)
	mkdir -p $(BUILD_DIR)/$(PACKAGE)
	cd "$(BUILD_DIR)/$(PACKAGE)";                                                          \
	$(SRC_DIR)/$(PACKAGE)/$(OPENSSH)/configure --build x86_64-pc-linux-gnu --host $(CROSS) \
	  CFLAGS="$(CFLAGS)" CPPFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)"                         \
	  --disable-utmpx --disable-utmp --disable-wtmp --disable-wtmpx                        \
	  --sysconfdir=/data/ssh --with-pid-dir=/data/ssh                                      \
	  --with-default-path="/system/bin:/system/xbin:/system/sbin:/magisk/sshd/usr/bin"     \
	  --with-superuser-path="/system/bin:/system/xbin:/system/sbin:/magisk/sshd/usr/bin"
	sed -i -e 's:/\* #undef HAVE_MBLEN \*/:#define HAVE_MBLEN 1:'                          \
	       -e 's:/\* #undef HAVE_ENDGRENT \*/:#define HAVE_ENDGRENT 1:'                    \
	    $(BUILD_DIR)/$(PACKAGE)/config.h
	$(make-configured-stamp)


ifneq ($(IS_SRC_$(PACKAGE)_TARGET_PREPARED),true)
IS_SRC_$(PACKAGE)_TARGET_PREPARED:=true
$(SRC_DIR)/$(PACKAGE)/stamp.prepared: $(SRC_DIR)/$(PACKAGE)/stamp.unpacked
	cd "$(SRC_DIR)/$(PACKAGE)/$(OPENSSH)"; patch -p1 < "$(ROOT_DIR)/patches/$(OPENSSH).patch"
	$(make-prepared-stamp)
endif
endef

$(eval $(package))