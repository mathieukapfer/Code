# SPDX-License-Identifier: GPL-2.0-only

ifeq ($(strict_flags_included),)

strict_flags_included := 1

# Strict flags for compilation
__strict_flags = -Wall -Wextra -Winit-self -Wswitch-default -Wshadow -Wuninitialized
__strict_flags += -Wfloat-equal -Wundef -Wshadow -Werror -DSTRICT_FLAGS_ENABLED

cflags += -Wbad-function-cast $(__strict_flags)
cppflags += $(__strict_flags)

endif
