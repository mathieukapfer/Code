# SPDX-License-Identifier: GPL-2.0-only

ifneq ($(module_included_end),)
ifeq ($(fit_included),)

fit_included := 1

KVX_MKIMAGE ?= $(KALRAY_TOOLCHAIN_DIR)/bin/kvx-mkimage

##############################
# Generate FIT for mppa-bin
##############################

mppa-fit ?=

define mppa_bin_obj_gen_images

$(1)_fit_image-data := $(CURDIR)/$($(1)_outfile)
$(1)_fit_image-name := $(if $($(1)-nameinfit),$($(1)-nameinfit),$(1))
$(1)_fit_image-desc := "$(1) binary"

$(1)-prop := "$(1)"
endef

define mppa_bin_rules

# check if nobody name the multibinary with the same name as an application
dummy := $(if $($(1)-srcs),$(error Your fit $(1) has the same name as an application, please choose a different name),)

# Iterate over all object og the mutibinary to create images
$(foreach obj,$($(1)-objs),$(call mppa_bin_obj_gen_images,$(obj)))

$(1)-deps ?=
$(1)_config-props := $(foreach obj,$($(1)-objs), $(obj))
$(1)-images := $(foreach obj,$($(1)-objs),$(obj)_fit_image)
$(1)-configs := $(1)_fit_config
$(1)-deps += $(foreach obj,$($(1)-objs), $(obj))

mppa-fit += $(1)
endef

mppa_multibins := $(foreach m,$(sort $(mppa-bin)),$(if $($(m)-objs),$(m),))

$(foreach m,$(mppa_multibins), $(eval $(call mppa_bin_rules,$(strip $(m)))))


##############################
# Generate FIT files
##############################

mppa_fit = $(sort $(mppa-fit))

# Template for a single config property in a fit file
#
# $(1): Config property name
#
define fit_property_template
	\t\t$(1) = $($(1)-prop);					\n
endef

# Template for image section in a fit file
#
# $(1): Image description
#
define fit_image_template
		$($(1)-name) {						\n\
		\t\t	description = $($(1)-desc);			\n\
		\t\t	data = /incbin/("$($(1)-data)");		\n\
		\t\t	type = "$($(1)-type)";				\n\
		\t\t	arch = "$($(1)-arch)";				\n\
		\t\t	compression = "$($(1)-compression)";		\n\
$(foreach p,$($(1)-props),$(call fit_property_template,$(strip $(p))))	\
		\t\t	hash@1 {					\n\
		\t\t		algo = "md5";				\n\
		\t\t	};						\n\
		\t\t};							\n
endef

# Template for a config entry
#
# $(1): Config entry name
#
define fit_config_template
		$($(1)-name) {						\n\
		\t\t	description = $($(1)-desc);			\n\
$(foreach p,$($(1)-props),$(call fit_property_template,$(strip $(p))))	\
		\t\t};							\n
endef

define fit_template
/dts-v1/;								\n\
/ {									\n\
	\tdescription = "$($(1)-desc)";					\n\
	\t#address-cells = <1>;						\n\
	\timages {							\n\
$(foreach i,$($(1)-images),$(call fit_image_template,$(strip $(i))))	\
	\t};								\n\
	\tconfigurations {						\n\
	\t	default = "$($(1)-default-config)";			\n\
$(foreach c,$($(1)-configs),$(call fit_config_template,$(strip $(c))))	\
	\t};								\n\
};
endef

quiet_cmd_gen_fit = GEN_FIT\t$(BUILD_DIR)/$(2).its
      cmd_gen_fit = echo -e '$(call fit_template,$(2),$($(2)-name).images,$($(2)-name).spawndir)' > $@

DTS_PP_FLAGS := -E -nostdinc -undef -D__DTS__ -x assembler-with-cpp

# Not the PATH definition since kvx-mkimage uses expect it to contain dtc
quiet_cmd_mkimage = MK_IMAGE\t$(ITB_DIR)/$(2).itb
      cmd_mkimage = $(HOSTCC) $($(2)_cpp_includes) $(depgencmd) $($(2)-gcc-flags) $(DTS_PP_FLAGS) -o - $< | \
			PATH=$(KALRAY_TOOLCHAIN_DIR)/bin:$$PATH $(KVX_MKIMAGE) -A kv3 -f - $@ $(if $(strip $(Q)),> /dev/null,)

# Generate variables for images
# $(1) = image name
define mppa_fit_gen_var
$(1)-name ?= $(1)
$(1)-desc ?= "$(1)"
endef

define mppa_fit_images_var
$(1)-type ?= firmware
$(1)-arch ?= kv3
$(1)-compression ?= none
endef

# Generate default variable for images and configs
$(foreach f,$(mppa_fit), \
	$(foreach i,$(sort $($(f)-images)), \
		$(eval $(call mppa_fit_gen_var,$(strip $(i)))) \
		$(eval $(call mppa_fit_images_var,$(strip $(i)))) \
	) \
	$(foreach c,$(sort $($(f)-configs)),$(eval $(call mppa_fit_gen_var,$(strip $(c))))) \
)

# Generate its and itb rules and files
# $(1): mppa fit
define mppa_fit_rules

$(if $($(1)-images),,$(error $(1)-images is empty))
$(if $($(1)-configs),,$(error $(1)-configs is empty))
$(1)-desc ?= $(1)
$(1)-default-config ?= $(firstword $($(1)-configs))
$(1)_gen_dir := $(_gen_gen_dir)
$(1)_all_data := $(foreach i,$($(1)-images),$($(i)-data))

$$($(1)_gen_dir)/$(1).its: $($(1)-deps) $$($(1)_gen_dir)/.dirstamp
	$$(call build_if_changed,gen_fit,$(1))

$(ITB_DIR)/$(1).itb: $$($(1)_gen_dir)/$(1).its $$($(1)_all_data) $(ITB_DIR)/.dirstamp
	$$(call build_if_changed,mkimage,$(1))

PHONY += $(1)
$(1): $(ITB_DIR)/$(1).itb FORCE

module_obj_hooks += $(ITB_DIR)/$$($(1)-name).itb $$($(1)_gen_dir)/$$($(1)-name).its

__mppa_fit += $(1)

endef

$(foreach f,$(mppa_fit),$(if $($(f)-its),,$(eval $(call mppa_fit_rules,$(strip $(f))))))

#
# Compile existing .its source into a itb.
# 
define mppa_its_rules

$(ITB_DIR)/$(1).itb: $($(1)-its) $($(1)-deps) $(ITB_DIR)/.dirstamp
	$$(call build_if_changed,mkimage,$(1))

PHONY += $(1)
$(1): $(ITB_DIR)/$(1).itb FORCE

module_obj_hooks += $(ITB_DIR)/$$($(1)-name).itb

__mppa_fit += $(1)

endef

$(foreach f,$(mppa_fit),$(if $($(f)-its),$(eval $(call mppa_its_rules,$(strip $(f)))),))

module_main_hooks += $(__mppa_fit)

endif
endif
