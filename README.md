# ArkProfileBackup
PowerShell script who save profile's players of all your cluster.

TUTO :

-Put the script at the root of the server folder
-Change, add folders to backup by configuring the script
-Start the script witch PowerShell ISE ( admin)
-When you loose a Profile, go on backup folder
-Find the right profile with the steam ID and rename the file keeping only the steam ID in the file name then put the file back in the "Live" folder of the server.
( ex : C:\asmdata\Servers\Server1\ShooterGame\Saved\SavedArks )
-Restart the server
-Enjoy !


The script performs an automatic backup every 6 hours provided the script is not closed. So you have to make sure you keep it running all the time.
