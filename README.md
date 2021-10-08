# LocalGroupPolicy-TransferTool

- This is a graphical tool that exports all group policy settings from a single machine and generates an import directory and script to be run on the target machine.

- Use cases include 
  -  securing non-domain machines with policy borrowed from a domain machine
  -  duplicating local security policy/local group policy across multiple non-domain machines.
  -  backing up policy to a local or network drive

- The script must be run as admin and the backup location must not include any existing group policy data.  


## Considerations:

If you are exporting from a domain machine, keep in mind that any domain principals (i.e. users and groups) will not exist locally on a non-joined machine.  Use extreme caution in transferring policy from a domain machine to non-domain machines; it is possible to lock local users out of the target machine permanently (depending on if/what principals are given access via the source policies and if/what built-ins are denied access).  

I strongly advise using this utility to backup your target machine policies first before transferring new policy to the target machine.  Better safe than sorry.  
