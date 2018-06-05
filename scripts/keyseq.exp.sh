#!/usr/bin/expect

 set timeout 10
 set outfile ./keyseq.dat

 set prompt "Type any characters followed by <Return>, wait for $timeout seconds or press Ctrl-C
 The resulting character sequence will be written to $outfile

 Type here:
 "

 set showheader 1
 set seqsize 0
 puts $prompt

 expect {
   ? {
     set result $expect_out(0,string)
     if {![string equal \n $result]} {
       if {[catch {eof $fd}]} {
	 set fd [open $outfile w]
       }
       scan $result %c dvalue

       set show $result
       if {$dvalue==27} {
 	  set show Esc
       }
       if {$showheader} {
	 puts "\nWhat you have just entered I can see as the following byte sequence:\n"
	 set showheader 0
       }
       puts "'$show'\t(ASCII octal [format %4s [format %#o $dvalue]], decimal [format %3s $dvalue], hexadecimal [format %x $dvalue])"

       puts -nonewline $fd $result
       incr seqsize
     } {
       if {$seqsize==0} {
	 puts "You only typed Enter. $outfile is empty."
	 set seqsize 0
       }
       if {![catch {eof $fd}]} {
	 close $fd
	 puts "\n$outfile created.\n-+----\n$prompt"
	 set showheader 1
       }
     }
     exp_continue
   }
 }
