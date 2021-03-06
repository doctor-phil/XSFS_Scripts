# XSFS_Scripts

This code builds off of the ztree-unleashed platform developed by researchers at the Cologne Laboratory for Economic Research.
Please visit https://cler1.gitlab.io/ztree-unleashed-doc/docs/installation/ for more information about ztree-unleashed.
Also, remember to cite their paper in the Journal of Behavioral and Experimental Finance if you use ztree-unleashed.

This folder MUST be placed on the desktop!

This code will set up a bunch of scripts for using the XS/FS server.

To use, first double click on the launcher called:
XS/FS ONE-TIME-SETUP

When prompted, enter your username for the server and
the domain of the server.

If you want, you can run the OPENSSH ONE-TIME SETUP launcher
This will create a secure SSH key for this VM on the server so
you don't need a password to log in each time. 

It is recommended but not required.
Also, remember to change the port number
(NOTE: we no longer need to modify the ports in generate_session.py)

The important launchers are "PRE-SESSION" and "POST-SESSION"
These can be found on the desktop after installation

To run an experiment on the server, follow these steps IN ORDER:
1. Run "PRE-SESSION"
2. Run "Start session" and follow the instructions

WHEN YOU ARE DONE:
1. Run "Terminate session". When prompted, type YES (all caps)
2. Run "POST-SESSION"

This code is licensed under the permissive MIT license. Please feel free to download the code and make changes as you see fit.
