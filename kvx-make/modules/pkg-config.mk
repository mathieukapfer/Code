# SPDX-License-Identifier: GPL-2.0-only

ifeq ($(pkg_config_included),)

pkg_config_included := 1

PKG_CONFIG ?= pkg-config

pkg_config_call = $(shell $(PKG_CONFIG) --define-variable=kvxtools_prefix=$(KALRAY_TOOLCHAIN_DIR) $(1))

pkg_config_cflags = $(call pkg_config_call,--cflags $(1))
pkg_config_lflags = $(call pkg_config_call,--libs $(1))

# Fetch flags from pkg config and add them to the build line of target
# $1 = Target name
# $2 = Lib to add
define pkg_config_add


$(1)-cflags += $(call pkg_config_cflags,$(2))
$(1)-cppflags += $(call pkg_config_cflags,$(2))
$(1)-lflags += $(call pkg_config_lflags,$(2))

endef

$(foreach _b,$(host-bin) $(host-lib) $(cluster-bin) $(cluster-lib),\
	$(foreach __pkg,$($(_b)-pkg-config),\
		$(eval $(call pkg_config_add,$(_b),$(__pkg)))\
	)\
)

endif
