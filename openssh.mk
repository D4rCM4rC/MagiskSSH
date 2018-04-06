$(eval $(call start_package))
OPENSSH?=openssh-7.7p1

PACKAGE=openssh

ARCHIVE_NAME:=$(OPENSSH).tar.gz
#TODO: randomly select mirror?
DOWNLOAD_URL:=ftp://mirror.hs-esslingen.de/pub/OpenBSD/OpenSSH/portable/$(ARCHIVE_NAME)

CFLAGS+=-I$(BUILD_DIR)/openssl/include
LDFLAGS+=-L$(BUILD_DIR)/openssl/

PACKAGE_INSTALLED_FILES:= $(BUILD_DIR)/usr/bin/ssh         \
                          $(BUILD_DIR)/usr/bin/sshd        \
                          $(BUILD_DIR)/usr/bin/sftp        \
                          $(BUILD_DIR)/usr/bin/scp         \
                          $(BUILD_DIR)/usr/bin/sftp-server \
                          $(BUILD_DIR)/usr/bin/ssh-keygen

PACKAGE_WANT_PREPARE=true

define pkg-targets
$(BUILD_DIR)/$(PACKAGE)/stamp.configured: $(SRC_DIR)/$(PACKAGE)/stamp.prepared $(call depend-built,openssl)
	mkdir -p $(BUILD_DIR)/$(PACKAGE)
	cd "$(BUILD_DIR)/$(PACKAGE)";                                                          \
	$(SRC_DIR)/$(PACKAGE)/$(OPENSSH)/configure --build x86_64-pc-linux-gnu --host $(CROSS) \
	  CFLAGS="$(CFLAGS)" CPPFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)"                         \
	  --disable-utmpx --disable-utmp --disable-wtmp --disable-wtmpx                        \
	  --sysconfdir=/data/ssh --with-pid-dir=/data/ssh                                      \
	  --with-default-path="/system/bin:/system/xbin:/system/sbin:/magisk/ssh/usr/bin"      \
	  --with-superuser-path="/system/bin:/system/xbin:/system/sbin:/magisk/ssh/usr/bin"
	sed -i -e 's:/\* #undef HAVE_MBLEN \*/:#define HAVE_MBLEN 1:'                          \
	       -e 's:/\* #undef HAVE_ENDGRENT \*/:#define HAVE_ENDGRENT 1:'                    \
	       -e 's:/\* #undef HAVE_BZERO \*/:#define HAVE_BZERO 1:'                          \
	    $(BUILD_DIR)/$(PACKAGE)/config.h
	$(make-configured-stamp)


ifneq ($(IS_SRC_$(PACKAGE)_TARGET_PREPARED),true)
IS_SRC_$(PACKAGE)_TARGET_PREPARED:=true
$(SRC_DIR)/$(PACKAGE)/stamp.prepared: $(SRC_DIR)/$(PACKAGE)/stamp.unpacked
	cd "$(SRC_DIR)/$(PACKAGE)/$(OPENSSH)"; patch -p1 < "$(ROOT_DIR)/patches/$(OPENSSH).patch"
	$(make-prepared-stamp)
endif

$(BUILD_DIR)/usr/bin/ssh: $(BUILD_DIR)/$(PACKAGE)/stamp.built
	mkdir -p $(BUILD_DIR)/usr/bin/
	cp -u "$(BUILD_DIR)/$(PACKAGE)/ssh" "$(BUILD_DIR)/usr/bin/"

$(BUILD_DIR)/usr/bin/sshd: $(BUILD_DIR)/$(PACKAGE)/stamp.built
	mkdir -p $(BUILD_DIR)/usr/bin/
	cp -u "$(BUILD_DIR)/$(PACKAGE)/sshd" "$(BUILD_DIR)/usr/bin/"

$(BUILD_DIR)/usr/bin/sftp: $(BUILD_DIR)/$(PACKAGE)/stamp.built
	mkdir -p $(BUILD_DIR)/usr/bin/
	cp -u "$(BUILD_DIR)/$(PACKAGE)/sftp" "$(BUILD_DIR)/usr/bin/"

$(BUILD_DIR)/usr/bin/scp: $(BUILD_DIR)/$(PACKAGE)/stamp.built
	mkdir -p $(BUILD_DIR)/usr/bin/
	cp -u "$(BUILD_DIR)/$(PACKAGE)/scp" "$(BUILD_DIR)/usr/bin/"

$(BUILD_DIR)/usr/bin/sftp-server: $(BUILD_DIR)/$(PACKAGE)/stamp.built
	mkdir -p $(BUILD_DIR)/usr/bin/
	cp -u "$(BUILD_DIR)/$(PACKAGE)/sftp-server" "$(BUILD_DIR)/usr/bin/"

$(BUILD_DIR)/usr/bin/ssh-keygen: $(BUILD_DIR)/$(PACKAGE)/stamp.built
	mkdir -p $(BUILD_DIR)/usr/bin/
	cp -u "$(BUILD_DIR)/$(PACKAGE)/ssh-keygen" "$(BUILD_DIR)/usr/bin/"

endef

$(eval $(package))