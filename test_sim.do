#======================================#
# TCL script for a mini regression     #
#======================================#

onbreak resume
onerror resume

# set environment variables

setenv UVM_SRC  ./tb
setenv TB_SRC   ./tb
setenv DUT_SRC  ./dut
setenv COMP_LIST complist.f
setenv RESULT_DIR result
setenv TB_NAME tb_dut
setenv LOG_DIR log

set timetag [clock format [clock seconds] -format "%Y%b%d-%H_%M"]
#clean the environment and remove trash files.....
set delfiles [glob work *.log *.ucdb sim.list]
file delete -force {*}$delfiles

#compile the design and dut with a filelist
vlib work

#complie cpp files
vlog ./uvm_env/cpp_ref_model/C_ref_model.c

echo prepare simrun folder
file mkdir $env(RESULT_DIR)/regr_ucdb_${timetag}
file mkdir $env(LOG_DIR)

#simulate with specific testname sequentially
set testname {ue_case0_test 2}
set seed [expr int(rand() * 100)]
echo seed:${seed}

vsim -onfinish stop -cvgperinstance -cvgmergeinstances -sv_seed $seed +UVM_TESTNAME=${testname} -l $env(RESULT_DIR)/regr_ucdb_${timetag}/run_${testname}_${seed}.log work.$env(TB_NAME)
run -all
coverage save $env(RESULT_DIR)/regr_ucdb_${timetag}/${testname}_${seed}.ucdb
quit -sim

#echo merge the ucdb per test

vcover merge -testassociated $env(RESULT_DIR)/regr_ucdb_${timetag}/regr_${timetag}.ucdb {*}[glob $env(RESULT_DIR)/regr_ucdb_${timetag}/*.ucdb]