######################################
# Copyright (C) 2008-2020 Kalray SA. #
#                                    #
# All rights reserved.               #
######################################

ifeq ($(kaf_build_included),)

kaf_build_included := 1

file_dir := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

# Include a make module from kaf-build
# $1 is make module to include
define kaf_include_module
	ifneq ("$(wildcard $(file_dir)/$(1).mk)","")
		# Module is in same dir
		include $(file_dir)/$(1).mk
	else
		# kaf-build is directly included
		use-module += $(1)
	endif
endef

# MPPA Standalone OS parameter
# Makefile variable to set to build whole module for cos or linux OpenCL host
KAF_MPPA_HOST_OS := cos
cluster-system := $(KAF_MPPA_HOST_OS)

# Set KAF default cluster compiler
ifneq ($(cluster-system),linux)
	cluster-compiler ?= gcc
endif

ifeq ($(KAF_MPPA_HOST_OS),linux)
# Use KAF linux toolchain
$(eval $(call kaf_include_module,kaf-linux))
else ifeq ($(KAF_MPPA_HOST_OS),cos)
# Use cos toolchain
$(eval $(call kaf_include_module,opencl_cos))
else
$(error Invalid KAF_MPPA_HOST_OS=$(KAF_MPPA_HOST_OS))
endif

# Include needed modules
$(eval $(call kaf_include_module,opencl_linux))
$(eval $(call kaf_include_module,opencl-kernel))
$(eval $(call kaf_include_module,submodule))

# Add KAF core Cflags
cppflags += `pkg-config --cflags kaf-core`
cflags   += `pkg-config --cflags kaf-core`
# Add custom flags
KAF_BUILD_COMMON_INCLUDE := -I.
# Include
cppflags += $(KAF_BUILD_COMMON_INCLUDE)
cflags += $(KAF_BUILD_COMMON_INCLUDE)
# At least when in C++ mode, having a VLA is most likely a bug
cppflags += -Werror=vla
# GCC accepts some C++17 constructs even in C++11 mode
cppflags += -Werror=pedantic


# Check needed variables
ifeq ($(SRCDIR),)
$(error Variable SRCDIR is not set in Makefile. Should be set to repo top dir)
endif
ifeq ($(wildcard $(SRCDIR)/*),)
$(error SRCDIR=$(SRCDIR) directory is empty)
endif

# ref T18065
# TODO: If possible, find a way to keep exceptions when binaries are compiled and disable it only for libs.
ifeq ($(cluster-compiler),llvm)
cluster-cppflags += -fno-exceptions
endif

# KAF services pkg-config PATH
$(foreach services_pkgconfig_dir, $(shell ls -d $(SRCDIR)/kaf_services/*/pkgconfig/ 2>/dev/null), $(eval _services_pkg_config_path = $(_services_pkg_config_path):$(abspath $(services_pkgconfig_dir))))
$(eval PKG_CONFIG_PATH = $(PKG_CONFIG_PATH):$(_services_pkg_config_path))

endif
