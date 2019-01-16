This is the read me file for the Aircraft Sizing Tool
COPYRIGHT 2018 Jiajie (Terry) Wen

In the MATLAB code folder there are a lot of functions.

AST.mlapp is the MATLAB app (GUI) that's supposed to be run.
If one wants to change the APTA mission requirements, that can be easily done in designParametersAPTA.m
Please keep the inputs reasonable, otherwise there is a chance that the code might not converge. However it does behave pretty well in general.

The results are generated in the form of .txt files. This tool has been run previously, that's why the files are in the folder.

All the .m files are MATLAB functions except for mainAPTA.m and mainF86L.m
These two are the main MATLAB scripts that link everything together. The GUI calls these two scripts to run.

Enjoy!