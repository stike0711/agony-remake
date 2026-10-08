assign NCOMM: sys:modem/ncomm
assign AUDIOMASTERIII: sys:sound_util
assign ST-00: sys:sound_util
assign T: ram:
assign csh: sys:dev_util/CShell/

set _path dh0:,dh1:,dh0:c/,df0:,df0:c/,dh0:gr_util/,dh0:disk_util/,dh0:dev_util/,dh0:dev_util/devpac/,dh0:dev_util/packer/,dh0:sound_util/,dh0:modem/,sys:modem/ncomm/

set f1 "x s:asm\12"
set f2 "run ads\12"
set f3 "run gfa\12"
set f4 "run dpaint\12"
set f5 "run pixmate\12"
set f6 "dm\12"
set f7 "x-copy\12"
set f8 "x s:ex\12"
set f9 "Powerpacker\12"
set f10 "Qb\12"
set F1 "gfa work:agony/disk/create_label.gfa\12echo done.\12"

window 0 12 640 388

set _titlebar CShell V5.16 / Art & Magic
set _prompt "%c%n-%f:%p>"
alias x source
echo
date
echo
info
echo
mem
echo
cd work:
rback machIII
