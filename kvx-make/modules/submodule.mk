######################################
# Copyright (C) 2008-2022 Kalray SA. #
#                                    #
# All rights reserved.               #
######################################

ifeq ($(submodule_included),)

submodule_included := 1

ifeq ($(cluster-system),)
cluster-system ?= cos
endif

module-root ?= ..

# Check module exist
$(foreach module, $(submodule-deps), $(if $(shell ls -d $(module-root)/$(module) 2>/dev/null),, $(error Module $(module) does not exit)))

# Common host build include
$(foreach module, $(submodule-deps), $(foreach include_dir, $(shell ls -d $(module-root)/$(module)/devimage*-dev/include 2>/dev/null), $(eval _submodule_common_host_include += -I$(include_dir))))
host-cflags   += $(_submodule_common_host_include)
host-cppflags += $(_submodule_common_host_include)

# Common host link
$(foreach module, $(submodule-deps), $(foreach lib_dir, $(shell ls -d $(module-root)/$(module)/devimage*-dev/lib 2>/dev/null),     $(eval _submodule_common_host_link += -L$(lib_dir))))
$(foreach module, $(submodule-deps), $(foreach rt-dir,  $(shell ls -d $(module-root)/$(module)/devimage*-runtime/lib 2>/dev/null), $(eval _submodule_common_host_link += -L$(rt-dir))))
host-lflags += $(_submodule_common_host_link)

# Common kvx build include
$(foreach module, $(submodule-deps), $(foreach include_dir, $(shell ls -d $(module-root)/$(module)/devimage*-dev/kvx-$(cluster-system)/include 2>/dev/null), $(eval _submodule_common_kvx_include += -I$(include_dir))))
cluster-cflags   += $(_submodule_common_kvx_include)
cluster-cppflags += $(_submodule_common_kvx_include)

# Common kvx link
ifeq ($(arch),kv3-2)
_sub_kvx_ml_prefix := kv3-2
else
_sub_kvx_ml_prefix := .
endif
$(foreach module, $(submodule-deps), $(foreach lib_dir, $(shell ls -d $(module-root)/$(module)/devimage*-dev/kvx-$(cluster-system)/lib/$(_sub_kvx_ml_prefix) 2>/dev/null), $(eval _submodule_common_kvx_link += -L$(lib_dir))))
cluster-lflags += $(_submodule_common_kvx_link)

# pkg-config PATH
$(foreach module, $(submodule-deps), $(foreach pkgconfig_dir, $(shell ls -d $(module-root)/$(module)/devimage*-dev/lib/pkgconfig/ 2>/dev/null), $(eval _module_pkg_config_path = $(_module_pkg_config_path):$(abspath $(pkgconfig_dir)))))
$(eval PKG_CONFIG_PATH = $(PKG_CONFIG_PATH):$(_module_pkg_config_path))

endif
