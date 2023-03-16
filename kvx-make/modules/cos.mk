# SPDX-License-Identifier: GPL-2.0-only

# mybin-srcs := sources
#
# # Global var
# cos-conf-soc := $(cos-default-arch)
#
# # Local var
# part1-conf := <path>/lop-conf-cos-part4.dts
# part1-domain := <path>/domain.dts
# part1-soc := $(cos-default-arch)
# part1-linker := my_specific_linker_script
#
# ...
#
# part4-conf := <path>/lop-conf-cos-part4.dts
# part4-domain := <path>/domain.dts
# part4-soc := kv3-1
#
# mybin-cos-conf := part1 part2 part3 part4
#

ifeq ($(cos_included),)

cos_included := 1

cos-default-arch := kv3-1

cos-conf-soc ?= $(cos-default-arch)
cos-conf-linker ?= mppadcos_ddr.ld

KVX_LOPPER_UTIL ?= $(KALRAY_TOOLCHAIN_DIR)/bin/kvx-lopper-util
COS_DTSLD_GEN ?= $(KALRAY_TOOLCHAIN_DIR)/bin/kvx-cos-dtsld-gen-util
KALRAY_SDT_PATH := $(KALRAY_TOOLCHAIN_DIR)/share/device_trees/sdt/soc/
COS_MK_DIR ?= $(KALRAY_TOOLCHAIN_DIR)/share/device_trees/sdt/cos_config/modules/

# Include all predefined COS configuration
include $(COS_MK_DIR)/*.mk

# lopper generation rule (multiple dts-> dts)
quiet_cmd_lopper_gen = LOPPER\t\t$@
      cmd_lopper_gen = PATH=$(KALRAY_TOOLCHAIN_DIR)/bin:$$PATH $(KVX_LOPPER_UTIL) -o $($(2)_gen_dir) \
			$(if $(strip $(V)),-v,) \
			-d $($(3)-domain) \
			-c $($(3)-conf) \
			-s $(KALRAY_SDT_PATH)/$($(3)-soc).dts \
			-p $@ \
			$(if $(strip $(Q)),> /dev/null,)

# dtb generation rule (dts -> dtb)
__dtc_flags = -W no-unit_address_vs_reg -W no-unique_unit_address $(dtc-flags)
quiet_cmd_dtb_gen = DTC\t\t\t$@
      cmd_dtb_gen = $(DTC) $(__dtc_flags) -I dts -O dtb $< -o $@

# cos config generation rule (dtb -> ld)
quiet_cmd_gen_cos_config = COS_DTSLD_GEN\t\t$@
      cmd_gen_cos_config = $(COS_DTSLD_GEN) $< $(2) $(3) \
			   $(if $(strip $(Q)),> /dev/null,)

#
# Generate a cos binary from various dts file
# $(1) = target name
# $(2) = conf name
# This rule will create a new binary suffixed by the conf name
#
define generate_cos_conf

# Check that COS preset conf is supported
$(if $($(2)-preset-conf),$(if $$($(2)-preset-conf)-soc,,$(error Invalid preset-conf $($(2)-preset-conf))))

$(2)-soc ?= $(if $($(2)-preset-conf),$($($(2)-preset-conf)-soc),$(cos-conf-soc))
$(2)-linker ?= $(if $($(2)-preset-conf),$($($(2)-preset-conf)-linker),$(cos-conf-linker))
$(2)-domain ?= $(if $($(2)-preset-conf),$($($(2)-preset-conf)-domain),$(cos-conf-domain))
$(2)-conf ?= $(if $($(2)-preset-conf),$($($(2)-preset-conf)-conf))

$$(if $$($(2)-domain),,$$(error $(2)-domain is empty))

# Use $(1) lflags and append the specific ones for our conf
$(1)-lflags += -Wl,--defsym=MPPA_COS_PARTITION_ENABLED=1

$(1)_gen_dir := $(_gen_gen_dir)

$(1)-lflags += $(if $($(2)-preset-conf),$($($(2)-preset-conf)-lflags),)

$(1)-lflags += -L $$($(1)_gen_dir)/ -T $$($(2)-linker)
$(1)-link-deps += $$($(1)_gen_dir)/geometry_generic.ld

$$($(1)_gen_dir)/$(2).dts: $$($(2)-domain) $$($(2)-conf) $(KALRAY_SDT_PATH)/$$($(2)-soc).dts $$($(1)_gen_dir)/.dirstamp
	$$(call build_if_changed,lopper_gen,$(1),$(2))

$$($(1)_gen_dir)/$(2).dtb: $$($(1)_gen_dir)/$(2).dts
	$$(call build_if_changed,dtb_gen)

$$($(1)_gen_dir)/geometry_generic.ld: $$($(1)_gen_dir)/$(2).dtb
	$$(call build_if_changed,gen_cos_config,geometry_generic,$$($(1)_gen_dir))

endef

$(foreach _b,$(cluster-bin),\
	$(if $($(_b)-cos-conf),\
		$(eval $(call generate_cos_conf,$(_b),$($(_b)-cos-conf)))\
	)\
)

endif
