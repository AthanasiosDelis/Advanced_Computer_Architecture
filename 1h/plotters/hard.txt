#!/usr/bin/env python
#automating time consuming+boring stuff
#Unfortunatly I understsood the need for 
#the existance of this program the hardway for L1 files
import sys
import os

benchmarcks = {
	"blackscholes",
	"bodytrack",
	"canneal",
	"facesim",
	"ferret",
	"fluidanimate",
	"freqmine",
	"rtview",
	"streamcluster",
	"swaptions",
}


for benchmarck in benchmarcks:

	path=("/home/thanasis/advcomparch-2019-2020-ex1-helpcode/outputs_L2_prf/" + str(benchmarck)) 
	dirList=os.listdir(path)
	with open("/home/thanasis/advcomparch-2019-2020-ex1-helpcode/outputs_L2_prf/" + str(benchmarck) + "/names.txt", "w") as f:
    		for filename in dirList:
			print (filename)
			f.write(filename)
#It works by writing every in a names.txt that creates inside
#/home/thanasis/advcomparch-2019-2020-ex1-helpcode/ directory
#Help code to prepare files hierarchy for my custum made plot creation files
