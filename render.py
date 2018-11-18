#!/usr/bin/python
#
# Script to render STLs from command line, with thread per part rendering
# author: Jason Thrasher

import subprocess
import math
import time

# render the stl
def render():
	# render each part in a thread, so it all goes faster
	print 'Starting render'
	start = time.time()

	scad = []
	scad.append(subprocess.Popen(['openscad','-D', 'part=1','raspberry-pi-3-model-a-plus.scad','-o','raspberry-pi-3-model-a-plus.stl']))
	scad.append(subprocess.Popen(['openscad','-D', 'part=2','raspberry-pi-3-model-a-plus.scad','-o','case.stl']))
	# wait for all threads to finish, so we know we're done
	for p in scad:
		p.wait()

	elapsed = round(time.time() - start, 1)
	print 'Rendering done in', elapsed, 'seconds!'

def main():
	render()

main()