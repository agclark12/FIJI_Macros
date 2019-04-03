'''
This script aligns a two channel timelapse image
in two colors with TurboReg.

The user is prompted for the image path and the reference channel.
Other channel(s) are shifted accordingly.

The user can also select the type of registration (rigidBody or Affine)


Written April 29th, 2010, by Johannes Schindelin
Converted to a Jython script, modified October 2010 by JS.
Modified October 2010 by Andrew Clark
Modified October 2017 by Andrew Clark
'''

from copy import deepcopy
import time

from ij import IJ, ImagePlus, ImageStack
from ij.gui import GenericDialog
from ij.io import OpenDialog, FileSaver
from ij.macro import Interpreter
from java.io import File
import TurboReg_

outputFormat = "Tiff"
outputExtension = "_reg.tif"

def batchTurboReg(image, referenceChannel, regType):

	#gets image info
	dims = image.getDimensions()
	w = dims[0]
	h = dims[1]
	channels = dims[2]
	slices = dims[3]
	frames = dims[4]
	min = image.getDisplayRangeMin()
	max = image.getDisplayRangeMin()
	stack = image.getStack()
	out = ImageStack(w, h)
	first = ImagePlus("first-slice", stack.getProcessor(1))
	first.show()
	
	for frame in range(1, frames + 1):
	
		#runs turboReg to get alignment from the referenceChannel
		stackIndex = image.getStackIndex(referenceChannel, 1, frame)
		current = ImagePlus("current-slice", stack.getProcessor(stackIndex))
		current.show()
		turboReg = TurboReg_()
		turboReg.run("-align -window current-slice 0 0 " + str(w - 1) + " " + str(h - 1)
			+ " -window first-slice 0 0 " + str(w - 1) + " " + str(h - 1)
			+ " -"+ regType +" "
			+ str(w / 2) + " " + str(h / 2) + " " # Source translation landmark.
			+ str(w / 2) + " " + str(h / 2) + " " # Target translation landmark.
			+ "0 " + str(h / 2) + " " # Source first rotation landmark.
			+ "0 " + str(h / 2) + " " # Target first rotation landmark.
			+ str(w - 1) + " " + str(h / 2) + " " # Source second rotation landmark.
			+ str(w - 1) + " " + str(h / 2) + " " # Target second rotation landmark.		
			+ " -hideOutput")
		current.close()
		sourcePoints = turboReg.getSourcePoints()
		targetPoints = turboReg.getTargetPoints()
		transform = "-" + regType + " " \
			+ str(sourcePoints[0][0]) + " " + str(sourcePoints[0][1]) + " " \
			+ str(targetPoints[0][0]) + " " + str(targetPoints[0][1]) + " " \
			+ str(sourcePoints[1][0]) + " " + str(sourcePoints[1][1]) + " " \
			+ str(targetPoints[1][0]) + " " + str(targetPoints[1][1]) + " " \
			+ str(sourcePoints[2][0]) + " " + str(sourcePoints[2][1]) + " " \
			+ str(targetPoints[2][0]) + " " + str(targetPoints[2][1]) + " "

		#applies transformation for all channels
		for channel in range(1, channels + 1):
			stackIndex = image.getStackIndex(channel, 1, frame)
			current = ImagePlus("current-slice", stack.getProcessor(stackIndex))
			current.show()
			turboReg = TurboReg_()
			turboReg.run("-transform"
				+ " -window current-slice " + str(w) + " " + str(h)
				+ " " + transform
				+ " -hideOutput")
			current.close()
			outSlice = turboReg.getTransformedImage()
			out.addSlice("", outSlice.getProcessor())

	#closes images
	first.close()
	image.close()
	result = ImagePlus("TurboReg-out", out)
	result.setDisplayRange(min, max)
	return result

def main():

	#selects image path to open
	od = OpenDialog("Choose image file", None)
	file_path = od.getDirectory() + od.getFileName()

	#opens image and gets info
	image = IJ.open(file_path)
	image = IJ.getImage()		
	dims = image.getDimensions()
	w = dims[0]
	h = dims[1]
	channels = dims[2]
	slices = dims[3]
	frames = dims[4]

	#gets reference channel and registration type from user
	gd = GenericDialog("MultiChannel Registration")
	items = [str(_) for _ in range(1,channels+1)]
	gd.addRadioButtonGroup("Reference Channel", items, 1, len(items), "1")
	gd.addRadioButtonGroup("Registration Type", ["rigidBody", "affine"], 1, 2, "rigidBody")
	gd.showDialog()
	if gd.wasCanceled():
		print "User canceled dialog!"
		return
	else:
  		#reads out the choices  
  		ch_ref = int(gd.getNextRadioButton())
  		reg_type = gd.getNextRadioButton()
  		print "Reference Channel: " + str(ch_ref)
  		print "Registration Type: " + reg_type

  		#performs registration and outputs the registered stack
  		batchTurboReg(image, ch_ref, reg_type).show()
  		registered = IJ.getImage()
  		IJ.run("16-bit")
  		print registered.getDimensions()

		#re-convert to hyperstack (I don't understand why this doesn't get saved!)
		IJ.run("Stack to Hyperstack...", "order=xyczt(default) \
			channels=%i slices=1 frames=%i display=Grayscale" %(channels, frames))
		min = registered.getDisplayRangeMin()
		max = registered.getDisplayRangeMin()
		registered.setDisplayRange(min, max)

		out_path = file_path[:-4] + "_reg_" + reg_type + ".tif"
		IJ.saveAs(registered, "Tiff", out_path)

		image.close()
		registered.close()
		IJ.run("Close All")


main()
	
