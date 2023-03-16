# SPDX-License-Identifier: GPL-2.0-only
#
# mybin-srcs := sources
#
# # Global var
# lopper-conf-soc := $(arch)
#
# # Local var
# dts1-soc := $(arch)
# dts1-dts := <path>/lop-conf-dts1.dts <path>/domain.dts ...
# dts1-includes := <path_to_includes> ...
# dts1-name := dts_output_name
#
# ...
#
# dtsx-soc := $(arch)
# dtsx-dts := <path>/lop-conf-dts1.dts <path>/domain.dts ...
# dtsx-includes := <path_to_includes> ...
# dtsx-name := dts_output_name
#
# lopper-dts := dts1 ... dtsx
#

ifeq ($(lopper_included),)

lopper_included := 1

KALRAY_SDT_PATH ?= $(KALRAY_TOOLCHAIN_DIR)/share/device_trees/sdt/soc/
PYTHONPATH ?= $(KALRAY_TOOLCHAIN_DIR)/lib/python/site-packages
LOPPER_PATH = $(dir $(LOPPER))

lopper-conf-soc ?= $(arch)

__lopper_flags := -f --enhanced --werror $(lopper_flags)

# Lopper generation rule
quiet_cmd_lopper_gen = LOPPER\t\t$@
	cmd_lopper_gen = PATH=$(DTC):$(PATH) LOPPER_PPFLAGS="$($(2)_cpp_includes)" PYTHONPATH=$(PYTHONPATH) $(LOPPER) $(__lopper_flags) -O $(O) \
		$(if $(strip $(V)),-v,) \
		-i $(LOPPER_PATH)/lopper/lops/lop-load-simple.dts \
		$($(2)_dts) \
		$($(2)-soc)\
		$@ \
		$(if $(strip $(Q)),> /dev/null,)

#####################################################
# Generates dts rules
# $(1) = target name
#####################################################
define lopper_gen_rules

$(if $($(1)-dts),,$(error $(1)-dts must be defined to generate device tree))

$(1)-soc ?= $(if $($(1)-soc), \
	$(KALRAY_SDT_PATH)/$($(1)-soc).dts, \
	$(if $($(1)-custom-soc), \
		$($(1)-custom-soc), \
		$(KALRAY_SDT_PATH)/$(lopper-conf-soc).dts \
	) \
)

$(1)-name ?= $(1).dts

$(1)_cpp_includes = $(addprefix -I, $($(1)-includes))
$(1)_dts = $(addprefix -i, $($(1)-dts))

$(DTS_DIR)/$$($(1)-name): $$($(1)-dts) $$($(1)-deps) $$($(1)-soc) $(DTS_DIR)/$$(dir $$($(1)-name))/.dirstamp FORCE
	$$(call build_if_changed,lopper_gen,$(1))

PHONY += $(1)
$(1): $(DTS_DIR)/$$($(1)-name) FORCE

module_main_hooks += $(1)
module_obj_hooks += $(DTS_DIR)/$$($(1)-name)
endef

module_clean_files += $(DTS_DIR) $(O)/*

$(foreach _b,$(lopper-dts),\
	$(if $($(_b)-dts),\
		$(eval $(call lopper_gen_rules,$(_b)))\
	)\
)

endif
