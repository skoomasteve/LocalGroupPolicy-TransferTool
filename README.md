# LocalGroupPolicy-TransferTool

- This is a graphical tool that exports all group policy settings from a source machine and generates an import file and script to be run on the target machine.

- Use cases include:
  -  securing non-domain machines with policy borrowed from a domain machine
  -  duplicating local security policy/local group policy across multiple non-domain machines.
  -  backing up policy to a local or network drive

- The script must be run as admin and the backup location must not include any existing group policy data.  


## Considerations:

If you are exporting from a domain machine, keep in mind that any domain principals (i.e. users and groups) will not exist locally on a non-joined machine.  Use extreme caution in transferring policy from a domain machine to non-domain machines and ensure you wont be locking out any essential built-in users/groups).  

I strongly advise using this utility to backup your target machine policies first before transferring new policy to the target machine.    
