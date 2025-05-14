#!/bin/bash

print_cpu_usage() {
  nproc=$(nproc)
  echo "Top CPU-consuming processes:"
  ps -eo comm,pcpu --no-headers | \
    awk -v cores=$nproc '{cpu[$1]+=$2} END {for (c in cpu) printf "%-20s %6.2f%%  %6.2f%% of total\n", c, cpu[c], cpu[c]/cores}' | \
    sort -k2 -nr | head
  echo ""
}

print_process_stats() {
  tasks=$(ps -e -o pid= | wc -l)
  threads=$(ps -eLo pid= | wc -l)
  running=$(ps -eo state | grep -c "^R")
  echo "Tasks: $tasks, $threads thr; $running running"
  echo ""
}

print_load_uptime() {
  read load1 load5 load15 _ < /proc/loadavg
  echo "Load average: $load1 $load5 $load15 -- cores: $(nproc)"
  echo -n "Uptime: "
  uptime -p
  echo ""
}

print_memory_usage() {
  echo "Memory usage:"
  free -h | awk '/^Mem:/ {printf "  Used: %s / %s (%.1f%%)\n", $3, $2, ($3/$2)*100}'
  echo ""
}

print_network_usage() {
  echo "Network usage:"
  awk -F: '
    NR > 2 {
      iface = $1; gsub(" ", "", iface);
      if (iface != "lo") {
        split($2, stats, " ");
        rx += stats[1];
        tx += stats[9];
      }
    }
    END {
      printf "  RX: %.2f MB  TX: %.2f MB\n", rx / 1024 / 1024, tx / 1024 / 1024
    }
  ' /proc/net/dev
  echo ""
}

print_disk_usage() {
  echo "Disk usage:"
  echo "  Mount       Used    Avail   Use%   FS"
  df -h --output=target,used,avail,pcent,fstype | awk '
    NR==1 { next }
    $5 ~ /ext|xfs|btrfs|zfs|f2fs/ {
      printf "  %-10s %-7s %-7s %-6s %-s\n", $1, $2, $3, $4, $5
    }
  '
  echo ""
}

main() {
  print_cpu_usage
  # print_process_stats
  print_load_uptime
  print_memory_usage
  # print_network_usage
  print_disk_usage
}

main

