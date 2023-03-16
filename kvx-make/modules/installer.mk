# SPDX-License-Identifier: GPL-2.0-only

ifneq ($(module_included_end),)
ifeq ($(installer_included),)

installer_included := 1

all_install_targets := $(sort $(strip $(install-targets)))

dummy := $(if $(project-name),,$(error project-name is not specified))

exec_prefix ?= prefix

libdir ?= $(abspath $(prefix)/lib)
bindir ?= $$(abspath $$(exec_prefix)/bin)
includedir ?= $(abspath $(prefix)/include)
datadir ?= $(abspath $(prefix)/share)
docdir ?= $$(abspath $$(datadir)/doc)
mandir ?= $$(abspath $$(datadir)/man)
pkgconfigdir ?= $$(abspath $$(libdir)/pkconfig)

should_be_installed = $(filter $(1),$(all_install_targets))

#
# Initialize install prefixes to defaults if not initialized
#
define kvx_init_install

$(1)-prefix ?= $(prefix)
$(1)-libdir ?= $$(abspath $$($(1)-prefix)/lib)
$(1)-bindir ?= $$(abspath $$($(1)-prefix)/bin)
$(1)-includedir ?= $$(abspath $$($(1)-prefix)/include)
$(1)-datadir ?= $$(abspath $$($(1)-prefix)/share/$(project-name))
$(1)-pkgconfigdir ?= $$(abspath $$($(1)-libdir)/pkgconfig)

$(1)-install-flags ?= $(install-flags)

endef

$(foreach _a,host cluster,$(eval $(call kvx_init_install,$(_a))))

# dtb generation rule
quiet_cmd_install-file = INSTALL \t$< -> $@
      cmd_install-file = install -d $(dir $@); \
			 install $($(2)_install_flags) $< $@

# dtb generation rule
quiet_cmd_install-directory = INSTALL \t$< -> $@
      cmd_install-directory = mkdir -p $(dir $@); \
			 cp -r $< $@

#
# Install a library in its final directory
# $(1) = target name
# $(2) = type (cluster,host)
# $(3) = default install dir (lib/bin)
#
define gen_install_default_var

$(1)-install-dir ?= $($(2)-$(3))
$(1)_install_flags = $($(1)-install-flags)

endef

bin_output_dir = $(BIN_DIR)
lib_output_dir = $(LIB_OUTPUT_DIR)/$(1)

_install_bin_deps =
_install_lib_deps =

#
# Install a binary in its final directory
# $(1) = target name
# $(2) = type (cluster, host, mppa)
# $(3) = bin/lib output dir
# $(4) = type bin/lib
#
define install_libbin

$($(1)-install-dir)/$($(1)-name): $(3)/$($(1)-name)
	$$(call build_cmd,install-file,$(1))

_install_$(4)_deps += $($(1)-install-dir)/$($(1)-name)

endef

# Binaries and libraries
$(foreach _type, lib bin,\
	$(foreach _a, host cluster,\
		$(foreach _b,$($(_a)-$(_type)),\
			$(if $(call should_be_installed,$(_b)), \
				$(eval $(call gen_install_default_var,$(_b),$(_a),$(_type)dir)) \
				$(eval $(call install_libbin,$(_b),$(_a),$(call $(_type)_output_dir,$(_a)),$(_type))) \
			) \
		) \
	) \
)

# Multibin
$(foreach _mb,$(mppa_multibins),\
	$(if $(call should_be_installed,$(_mb)), \
		$(eval $(call gen_install_default_var,$(_mb),mppa,datadir)) \
		$(eval $(call install_libbin,$(_mb),mppa,$(BIN_DIR))) \
	) \
)

headers_install_dir := includedir
data_install_dir := datadir
sources_install_dir := datadir
pkgconfig_install_dir := pkgconfigdir

# List of extra available files
extra_install_files := headers data sources pkgconfig

_install_extra_deps = 
#
# Install headers
# $(1) = type (cluster, host)
# $(2) = file
# $(3) = file type (extra_install_files)
#
define install_extra_file

$($(2)-$(1)-install-dir)/$(notdir $(2)): $(2)
	$$(call build_cmd,install-directory)

_install_extra_deps += $($(2)-$(1)-install-dir)/$(notdir $(2))

endef

# Additionnal files
$(foreach _file_type,$(extra_install_files),\
	$(foreach _a, host cluster,\
		$(foreach _file,$($(_a)-install-$(_file_type)),\
			$(eval $(call gen_install_default_var,$(_file)-$(_a),$(_a),$($(_file_type)_install_dir)))\
			$(eval $(call install_extra_file,$(_a),$(_file),$(_file_type)))\
		)\
	)\
)

html_doxy_install_dir = $(docdir)/$(project-name)/$(1)/$(2)
man_doxy_install_dir = $(mandir)
latex_doxy_install_dir = $(docdir)/$(project-name)/$(1)/$(2)

_install_doc_deps =
#
# Install doxygen
# $(1) = doxygen target name
# $(2) = output format
#
define install_doxygen

$(1)-$(2)-install-dir ?= $(call $(2)_doxy_install_dir,$(1),$(2))

$$($(1)-$(2)-install-dir): $(DOC_DIR)/$(1)/$(2)
	$$(call build_cmd,install-directory)

_install_doc_deps += $$($(1)-$(2)-install-dir)

endef

# Doxygen
$(foreach _doxy,$(__all_doxyfiles),\
	$(foreach _format,$(filter-out latex,html $($(_doxy)-output-formats)),\
		$(if $(call should_be_installed,$(_doxy)),\
			$(eval $(call install_doxygen,$(_doxy),$(_format)))\
		)\
	)\
)

# OpenCL Kernel
_install_opencl_kernel_deps =
#
# Install opencl_kernel
# $(1) = kernel target name
#
define install_opencl_kernel
$(1)-install-dir ?= $(abspath $(opencl-kernel-install-dir))

$(if $(opencl-kernel-install-dir),,$(error opencl-kernel-install-dir must be set))

$$($(1)-install-dir)/$($(1)-name): $($(1)_final_file)
	$$(call build_cmd,install-file,$(1))

_install_opencl_kernel_deps += $$($(1)-install-dir)/$($(1)-name)
endef

# OCL Kernel
$(foreach _kernel,$(__all_opencl_kernels),\
	$(if $(call should_be_installed,$(_kernel)),\
		$(eval $(call install_opencl_kernel,$(_kernel)))\
	)\
)

_install_target_deps :=

# Generate installation rule
# $(1) = Install type
#
define gen_install_rule
PHONY += install-$(1)
install-$(1): $(_install_$(1)_deps) FORCE

_install_target_deps += install-$(1)
endef

_INSTALL_TYPES = bin lib doc extra opencl_kernel

$(foreach _type,$(_INSTALL_TYPES), $(eval $(call gen_install_rule,$(_type))))

PHONY += install
install: $(_install_target_deps) FORCE

endif
endif
