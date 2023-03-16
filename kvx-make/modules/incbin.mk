# SPDX-License-Identifier: GPL-2.0-only

ifeq ($(incbin_included),)

incbin_included := 1

#
# incbin syntax:
#
# mybin-binary := foo/bar
# mybin-symbols-name := foobar
# included-bin += mybin
#
# You can specifiy a custom section to store data by using:
# included-section := .mysection
# By default, the data will end in .rodata section
#
# You can specify if the included data should be marked 'const'
# (default) or not using the global setting:
# included-bin-const := 1
# or the item specfic setting:
# mybin-const := 1
# This may be needed if you are including the data in a section that
# contains other data: all data should have the same attributes.
#
# Then to include your binary into another elf, use the following
# (ie -bins):
# toto-bins := mybin
#

incbin_targets :=

included-bin-section ?= .rodata
included-bin-const ?= 1

# Generate an assembly file to include in program
# $(1) = target name
# $(2) = Binary to include
#
define incbin_template
.section $($(1)-section),$($(1)-section-attribute)			\n\
.global $(1)_incbin_start						\n\
.align $($(1)-align)							\n\
$(1)_incbin_start:							\n\
.incbin "$(2)"								\n\
$(1)_incbin_end:							\n\
.global $(1)_incbin_end							\n\
.size $(1)_incbin_start, .-$(1)_incbin_start
endef

define incbin_header
#ifndef $(1)_H        							\n\
#define $(1)_H								\n\
#include <stddef.h>							\n\
extern $(if $(filter 1,$($(1)-const)),const,) char $(1)_incbin_start[];			\n\
extern $(if $(filter 1,$($(1)-const)),const,) char $(1)_incbin_end[];			\n\
									\n\
#define $(1)_ptr (($(if $(filter 1,$($(1)-const)),const,) void *) $(1)_incbin_start)	\n\
#define $(1)_end_ptr (($(if $(filter 1,$($(1)-const)),const,) void *) $(1)_incbin_end)	\n\
#define $(shell echo $(1) | tr a-z A-Z)_SIZE ((size_t) $(shell stat --printf='%s' $(2)))	\n\
									\n\
#endif
endef

#
# $(1) = Target name
#
define incbin_list_header
#ifndef $(1)_LIST_H        						\n\
#define $(1)_LIST_H							\n\
$(foreach _incbin,$($(1)-bins),#include <$(_incbin).h>\n)		  \
									\n\
struct incbin_list_struct {						\n\
\tconst void *addr;							\n\
\tunsigned long size;							\n\
\tconst char *name;							\n\
};									\n\
									\n\
#define INCBIN_LIST_SIZE	$(words $($(1)_incbin_list))		\n\
									\n\
static const struct incbin_list_struct incbin_list[INCBIN_LIST_SIZE] = {\n\
$(foreach _incbin,$($(1)-bins),\
  \t{$(_incbin)_ptr, $(shell echo $(_incbin) | tr a-z A-Z)_SIZE, "$(_incbin)"},\n\
)\
};									\n\
									\n\
#endif
endef


quiet_cmd_gen_incbin_strip = INCBIN_STRIP\t$(2)
      cmd_gen_incbin_strip = $(KVX_STRIP) $(2) $(3) -o $@

quiet_cmd_gen_incbin = INCBIN\t$(2)
      cmd_gen_incbin = echo -e '$(call incbin_template,$(2),$(3))' > $@

quiet_cmd_gen_inchdr = INCHDR\t$(2)
      cmd_gen_inchdr = echo -e '$(call incbin_header,$(2),$(3))' > $@

quiet_cmd_gen_inclisthdr = INCLISTHDR\t$(2)
      cmd_gen_inclisthdr = echo -e '$(call incbin_list_header,$(2))' > $@

#
# $(1) = incbin name
#
define gen_incbin

$(1)-section ?= $(included-bin-section)
$(1)-align ?= 4
$(1)-strip ?=
$(1)-strip-name = $($(1)-binary)
# Just to nopify the strip rule in case of no strip: $$($(1)-strip-name)$$($(1)-strip-rule)
$(1)-strip-rule = .norule
ifneq ($$($(1)-strip),)
  $(1)-strip-name = $($(1)-binary).strip
  $(1)-strip-rule =
endif
$(1)-section-attribute ?= ""
$(1)-const ?= $(included-bin-const)
$(1)-symbols-name ?= $(1)
$(1)_gen_dir := $(_gen_gen_dir)

$$($(1)_gen_dir)/$(1).S: $($(1)-deps) $$($(1)-strip-name) $$($(1)_gen_dir)/.dirstamp
	$$(call build_if_changed,gen_incbin,$$($(1)-symbols-name),$$($(1)-strip-name))

$$($(1)_gen_dir)/$(1).h: $($(1)-deps) $$($(1)-strip-name) $$($(1)_gen_dir)/.dirstamp
	$$(call build_if_changed,gen_inchdr,$$($(1)-symbols-name),$$($(1)-strip-name))

$(1): $$($(1)_gen_dir)/$(1).S $$($(1)_gen_dir)/$(1).h FORCE

$$($(1)-strip-name)$$($(1)-strip-rule): $($(1)-binary) $$($(1)_gen_dir)/.dirstamp
	$$(call build_if_changed,gen_incbin_strip,$$($(1)-strip),$($(1)-binary))

module_obj_hooks += $$($(1)_gen_dir)/$(1).S $$($(1)_gen_dir)/$(1).h

incbin_targets += $(1)

endef

$(foreach _ib,$(included-bin) $(__host_bin) $(__host_lib),\
	$(if $($(_ib)-binary),$(eval $(call gen_incbin,$(_ib))))\
)

module_main_hooks += $(incbin_targets)

#
# $(1) = target name
#
define add_bins_to_src
$(1)_gen_dir := $(_gen_gen_dir)
$(1)_incbin_list = $(foreach _bin,$($(1)-bins), $($(_bin)_gen_dir)/$(_bin).S)
$(1)-srcs += $$($(1)_incbin_list)
$(1)-deps += $$($(1)_gen_dir)/$(1)_incbin_list.h

$(1)_incbin_flags = $(foreach _bin,$($(1)-bins), -I$($(_bin)_gen_dir)/) -I$$($(1)_gen_dir)
$(1)-cflags += $$($(1)_incbin_flags)
$(1)-cppflags += $$($(1)_incbin_flags)

$$($(1)_gen_dir)/$(1)_incbin_list.h: $$($(1)_incbin_list) $$($(1)_gen_dir)/.dirstamp
	$$(call build_if_changed,gen_inclisthdr,$(1))

endef

$(foreach _b,$(host-bin) $(host-lib) $(cluster-bin) $(cluster-lib),\
	$(if $($(_b)-bins),$(eval $(call add_bins_to_src,$(_b))))\
)

endif
