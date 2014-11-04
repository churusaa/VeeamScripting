# Move the full backup created today and write the file to tape
# Nathanael Duke - nathanael.j.duke@gmail.com
# Licensed under GPLv2
# You are free to modify, distribute, and use this script within the limits of your
# license agreement with the authors of the tools upon which I have built.

# This script requires Veeam Backup & Replication version 7 PowerShell snapins,
# which can be installed from the Veeam Backup & Replication version 7 installation
# media.

# For this script to work, a "Files to Tape" job must be created that points to a
# temporary directory on the same physical volume and drive letter as the source 
# backups, and must not be set to run automatically. Spaces and special characters
# in the name should be fine.

# This script will move the full backup file that was created today to the temp
# directory, run the files to tape backup job, then move the file back to where it
# came from after the job completes.

# get-date.tostring("yyyy-MM-dd")T*.vbk can be modified to afford greater granularity
# for example, selecting a VBK that was created within the hour would look like this
# get-date.tostring("yyyy-MM-ddTHH")*.vbk
# Only taking the 9:00 PM full backup would look like this
# get-date.tostring("yyyy-MM-dd")T21*.vbk

# "T" points literally to the letter T in the file name after the date string.

Add-PSSnapin VeeamPSSnapin

# Move the .vbk matching today's date to a temporary holding directory
# <Job name> should exactly match the name of your .vbk file before the date/time string
# Spaces are fine inside the quotes
move-item "<Path to original backup Directory>\<Job name>$((get-date).tostring("yyyy-MM-dd"))T*.vbk" -destination "<Path to temporary directory>"\

# ---this is where the code goes that kicks off DailyDuplicate_only_most_recent_full---

Get-VBRTapeJob -name "<Files to Tape Job name>" | Start-VBRJob 

# Move everything back

move-item "<Path to temporary directory>"\* -destination "<Path to original backup directory>"\
