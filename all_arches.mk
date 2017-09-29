ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
include $(ROOT_DIR)/helpers.mk

BUILD_DIR?=.
BUILD_DIR_ROOT:=$(shell realpath $(BUILD_DIR))
VERSION=0.1


override NO_GLOBAL:=true

# $(1): ANDROID_ARCH (ie. arm64)          -- how android distinguishes architectures
# $(2): TRIPLET_ARCH (ie. aarch64)        -- the architecture as used in the architecture triplet
# $(3): ANDROID_MARCH (ie. armv8-a)       -- an actual 'version' of an arch. Passed to -march
# $(4): CROSS (ie. aarch64-linux-android) -- the full architecture triplet
# $(5): OPENSSL_ARCH (ie. aarch64)        -- this is passed as linux-$(OPENSSL_ARCH) to the openssl configure script
define single-arch

BUILD_DIR=$(BUILD_DIR_ROOT)/$(1)
ANDROID_ARCH:=$(1)
TRIPLET_ARCH:=$(2)
ANDROID_MARCH:=$(3)
CROSS:=$(4)
OPENSSL_ARCH:=$(5)
PHONY_TARGET_PREFIX:=_$(1)
CFLAGS:=
LDFLAGS:=

$(call submk,main.mk)
endef

.DEFAULT_GOAL := module


.PHONY: copy
copy: copy_arm copy_arm64 copy_x86 copy_x86_64 copy_mips copy_mips64

.PHONY: all
all: all_arm all_arm64 all_x86 all_x86_64 all_mips all_mips64

$(eval $(call single-arch,arm,arm,armv7-a,arm-linux-androideabi,armv4))
$(eval $(call single-arch,arm64,aarch64,armv8-a,aarch64-linux-android,aarch64))
$(eval $(call single-arch,x86,i686,i686,i686-linux-android,elf))
$(eval $(call single-arch,x86_64,x86_64,x86-64,x86_64-linux-android,x86_64))
$(eval $(call single-arch,mips,mipsel,mips32,mipsel-linux-android,mips32))
$(eval $(call single-arch,mips64,mips64el,mips64r6,mips64el-linux-android,generic64))

#reset paths
BUILD_DIR:=$(BUILD_DIR_ROOT)
$(eval $(call submk,magisk_module.mk))