'''
This script aligns a two channel timelapse image
in two colors with TurboReg, using channel 2 as the
reference channel and shifting channel 1 accordingly.

Written April 29th, 2010, by Johannes Schindelin
Converted to a Jython script, modified October 2010 by JS.
Modified October 2010 by Andrew Clark
'''

from ij import IJ, ImagePlus, ImageStack
from ij.macro import Interpreter
from java.io import File
import TurboReg_

basename = "PAGFP-mCry-Actin_"
suffix = "_cmle_deconvShift_z1"
extension = ".tif"
firstimagenumber = 3
lastimagenumber = 6
outputFormat = "Tiff"
outputExtension = "_reg.tif"
zslice = 1

def batchTurboReg(image, referenceChannel):
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
	first = ImagePlus("first-slice", stack.getProcessor(referenceChannel))
	first.show()
	for frame in range(1, frames + 1):
	#for slice in range(2, 3):
		stackIndex = image.getStackIndex(referenceChannel, 1, frame)
		current = ImagePlus("current-slice", stack.getProcessor(stackIndex))
		current.show()
		turboReg = TurboReg_()
		turboReg.run("-align -window current-slice 0 0 " + str(w - 1) + " " + str(h - 1)
			+ " -window first-slice 0 0 " + str(w - 1) + " " + str(h - 1)
			+ " -rigidBody "
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
		transform = "-rigidBody " \
			+ str(sourcePoints[0][0]) + " " + str(sourcePoints[0][1]) + " " \
			+ str(targetPoints[0][0]) + " " + str(targetPoints[0][1]) + " " \
			+ str(sourcePoints[1][0]) + " " + str(sourcePoints[1][1]) + " " \
			+ str(targetPoints[1][0]) + " " + str(targetPoints[1][1]) + " " \
			+ str(sourcePoints[2][0]) + " " + str(sourcePoints[2][1]) + " " \
			+ str(targetPoints[2][0]) + " " + str(targetPoints[2][1]) + " "
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
	first.close()
	image.close()
	result = ImagePlus("TurboReg-out", out)
	result.setDisplayRange(min, max)
	return result

#batchTurboReg(IJ.getImage(), 2).show()

directory = IJ.getDirectory("Image directory (containing " + extension + " files)")
print(directory)
for i in range(firstimagenumber, lastimagenumber + 1):
	image = IJ.open("%s%s%i%s%s" %(directory,basename,i,suffix,extension))

	#convert to single z-slice
	image = IJ.getImage()
	dims = image.getDimensions()
	w = dims[0]
	h = dims[1]
	channels = dims[2]
	slices = dims[3]
	frames = dims[4]
#	IJ.setSlice(zslice*2-1)
#	IJ.run("Reduce Dimensionality...", "channels frames")
	
	batchTurboReg(IJ.getImage(), 2).show()

	#re-convert to hyperstack
	IJ.run("16-bit")
	IJ.run("Stack to Hyperstack...", "order=xyczt(default) \
		channels=2 slices=1 frames=%i display=Grayscale" %(frames))
	image = IJ.getImage()
	
	#save
	IJ.saveAs(image, outputFormat, "%s%s%i%s%s" %(directory,basename,i,suffix,outputExtension))
	image.close()
