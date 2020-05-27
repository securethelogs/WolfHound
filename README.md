# WolfHound

![Wolfhound](https://ctrla1tdel.files.wordpress.com/2020/05/wolfhound.gif)

## About
WolfHound is a script to help identify potential threats and to assist with threat hunting. It runs in memory and allows you to perform the following: 

- Scan for malicious files (Based on file hashes)
- Scan for malicious files (Based on Bad IP list)
- Scan events for malicious and suspicious activity
- Scan tasks for suspicious activity (Persistence – System level at start-up)

The scan can be custom to you and you can search for a list of custom hashes or IPs or use an open source list. This can be useful for machines that have non-AV requirements, or you want to query without removing any files/content. 


## Running
You can either fork this repository or download the script to be able to edit. The following lines allow you to change WolfHound to fit your needs. 

Line 105 - Edit the location for the temp file. The gets deleted after and is just used to order the array. 
*$tmp = "C:\temp\tmp.txt"

Line 109 - Edit this for the location of the hashes. The default is just an example. 
*(curl https://raw.githubusercontent.com/securethelogs/WolfHound/master/Hashes/md5_hashes.txt -UseBasicParsing).content | Out-File $tmp

Line 133 - Edit this if your are using hashes other than MD5. Change the MD5 to the needed, i.e SHA256
*$fh = (Get-FileHash -Path $o -Algorithm MD5 -ErrorAction SilentlyContinue).Hash 

Line 194 - Edit the location for the temp file. The gets deleted after and is just used to order the array.
*$tmp = "C:\temp\tmp.txt"

Line 198 - Edit this for the location of Bad IPs. The default is just an example. 

*(curl https://raw.githubusercontent.com/securethelogs/WolfHound/master/BadIPs/IPs.txt -UseBasicParsing).content | Out-File $tmp


## How it works
WolfHound uses multiple session and jobs to run the tasks in parallel. It does this to stack the results and keep the flow rather than halting. Because of this, it uses WinRM as it needs to run the PSSession locally. 

The scan takes the longest, and the average being: 

![AVscan](https://ctrla1tdel.files.wordpress.com/2020/05/avscan.jpg)


