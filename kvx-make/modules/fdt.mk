# SPDX-License-Identifier: GPL-2.0-only

ifeq ($(fdt_included),)

fdt_included := 1

################################################################################
#				  DTB
################################################################################

__dtbs := $(sort $(dtb-bin))

__existing_dtbs	:= $(foreach m,$(__dtbs),\
		   $(if $($(m)-dts),$(m)))

__all_dtbs := $(__existing_dtbs)

DTS_PP_FLAGS := -E -nostdinc -undef -D__DTS__ -x assembler-with-cpp

# dtbs generation rule
quiet_cmd_dtbs-gen = DTC \t\t$@
      cmd_dtbs-gen = set -o pipefail && $(HOSTCC) $($(2)_cpp_includes) $(depgencmd) $($(2)-gcc-flags) $(DTS_PP_FLAGS) -o - $< | \
			$(DTC) $($(2)_dtc_includes) $(dtc-flags) $($(2)-flags) -I dts -O $($(2)-of) -o $@

# Lookup for dtc output format
dts-of = dts
dtsi-of = dts
dtb-of = dtb

#####################################################
# Generates dtb rules
# $(1) = target name
#####################################################
define dtbs_gen_rules

$(if $($(1)-dts),,$(error $(1)-dts must be defined to generate device tree))

$(1)-target ?= dtb
$(1)-name ?= $(1).$$($(1)-target)
$(1)-of ?= $$($$($(1)-target)-of)

# build directory for this binary
$(1)_build_dir := $(_gen_build_dir)
$(1)_cpp_includes = $(foreach _inc,$($(1)-includes), -I$(_inc))
$(1)_dtc_includes = $(foreach _inc,$($(1)-includes), -i$(_inc))

$(O)/$$($(1)-of)/$$($(1)-name): $($(1)-dts) $$($(1)-deps) $(O)/$$($(1)-of)/$$(dir $$($(1)-name))/.dirstamp FORCE
	$$(call build_if_changed,dtbs-gen,$(1))

PHONY += $(1)
$(1): $(O)/$$($(1)-of)/$$($(1)-name) FORCE

module_obj_hooks += $(O)/$$($(1)-of)/$$($(1)-name)
endef

module_clean_files += $(DTB_DIR)

$(foreach _dtb,$(__all_dtbs), $(eval $(call dtbs_gen_rules,$(_dtb))))

endif
