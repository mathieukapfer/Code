######################################
# Copyright (C) 2008-2020 Kalray SA. #
#                                    #
# All rights reserved.               #
######################################

ifeq ($(kaf_linux_included),)

kaf_linux_included := 1

# Multilib prefix
ifeq ($(arch),kv3-2)
kaf_linux_kvx_ml_prefix := kv3-2
else
kaf_linux_kvx_ml_prefix := .
endif

# KAF linux toolchain flags
cluster-lflags   += -L$(KALRAY_TOOLCHAIN_DIR)/kvx-linux/lib/$(kaf_linux_kvx_ml_prefix)/
cluster-cflags   += -I$(KALRAY_TOOLCHAIN_DIR)/kvx-linux/include
cluster-cppflags += -I$(KALRAY_TOOLCHAIN_DIR)/kvx-linux/include

endif
