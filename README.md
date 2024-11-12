# Ramp Marshall

A marshaller that guides you into your gate.

Original idea, models and scripts by omega95.

Now can be installed as an addon for FlightGear 2018+ version.

The addon requires only two action by the user to install.

1) It requires a command line flag as follows...
In the file explorer of your operating system, find the directory `$FG_HOME/Export/Addons/org.flightgear.addons.rampmarshall.
This path must be added by the `--data` command line option, so it will be treated as an additional FGData directory.
In Launcher go to "Settings" tab and in "Additional Setting" type...
On the Linux system:
--data=/home/{username}/.fgfs/Export/Addons/org.flightgear.addons.rampmarshall
On the Windows:
--data=C:\Users\{username}\AppData\Roaming\flightgear.org\Export\Addons\org.flightgear.addons.rampmarshall
or use these flags in a command line.

2) Select the RampMarshall Addon from the list of addons in the launcher.

TODO:
Tune resolution or fidelity of edit position movements, they are coarser than they should be.
Fix the "aircraft front gear" adjustment, it hasn't been added yet.
Fix the edit "altitude" adjustment, I still have to debug it and figure out why it isn't working.
Clean up..
Docs to explain it use and configuration.
Wiki rewrite, see the Readme file for the wiki address of the current wiki article. This article was written for the nasal installed version.

- Learn how to add marshallers to airports [Wiki - Ramp Marshall](http://wiki.flightgear.org/Ramp_Marshall) (Installation instruction in the wiki are OBSOLETE)
- Original post on fórum [Forum - Ramp Marshaller](https://forum.flightgear.org/viewtopic.php?t=20572)


