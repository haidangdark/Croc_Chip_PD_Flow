foreach term [dbget top.terms] {
	set ptx [dbget ${term}.pt_x]
	set pty [dbget ${term}.pt_y]
	set x1 [expr $ptx - 0.5]
	set y1 [expr $pty - 0.5]
	set x2 [expr $ptx + 0.5]
	set y2 [expr $pty + 0.5]
	eval "createPhysicalPin [dbget ${term}.name] -layer TopMetal2 -samePort -rect {$x1 $y1 $x2 $y2}"
}


