#!/usr/bin/env python

import sys
import os
from subprocess import check_output, call

if len(sys.argv) < 2:
	print "Usage: tune_pg.py <postgresql.conf.in> <postgresql.conf>"
	print "This script examines the amount of ram in a machine and "
	print "then configures postgresql.conf for those settings in "
	print "hopes of automaticall configuring a decent Postgres setup."
	sys.exit(-1)

if os.getuid() != 0:
	print "This program needs to be run as root!"
	sys.exit(-1)

# get memory statistics from free
for line in check_output(["free", "-b"]).split("\n"):
    if line.startswith("Mem"): break

total_ram= int(line.split()[1])
free = int(line.split()[3])
cached = int(line.split()[6])

# Given these formulas, calculate PG settings. Some of these values are from
# http://wiki.postgresql.org/wiki/Tuning_Your_PostgreSQL_Server
shared_buffers = total_ram / 4
effective_cache_size = free + cached
work_mem = 20 * 1024 * 1024
shmmax = int(shared_buffers * 1.12)

print "Using the following postgres optimization settings:"
print "   shared_buffers: %dMB" % (shared_buffers / 1024 / 1024)
print "   effective_cache_size = %dMB" % (effective_cache_size / 1024 / 1024)
print "   work_mem = %dMB" % (work_mem / 1024 / 1024)
print "   shmmax = %d" % (shmmax)

infile = open(sys.argv[1])
config_file = infile.read()
infile.close()

config_file = config_file.replace("@shared_buffers@", "shared_buffers = %dMB\n" % (shared_buffers / 1024 / 1024))
config_file = config_file.replace("@effective_cache_size@", "effective_cache_size = %dMB\n" % (effective_cache_size / 1024 / 1024))
config_file = config_file.replace("@work_mem@", "work_mem = %dMB\n" % (work_mem / 1024 / 1024))

outfile = open(sys.argv[2], "w")
outfile.write(config_file)
outfile.close()

call(["/sbin/sysctl", "-w", "kernel.shmmax=%d" % (shmmax)])
