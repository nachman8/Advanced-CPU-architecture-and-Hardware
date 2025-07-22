# LAB2
***********************************************************************
The system module is :

*******************INPUTS:***************************************
**signal X[j] - n bit vector number 
**DetectionCode -the condition that we check:
	0 - X[j-1] - X[j-2] =1
	1 - X[j-1] - X[j-2] =2
	2 - X[j-1] - X[j-2] =3
	3 - X[j-1] - X[j-2] =4

*******************OUTPUTS:***************************************
detector - a bit signal that set to 1 when there are more  or equal to m valid values.

********************* TOP (top.vhd`)************************************
The module which wraps the entire system.

                               **** procces 1 ****
	create Two FlipFlops in order to save X[j-1], X[j-2].

                               **** procces 2 ****
-recognize which detection rule to chek and convert him to n digit binary vector
- use the adder entity to do sum : X[j-2] + condition +1
-set valid bit when the sum is equal to X[j-1]

                               **** procces 3 ****
heck if the valid are set and how long the valid series if it more than m the detector is set


********************* Adder (`adder.vhd`)************************************
This module performs an add operation between two - n bits vectors and carry in, return the sum of the vectors and carry in.

********************* Package (`aux_package.vhd`)************************************
A package file which contains all the components that we would use in this lab.
