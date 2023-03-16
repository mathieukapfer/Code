# SPDX-License-Identifier: GPL-2.0-only

ifneq ($(module_included_end),)
ifeq ($(converter_included),)

converter_included := 1

KVX_OBJDUMP	?= $(__TOOLCHAIN_PREFIX)kvx-elf-objdump
KVX_OBJCOPY	?= $(__TOOLCHAIN_PREFIX)kvx-elf-objcopy
converter_targets :=

quiet_cmd_gen_convert_disas_host = CONV_DISAS\t$@
      cmd_gen_convert_disas_host = objdump $(3) -D $(CURDIR)/$($(2)_outfile) > $@

quiet_cmd_gen_convert_disas_cluster = CONV_DISAS\t$@
      cmd_gen_convert_disas_cluster = $(KVX_OBJDUMP) $(3) -D $(CURDIR)/$($(2)_outfile) > $@

quiet_cmd_gen_convert_bin_cluster = CONV_BIN\t$@
      cmd_gen_convert_bin_cluster = $(KVX_OBJCOPY) $(3) -O binary $(CURDIR)/$($(2)_outfile) $@

#
# $(1) = target name
# $(2) = converter name
# $(3) = type name (host/cluster)
#
define gen_convert_rule

$(BIN_DIR)/$(1).$(2): $($(1)_outfile) $(BIN_DIR)/.dirstamp
	$$(call build_if_changed,gen_convert_$(2)_$(3),$(1),$($(1)-convert-$(2)-opts))

module_main_hooks += $(BIN_DIR)/$(1).$(2)

endef

$(foreach _t,host cluster,\
	$(foreach _b,$($(_t)-bin),\
		$(foreach _c,$($(_b)-convert),\
			$(if $(cmd_gen_convert_$(_c)_$(_t)),\
				$(eval $(call gen_convert_rule,$(_b),$(_c),$(_t))),\
				$(error "Converter format $(_c) does not exists or not supported for $(_t)")\
			)\
		)\
	)\
)

endif
endif
