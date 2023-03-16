# SPDX-License-Identifier: GPL-2.0-only

ifeq ($(buildroot_included),)

buildroot_included := 1

dummy := $(if $(buildroot-image),,$(error buildroot-image is not specified))

br_precompiled_image := $(KALRAY_TOOLCHAIN_DIR)/../kvx-buildroot/$(buildroot-image)/host/usr/kvx-buildroot-linux-uclibc/sysroot/usr/
br_custom_image := $(buildroot-image)/host/usr/kvx-buildroot-linux-uclibc/sysroot/usr/

_br_image_dir := \
$(strip \
	$(if $(wildcard $(br_custom_image)), \
		$(br_custom_image), \
		$(if $(wildcard $(br_precompiled_image)), \
			$(br_precompiled_image), \
			$(error Buildroot image $(buildroot-image) is not a precompiled buildroot image nor a custom buildroot path) \
		) \
	)\
)

cluster-lflags += -L$(_br_image_dir)/lib/
cluster-cflags += -I$(_br_image_dir)/include/
cluster-cppflags += -I$(_br_image_dir)/include/

cluster-system := linux

endif
