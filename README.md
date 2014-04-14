plesk-api
=========

contains ruby scripts that uses plesk api to perform plesk functions

The script uses plesk RPC API to perform function such as :-
1. checking status of domain
2. deactivate domain
3. activate domain
4. checking backup available in local repository for domain
5. generating full backup of domain
6. download the backup file

the script works well on both windows and linux till 5th point. The 6th point i.e. to download backup works on linux only.

The RPC API supports many other funciotns. More details can be found at http://download1.parallels.com/Plesk/PP11/11.5/Doc/fr-FR/online/plesk-api-rpc/
