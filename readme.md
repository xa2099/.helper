.helper
=======

This bash script is designed to be "sourced" into the bash environment, so that it
streamlines several very repetitive daily tasks.

- Change directories.
- Run commands.
- Edit files.
- Start, stop, restart and check status of services.


Installing
----------

Copy the script to your system using wget. Home directory is recommended.

`wget https://raw.githubusercontent.com/xa2099/.helper/main/.helper`

Activate the script using the "source" command.

`source .helper`

The script needs to be activated every time you login. To make it 
permanent add the above command to the "~/.profile" file. 



Quick Reference
---------------

- `.c`      Command to run.
- `.ch`     Command to load as last "history" item.
- `.cx`     Command to remove from the list.

- `.d`      Directory to change to.
- `.dx`     Directory to delete from the list.

- `.f`      File to edit.
- `.fx`     File to remove from the list.
- `.sc`     Service status.
- `.ss`     Service start.
- `.sx`     Service stop.
- `.sr`     Service restart.

- `.h`      Help.
- `.hf`     Help Full.
- `.t`      Templates.
- `.v`      Script version.
- `.o`      Output all lists.
- `.rem`    Remove helper.sh and associated files.


Services
--------

There are four commands that start, stop, restart and check status of services. All
command other than check status are followed by the check status command to inspect
that it executed correctly. 

- `.sc` Service Check. Example: `.sc salt-minion`
- `.sx` Service Stop. Example: `.sx salt-minion`
- `.ss` Service Start. Example: `.ss salt-minion`
- `.sr` Service Restart. Example: `.sr salt-minion`


Changing Directories
--------------------

`.d` command shows a list of directories with associated numbers and asks for the
choice to be changed to.

To add an entry to the list use `.d` followed by the directory path. For example
`.d /var/log`. You will be changed to this directory and the entry will be added
to the list. Now you can use the `.d` command to show the list, make a selection
and be taken to the directory. Note: Make sure to always use full path.

`.dx` command allow you to remove an entry from the list.


Executing Commands
------------------

`.c` command shows a list of commands with associated numbers and asks for the 
choice to be executed.

To add and entry to the list use `.c` followed by the command. For example
`.c ls -al /etc`. The command will be ran and the entry will be added to the 
list. Now you can use `.c` command to show the list, make a selection and the
command will be executed.

`.ch` command allows you to select a command from the list, but instead of
executing it adds it as a last entry to the "history". Now you can hit the
Up Arrow and load the command. This is useful when you need to edit the
command before executing it.

`.cx` command allow you to remove an entry from the list.


Editing Files
-------------

`.f` command shows a list of files to open in an editor.

To add an entry to the list use `.f` followed by the file path. For example
`.f /etc/sudoers`. The file will be open for editing using "nano" editor.
You don't have to worry about permissions. If the file is not writable by
the current user the "sudo" prefix will be used.  Note: Make sure to always 
use full path.

`.fx` command allow you to remove an entry from the list.


Output Lists
------------

`.o` command will print out all the list. It is useful if you want to copy
some of the commands for later use.


Templates
---------

`.t` command pulls a list of available templates from the repository. You
can select on of the templates. Once selected the directory, command and
file edit entries will be copied into your script.

This is very useful when working on multiple servers and having specific
sets of entries for certain type of work.

Warning: Importing templates will replace all the current entries in your 
lists. Importing templates a great way of staring on a new server with 
useful lists already available to you.


Remove
------

`.rem` command will remove all the files associated with the ".helper.sh"
script. You will be prompted to answer "yes" to confirm the command.


History
-------
Note that when the commands are run they are not registered in the "history". 
Instead the actual commands are added. For example, running `.d /var/log` will
show up in "history" as `cd /var/log`.
