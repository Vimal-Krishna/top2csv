#!/bin/awk -f
BEGIN {
  header1 = "time, cpu_us, cpu_sy, cpu_ni, cpu_id, cpu_wa, mem_total, mem_used, mem_free"
  header2 = "time, process_name, cpu, mem"
  time = 0
  print header1 > "./sys_stats"
  print header2 > "./proc_stats"
  OFS = ", "
}

/^top/ { 
  time = $3 
  {	
    empty_lines = 0
    while(getline) {      
      if ($0 ~ /^$/) {
        break;
      }

      if ($1 ~ "Cpu") { 
        #print
        cpu_us=$2
        cpu_sy=$4
        cpu_ni=$6
        cpu_id=$8
        cpu_wa=$10
        #print NF
        if (NF == 16) {
          cpu_id=substr($7,4)  
          cpu_wa=$9
        } 
        #print us, sy, ni, id, wa
      } 

      if ($0 ~ /^KiB Mem/) {
        #print
        mem_total=$3
        mem_used=$5
        mem_free=$7 
        mem_buffers=$9
        #print mem_total, mem_used, mem_free, mem_buffers
      }

      if ($0 ~ /^KiB Swap/) {
        #print
        swap_total=$3
        swap_used=$5
        swap_free=$7
        cached_mem=$9 
        #print swap_total, swap_used, swap_free, cached_mem
      }
    }
    print time, cpu_us, cpu_sy, cpu_ni, cpu_id, cpu_wa, mem_total, mem_used, mem_free >> "./sys_stats"
  }
}
/^\s*PID/ {
  while(getline) {    
    if ($0 ~ /^$/) {
      break;
    }
    print time, $NF, $(NF-3), $(NF-2) >> "./proc_stats"
  }
}
