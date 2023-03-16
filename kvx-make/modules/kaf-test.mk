######################################
# Copyright (C) 2008-2020 Kalray SA. #
#                                    #
# All rights reserved.               #
######################################

ifeq ($(kaf_test_included),)

kaf_test_included := 1

# Linux standalone system setup common test
ifeq ($(cluster-system),linux)
	kaf_deploy_linux_std_test-host-cmd := kaf_deploy_linux_std_tests.sh
	kaf_deploy_linux_std_test-labels := linux_system
	kaf_deploy_linux_std_test-host-timeout := 180
	host-tests += kaf_deploy_linux_std_test
endif

# List of firmwares to generate KAF tests
kaf-test-firmware-list := ocl_fw.elf ocl_fw_l2_d_1m.elf

# KAF test targets to define in Makefile
# $1 is mppa firmware used for test
# $2 is label to add to test target to make it unique

# Generate ctests from a KAF test target with kaf-test-firmware-list
# $1 is KAF test target
define kaf-generate-tests
$(foreach firmware,$(kaf-test-firmware-list),\
	$(eval $(call $(1),$(firmware),$(firmware:.elf=)))\
)
endef

# Generate KAF tests from target list kaf-tests
$(foreach target,$(kaf-tests),\
	$(eval $(call kaf-generate-tests,$(target)))\
)

endif
