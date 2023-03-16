# SPDX-License-Identifier: GPL-2.0-only

ifeq ($(ctest_included),)

ctest_included := 1

# Convert a string to upper case
uppercase = \
	$(subst a,A,\
	$(subst b,B,\
	$(subst c,C,\
	$(subst d,D,\
	$(subst e,E,\
	$(subst f,F,\
	$(subst g,G,\
	$(subst h,H,\
	$(subst i,I,\
	$(subst j,J,\
	$(subst k,K,\
	$(subst l,L,\
	$(subst m,M,\
	$(subst n,N,\
	$(subst o,O,\
	$(subst p,P,\
	$(subst q,Q,\
	$(subst r,R,\
	$(subst s,S,\
	$(subst t,T,\
	$(subst u,U,\
	$(subst v,V,\
	$(subst w,W,\
	$(subst x,X,\
	$(subst y,Y,\
	$(subst z,Z,$(1)))))))))))))))))))))))))))


################################################################################
#			        Test Part
################################################################################
# Global test attributes
#  host-tests := list of test name
#
# Current supported test attributes are:
#  {hw|host}-cmd := Host command
#  {hw|host}-timeout := Host timeout
#  sim-cmd := Simulator command line
#  sim-timeout := Simulator timeout
#  cost := Test cost for ordered run
#  labels := Labels applying to this test

__mppa_runners := jtag sim
__host_runners := hw host sim

__jtag_io_node_opt := IODDR0
__jtag_mppa_node_opt := IODDR0
__jtag_cluster_node_opt := Cluster0

__sim_io_runner = $(KVX_CLUSTER)
__sim_cluster_runner = $(KVX_CLUSTER)
__sim_mppa_runner = $(KVX_MPPA)

__arch_kv3_march := kv3
__arch_kv3-1_march := kv3-1
__arch_kv3-2_march := kv3-2
__arch_coolidge_march := kv3-1

__all_tests :=

# Generate var for all tests list
# $1 = core type
define gen_all_test_list
__all_$(1)_tests = $(sort $($(1)-tests))
__all_tests += $$(__all_$(1)_tests)
endef

$(foreach test_plat,cluster mppa host,$(eval $(call gen_all_test_list,$(test_plat))))

ifneq ($(strip $(__all_tests)),)

# Generate var for specific list
# $1 = core type
define gen_plat_tests_list
__$(1)_$(2)_tests := $$(foreach t,$$(__all_$(1)_tests),$$(if $$($$(t)-$(2)-cmd),$$(t),))
endef

$(foreach plat,$(__mppa_runners),$(foreach core,cluster mppa,$(eval $(call gen_plat_tests_list,$(core),$(plat)))))
$(foreach runner,$(__host_runners),$(eval $(call gen_plat_tests_list,host,$(runner))))

define gen_ctest_env
	$(foreach e, $1,'SET(ENV{$(word 1,$(subst =, ,$(e)))} $(word 2,$(subst =, ,$(e))))')
endef

CTEST_DEFAULT_SIM_TIMEOUT := 400
CTEST_DEFAULT_HW_TIMEOUT := 30
tests-hw-timeout ?= $(CTEST_DEFAULT_HW_TIMEOUT)
tests-rem_hw-timeout ?= $(CTEST_DEFAULT_HW_TIMEOUT)
tests-host-timeout ?= $(CTEST_DEFAULT_HW_TIMEOUT)
tests-sim-timeout ?= $(CTEST_DEFAULT_SIM_TIMEOUT)
tests-jtag-timeout ?= $(CTEST_DEFAULT_SIM_TIMEOUT)

CTEST_DEFAULT_COST := 0

__extra_ctest_properties := \
	attached-files-on-fail \
	attached-files \
	cost \
	depends \
	environment \
	fail-regular-expression \
	fixtures-cleanup \
	fixtures-required \
	fixtures-setup \
	labels \
	measurement \
	pass-regular-expression \
	processors \
	required-files \
	resource-lock \
	run-serial \
	skip-return-code \
	timeout-after-match \
	will-fail \
	working-directory

