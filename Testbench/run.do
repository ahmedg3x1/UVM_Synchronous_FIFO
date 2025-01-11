vlib work
vlog -f src_files.list +cover -covercells
vsim -voptargs=+acc work.top -cover -classdebug -uvmcontrol=all
add wave -color white /top/FIFO_if/clk
add wave -color Magenta /top/FIFO_if/rst_n
add wave -color Cyan /top/FIFO_if/wr_en
add wave -color Cyan /top/FIFO_if/rd_en
add wave /top/FIFO_if/data_in
add wave -color Coral /top/FIFO_if/almostempty
add wave -color Coral /top/FIFO_if/empty
add wave -color Yellow /top/FIFO_if/underflow
add wave -color {Medium Slate Blue} /top/FIFO_if/almostfull
add wave -color {Medium Slate Blue} /top/FIFO_if/full
add wave -color Yellow /top/FIFO_if/overflow
add wave -color Yellow /top/FIFO_if/wr_ack
add wave /top/FIFO_if/data_out
coverage save top.ucdb -onexit 
run -all