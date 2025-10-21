transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

asim +access +r +m+test_ALS_PMOD_BFM  -L xil_defaultlib -L xpm -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.test_ALS_PMOD_BFM xil_defaultlib.glbl

do {test_ALS_PMOD_BFM.udo}

run 1000ns

endsim

quit -force