# Generate SET_TESTS_PROPERTIES lines
# $1 = test name
# $2 = Test type (host, hw, rem_hw, sim, jtag)
# $3 = property to generate
define gen_ctest_property
	__$(1)_$(2)_cmd += SET_TESTS_PROPERTIES\($$(__$(1)_name) PROPERTIES  $(subst -,_,$(call uppercase,$(3))) \"$($(1)-$(3))\"\)\\n
endef

# Generate ctest lines
# $1 = test name
# $2 = Test type (host, hw, rem_hw, sim, jtag)
# $3 = Application runner
# $4 = Additionnal labels
#
define gen_ctest_test_line

$(1)-$(2)-timeout ?= $(tests-$(2)-timeout)
$(1)-cost ?= $(CTEST_DEFAULT_COST)
__$(1)_name := $(tests-prefix)$(2)_$(1)$(tests-suffix)
__$(1)_$(2)_labels := $(subst $(space),\;,$(strip $(4) $(tests-labels)) $($(1)-labels) $($(1)-$(2)-labels))

__$(1)_$(2)_cmd := ADD_TEST\($$(__$(1)_name) $(3) $($(2)-runner-opts) $($(1)-$(2)-runner-opts) $($(1)_$(2)_runner_opts) $($(1)-$(2)-cmd)\)\\n
__$(1)_$(2)_cmd += SET_TESTS_PROPERTIES\($$(__$(1)_name) PROPERTIES TIMEOUT \"$$($(1)-$(2)-timeout)\"\)\\n
__$(1)_$(2)_cmd += SET_TESTS_PROPERTIES\($$(__$(1)_name) PROPERTIES LABELS \"$$(__$(1)_$(2)_labels)\"\)\\n
__$(1)_$(2)_cmd += $(if $($(1)-$(2)-env),SET_TESTS_PROPERTIES\($$(__$(1)_name) PROPERTIES ENVIRONMENT \"$(subst $(space),\;,$($(1)-$(2)-env))\"\)\\n,)

endef

define gen_ctest_test

$(eval $(call gen_ctest_test_line,$(1),$(2),$(3),$(4)))

# Evaluate extra properties after gen_ctest_test_line to allow deferred variable to be instantiated
# For instance cost has a default value handled generically with this
$(foreach prop,$(__extra_ctest_properties),
	$(if $($(1)-$(prop)),$(call gen_ctest_property,$(1),$(2),$(prop)))\
)

endef

# Generate a remote target for a host tests
# $1 = test name
# $2 = platform type
#
define hw_test_to_remote

$(1)-$(2)-remote-host-exec ?= $(firstword $($(1)-$(2)-cmd))

__$(1)_rem_$(2)_exec := --host_exec $$($(1)-$(2)-remote-host-exec)
__$(1)_rem_$(2)_remote_infile := $(if $($(1)-$(2)-remote-input-files),--upload $(subst $(space),$(comma),$($(1)-$(2)-remote-input-files)),)
__$(1)_rem_$(2)_remote_outfile := $(if $($(1)-$(2)-remote-output-files),--download $(subst $(space),$(comma),$($(1)-$(2)-remote-output-files)),)
__$(1)_rem_multibinary := $(if $($(1)-multibinary),--multibinary $($(1)-multibinary),--nomultibinary)

$(1)_rem_$(2)_runner_opts := $$(__$(1)_rem_$(2)_remote_infile) $$(__$(1)_rem_$(2)_remote_outfile)
$(1)_rem_$(2)_runner_opts += $$(__$(1)_rem_multibinary) $$(__$(1)_rem_$(2)_exec) --
$(1)-rem_$(2)-timeout := $($(1)-$(2)-timeout)
$(1)-rem_$(2)-cmd ?= $($(1)-$(2)-cmd)

endef

# PCIe simulator runner command line
define gen_pcie_simrunner_test_cmd
$(1)-arch ?= $(arch)
$(1)_$(2)_runner_opts += -a$$($(1)-arch)
endef

$(foreach t,$(__host_hw_tests), $(eval $(call gen_ctest_test,$(t),hw,,host hw)))
$(foreach t,$(__host_host_tests), $(eval $(call gen_ctest_test,$(t),host,,host)))

$(foreach t,$(__host_sim_tests), $(eval $(call gen_pcie_simrunner_test_cmd,$(t),sim)) \
			$(eval $(call gen_ctest_test,$(t),sim,kvx-pciesim-runner,host sim)))

$(foreach t,$(__host_hw_tests), $(if $($(t)-hw-no-remote),,$(eval $(call hw_test_to_remote,$(t),hw)) \
				$(eval $(call gen_ctest_test,$(t),rem_hw,kvx-remote-runner,host remote hw))))

# Generate jtag command line
# $1 = Test name
# $2 = Test platform
# $3 = Elf name to execute
# $4 = Default node execution
define gen_jtag_test_cmd
$(1)-$(2)-node-exec ?= $(4)

$(1)_$(2)_runner_opts := $(if $($(1)-multibinary),--multibinary=$($(1)-multibinary))
$(1)_$(2)_runner_opts += --exec-$(if $($(1)-multibinary),multibin,file)=$(3):$(firstword $($(1)-$(2)-cmd)) --
$(1)-$(2)-cmd = $(wordlist 2, $(words $($(1)-$(2)-cmd)), $($(1)-$(2)-cmd))
endef

# Generate simulator command line
define gen_sim_test_cmd
$(1)-arch ?= $(arch)
$(1)_$(2)_runner_opts += --march=$$(__arch_$$($(1)-arch)_march) --
$(1)-$(2)-cmd = $(if $($(1)-multibinary),$($(1)-multibinary) $(wordlist 2, $(words $($(1)-$(2)-cmd)), $($(1)-$(2)-cmd)),$($(1)-$(2)-cmd))
endef

# Generate command lines for sim and jtag tests
$(foreach core,cluster mppa,\
	$(foreach t,$(__$(core)_jtag_tests), $(eval $(call gen_jtag_test_cmd,$(t),jtag,$(__jtag_$(core)_node_opt))) \
			$(eval $(call gen_ctest_test,$(t),jtag,$(KVX_JTAG_RUNNER),$(core) jtag)))\
	$(foreach t,$(__$(core)_sim_tests), $(eval $(call gen_sim_test_cmd,$(t),sim,$(core))) \
			$(eval $(call gen_ctest_test,$(t),sim,$(__sim_$(core)_runner),$(core) sim)))\
)

project-name ?= Test

PHONY += $(BIN_DIR)/DartConfiguration.tcl
$(BIN_DIR)/DartConfiguration.tcl: $(BIN_DIR)/.dirstamp FORCE
	$(Q)echo "Name: $(project-name)" > $@
	$(Q)echo "BuildName: $(project-name)" >> $@
	$(Q)echo "Site: $(shell hostname)" >> $@

tests-output-log-limit ?= 307200

PHONY += $(BIN_DIR)/CTestCustom.ctest
$(BIN_DIR)/CTestCustom.ctest: $(BIN_DIR)/.dirstamp FORCE
	$(Q)echo "SET(CTEST_CUSTOM_MAXIMUM_PASSED_TEST_OUTPUT_SIZE $(tests-output-log-limit))" > $@
	$(Q)echo "SET(CTEST_CUSTOM_MAXIMUM_FAILED_TEST_OUTPUT_SIZE $(tests-output-log-limit))" >> $@

# dummy newline function to force make
# to use one subshell per line on long test argument list
define NL


endef

PHONY += $(BIN_DIR)/CTestTestfile.cmake
$(BIN_DIR)/CTestTestfile.cmake: $(BIN_DIR)/DartConfiguration.tcl $(BIN_DIR)/CTestCustom.ctest $(firstword $(MAKEFILE_LIST)) FORCE
	$(Q)echo "# Generated test file" > $@
	$(Q)echo "SET(ENV{LD_LIBRARY_PATH} ../lib/host/:\$$ENV{LD_LIBRARY_PATH})" >> $@
	$(Q)echo "SET(ENV{PATH} ./:\$$ENV{PATH}:\$$ENV{KALRAY_TOOLCHAIN_DIR}/bin)" >> $@
	$(Q)for env in $(call gen_ctest_env,$(sort $(tests-env))); do echo "$$env" >> $@; done
	$(Q)$(foreach r,$(__host_runners),\
		$(foreach t,$(__host_$(r)_tests),$(Q)echo -e $(__$(t)_$(r)_cmd) \\n$(__$(t)_rem_$(r)_cmd) >> $@$(NL))\
	)
	$(Q)$(foreach core,cluster mppa,\
		$(foreach p,$(__mppa_runners),\
			$(foreach t,$(__$(core)_$(p)_tests),$(Q)echo -e $(__$(t)_$(p)_cmd) >> $@$(NL))\
		)\
	)

PHONY += __gen_ctest_file
__gen_ctest_file: $(BIN_DIR)/CTestTestfile.cmake FORCE

module_main_hooks += __gen_ctest_file

endif

endif

