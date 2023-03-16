# SPDX-License-Identifier: GPL-2.0-only

ifneq ($(module_included_end),)
ifeq ($(machine_included),)

machine_included := 1

machine-soc ?= kv3-1
machine-arch ?= $(arch)

__machine_cflags = -I$(KALRAY_TOOLCHAIN_DIR)/kvx-$(1)/include/machine/$(machine-arch)/$(machine-soc)/cluster/
__machine_cppflags = -I$(KALRAY_TOOLCHAIN_DIR)/kvx-$(1)/include/machine/$(machine-arch)/$(machine-soc)/cluster/

# In order to add specific flag for a flavor, add the following lines:
# __machine-mppa-3-80-extra_cflags := my_flags_for_mppa-3-80
# __machine-cip-extra_cflags := my_flags_for_cip
#

# Add machine include path based on arch/soc
# $1 = Target name
define machine_add_flags

$(if $(findstring mbr,$($($(1)-system)_toolchain_name)),,$(error only mbr system is supported with machine module))

$(1)-cflags += $(call __machine_cppflags,$($($(1)-system)_toolchain_name)) $(__machine-$(machine-soc)-extra_cflags)
$(1)-cppflags += $(call __machine_cppflags,$($($(1)-system)_toolchain_name)) $(__machine-$(machine-soc)-extra_cppflags)

endef

$(foreach _b,$(cluster-bin) $(cluster-lib),\
	$(eval $(call machine_add_flags,$(_b)))\
)

endif
endif
