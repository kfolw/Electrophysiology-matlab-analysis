# Electrophysiology-matlab-analysis


popspikemeasurement.m file is a matlab script for analysis of population spike amplitude in extracellular field potential recordings. It relies on abfload function, which reads an .abf file from pClamp software into matlab variables. The pop spike amplitude is calculated by drawing lines between four points: 1 & 2) the peaks preceding and following the popspike, 3) the following peak and the trough of the popspike, and 4) the trough and a point on approximately the middle of the first line (double click to end). Script will just take the Euclidean distance between the trough and the "peak line", with units in mV. 
