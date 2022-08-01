.helper
=======

This script is designed to streamline several very repetitive command line tasks.

- Change directories.
- Run commands.
- Edit files.


Installing
----------

Home directory is recommended.

`cd ~`

Copy the script to your system using wget.

`wget https://raw.githubusercontent.com/xa2099/.helper/main/.helper`

Activate the script using the "source" command.

`source .helper`

This is it.

Note: The script needs to be activated every time you login. To make it
permanent add the `source .helper` command to your "~/.profile" file.



Quick Reference
---------------

`.h` command shows quick help menu.


Manual
------

`.m` command will show this "readme.md" file in your concel for your convenience.


Directories
-----------

`.d` command shows a list of directories with associated numbers and asks for
the choice to be "changed to".

To add an entry to the list use `.d` followed by the full directory path. For
example `.d /var/log`. You will changed to this directory and the entry will be
added to the list. Now you can use the `.d` command to show the list, make a
selection and be taken to the directory. Note: Make sure to always use full
path.

`.dr` command allow you to remove an entry from the list.


Files
-----

`.f` command shows a list of files to open in an editor.

To add an entry to the list use `.f` followed by the file path. For example
`.f /etc/sudoers`. The file will be open for editing using "nano" editor.
You don't have to worry about permissions. If the file is not readable or
writable by the current user the "sudo" prefix will be used.  Note: Make sure
to always use full path.

`.fr` command allow you to remove an entry from the list.


Commands
--------

`.c` command shows a list of commands with associated numbers and asks for the
choice to be executed.

To add and entry to the list use `.c` followed by the command. For example
`.c "ls -al /etc"`. The command will be ran and the entry will be added to the
list. Now you can use `.c` command to show the list, make a selection and the
command will be executed. Note: Always wrap the command part with double quotes.

`.cl` command allows you to select a command from the list, but instead of
executing it adds it as a last entry to the "history". Now you can hit the
Up Arrow and load the command. This is useful when you need to edit the
command before executing it.

`.cr` command allow you to remove an entry from the list.


List
----

`.lp` command will print out the list of all saved choices. It is useful if
you want to copy the entries for the later use.

`.lg` command pulls a list of available lists from the repository. After
making a selection the list will be merged into your existing list.

You can select multiple lists to get, one at a time, and entries will be
added from each one. Items will only be added if they do not yet exist, so
there will be no duplicates.

This is very useful when working on multiple servers and having specific
sets of entries for certain types of work.

`.lr` removes all the current entries in the list. You will be prompted to
answer "yes" to confirm the command.


Remove
------

`.r` command will remove all the files associated with the ".helper"
script. You will be prompted to answer "yes" to confirm the command.


Update
------

`.u` command pulls the latest version of the script from the repo and
activates it using the "source" command.

Version
-------

`.v` command displays the current version.


History
-------

Note that when the commands are run they are not registered in the "history".
Instead the actual commands are added. For example, running `.d /var/log` will
show up in "history" as `cd /var/log`. Most of the commands that deal with
editing files and changing directories will not be added to the history as
they are not useful there.
