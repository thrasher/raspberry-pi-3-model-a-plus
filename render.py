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
	# plain image
	scad.append(subprocess.Popen(['openscad','raspberry-pi-3-model-a-plus.scad','-o','render.png','--preview','--imgsize=626,470']))

	scad.append(subprocess.Popen(['openscad','raspberry-pi-3-model-a-plus.scad','-o','raspberry-pi-3-model-a-plus.stl','-D', 'part=1']))
	scad.append(subprocess.Popen(['openscad','raspberry-pi-3-model-a-plus.scad','-o','raspberry-pi-3-model-a-plus.png','-D', 'part=1','--preview','--imgsize=626,470']))

	scad.append(subprocess.Popen(['openscad','raspberry-pi-3-model-a-plus.scad','-o','case.stl','-D', 'part=2']))
	scad.append(subprocess.Popen(['openscad','raspberry-pi-3-model-a-plus.scad','-o','case.png','-D', 'part=2','--preview','--imgsize=626,470']))

	scad.append(subprocess.Popen(['openscad','raspberry-pi-3-model-a-plus.scad','-o','case-vesa-75.stl','-D', 'part=3','-D', 'VESA_SIZE=75']))
	scad.append(subprocess.Popen(['openscad','raspberry-pi-3-model-a-plus.scad','-o','case-vesa-75.png','-D', 'part=3','-D', 'VESA_SIZE=75','--preview','--imgsize=626,470']))

	scad.append(subprocess.Popen(['openscad','raspberry-pi-3-model-a-plus.scad','-o','case-vesa-100.stl','-D', 'part=3','-D', 'VESA_SIZE=100']))
	scad.append(subprocess.Popen(['openscad','raspberry-pi-3-model-a-plus.scad','-o','case-vesa-100.png','-D', 'part=3','-D', 'VESA_SIZE=100','--preview','--imgsize=626,470']))

	scad.append(subprocess.Popen(['openscad','raspberry-pi-3-model-a-plus.scad','-o','lid.stl','-D', 'part=4']))
	scad.append(subprocess.Popen(['openscad','raspberry-pi-3-model-a-plus.scad','-o','lid.png','-D', 'part=4','--preview','--imgsize=626,470']))

	# wait for all threads to finish, so we know we're done
	for p in scad:
		p.wait()

	elapsed = round(time.time() - start, 1)
	print 'Rendering done in', elapsed, 'seconds!'

def main():
	render()

main()