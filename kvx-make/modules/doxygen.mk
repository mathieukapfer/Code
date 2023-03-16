# SPDX-License-Identifier: GPL-2.0-only

ifeq ($(doxygen_included),)

doxygen_included := 1

DOXYGEN_DIR := $(dir $(shell which doxygen))/../

define doxyfile_gen
@INCLUDE = $(DOXYGEN_DIR)/share/doxygen/kalray_template/Doxyfile.in	\n\
PROJECT_NAME           = $($(1)-name)					\n\
PROJECT_NUMBER         = $($(1)-number)					\n\
PROJECT_BRIEF          = $($(1)-brief)					\n\
OUTPUT_DIRECTORY       = $($(1)_output_dir)				\n\
INPUT                  = $($(1)-input)					\n\
EXAMPLE_PATH           = $($(1)-example-path)				\n\
EXCLUDE                = $($(1)-exclude)				\n\
GENERATE_LATEX         = $($(1)_latex_output)				\n\
GENERATE_MAN           = $($(1)_man_output)				\n\
WARN_LOGFILE           = $($(1)_output_dir)/doxygen_errors.log
endef

__all_doxyfiles = $(sort $(strip $(doxygen-doc)))

quiet_cmd_gen_doxygen = DOXYGEN\t$(DOC_DIR)/$(2)/
      cmd_gen_doxygen = DOXYGEN_DIR=$(DOXYGEN_DIR) doxygen $($(2)-doxyfile); \
			$(if $($(2)-no-error),true,[ ! -s $($(2)_output_dir)/doxygen_errors.log ] || \
			(echo "Doxygen abort, some functions are badly documented" && \
			cat $($(2)_output_dir)/doxygen_errors.log && exit 1))

quiet_cmd_gen_doxyfile = DOXYFILE\t$(DOC_DIR)/$(2)/Doxyfile
      cmd_gen_doxyfile = echo -e '$(call doxyfile_gen,$(2))' > $@

doxygen_doc :=

define doxygen_generate

$(1)-doxyfile ?= $(DOC_DIR)/$(1)/Doxyfile

$(if $($(1)-name),,$(error Doxygen $(1)-name is not defined))
$(if $($(1)-brief),,$(error Doxygen $(1)-brief is not defined))
$(if $($(1)-input),,$(error Doxygen $(1)-input is not defined))
$(1)_output_dir = $(DOC_DIR)/$(1)/

$(1)_latex_output = $$(if $$(findstring latex,$$($(1)-output-formats)),YES,NO)
$(1)_man_output = $$(if $$(findstring man,$$($(1)-output-formats)),YES,NO)

$$($(1)-doxyfile): $$($(1)-input) $($(1)-deps) $(DOC_DIR)/$(1)/.dirstamp
	$$(call build_if_changed,gen_doxyfile,$(1))

$(DOC_DIR)/$(1)/html/index.html: $$($(1)-doxyfile) $($(1)-deps) $(DOC_DIR)/$(1)/.dirstamp
	$$(call build_if_changed,gen_doxygen,$(1))

PHONY += $(1)
$(1): $(DOC_DIR)/$(1)/html/index.html FORCE

module_obj_hooks += $(DOC_DIR)/$(1)/Doxyfile

doxygen_doc += $(1)

endef

$(foreach f,$(__all_doxyfiles), $(eval $(call doxygen_generate,$(f))))

module_main_hooks += $(doxygen_doc)

endif
