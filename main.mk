ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
include $(ROOT_DIR)/helpers.mk

#Configurables
BUILD_DIR?=.
ARCHIVE_DIR?=$(ROOT_DIR)/dl/
SRC_DIR?=$(ROOT_DIR)/src/
ANDROID_ROOT?=/opt/android-ndk
ANDROID_PLATFORM?=android-24
ANDROID_ARCH?=arm64
TRIPLET_ARCH?=aarch64
ANDROID_MARCH?=armv8-a
CFLAGS?=-O3 -pipe -fomit-frame-pointer -fPIE
LDFLAGS?=-pie
CC=$(CROSS)-gcc
LD=$(CROSS)-ld
AS=$(CROSS)-as
AR=$(CROSS)-ar
CROSS?=$(TRIPLET_ARCH)-linux-android
OPENSSL_ARCH?=$(TRIPLET_ARCH)

BUILD_DIR:=$(shell realpath $(BUILD_DIR))
ARCHIVE_DIR:=$(shell realpath $(ARCHIVE_DIR))
SRC_DIR:=$(shell realpath $(SRC_DIR))

#Logic starts here
CFLAGS+=-I$(ANDROID_ROOT)/platforms/$(ANDROID_PLATFORM)/arch-$(ANDROID_ARCH)/usr/include/ --sysroot=$(ANDROID_ROOT)/platforms/$(ANDROID_PLATFORM)/arch-$(ANDROID_ARCH)/ -march=$(ANDROID_MARCH)
LDFLAGS+=-L$(ANDROID_ROOT)/platforms/$(ANDROID_PLATFORM)/arch-$(ANDROID_ARCH)/usr/lib/ --sysroot=$(ANDROID_ROOT)/platforms/$(ANDROID_PLATFORM)/arch-$(ANDROID_ARCH)/
$(eval $(call save_flags))

.PHONY: $(PHONY_TARGET_PREFIX)all
$(PHONY_TARGET_PREFIX)all: build_$(PHONY_TARGET_PREFIX)openssl build_$(PHONY_TARGET_PREFIX)openssh build_$(PHONY_TARGET_PREFIX)rsync

$(eval $(call submk,global_targets.mk))
$(eval $(call submk,openssl.mk))
$(eval $(call submk,openssh.mk))
$(eval $(call submk,rsync.mk))