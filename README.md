WRITEBACKUP TO ADJACENT DIR
===============================================================================
_by Ingo Karkat_

Redirect backups made by the writebackup plugin that would normally go into
the original file's directory into an adjacent directory with a "{dir}.backup"
name, if it exists. This allows to use the plugin in places where backup files
would cause problems.

DESCRIPTION
------------------------------------------------------------------------------

Many customization directories (e.g. /etc/profile.d/) consider all contained
files, regardless of file extension or execute permissions. Creating a
{file}.YYYYMMDD[a-z] backup in there causes trouble and strange effects,
because the backups are used in addition to the main configuration file - not
what was intended! However, putting the backups in the same directory
generally is a good idea - just not for these special directories.

This plugin offers a solution by integrating into the writebackup.vim plugin
so that it checks for a directory with a '.backup' extension (e.g.
/etc/profile.d.backup/), and places the backups in there, in case it exists.
In all other cases, the backup is made in the default directory, as before.

USAGE
------------------------------------------------------------------------------

    Adjacent backup directories are never created by this plugin; you have to
    create such a directory yourself to indicate that backups should be placed in
    there.

    :WriteBackupMakeAdjacentDir [../..|/path/to/dir] [{prot}]
                    Create a backup directory adjacent to the current file's
                    directory, or in a parent of that ("..", "../..", etc.), or of
                    any passed directory.
                    If {prot} is given it is used to set the protection bits;
                    default is 0755.

    After the adjacent backup directory has been created, just use :WriteBackup
    as before.

INSTALLATION
------------------------------------------------------------------------------

The code is hosted in a Git repo at
    https://github.com/inkarkat/vim-writebackupToAdjacentDir
You can use your favorite plugin manager, or "git clone" into a directory used
for Vim packages. Releases are on the "stable" branch, the latest unstable
development snapshot on "master".

This script is also packaged as a vimball. If you have the "gunzip"
decompressor in your PATH, simply edit the \*.vmb.gz package in Vim; otherwise,
decompress the archive first, e.g. using WinZip. Inside Vim, install by
sourcing the vimball or via the :UseVimball command.

    vim writebackupToAdjacentDir*.vmb.gz
    :so %

To uninstall, use the :RmVimball command.

### DEPENDENCIES

- Requires Vim 7.0 or higher.
- Requires the ingo-library.vim plugin ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)), version 1.022 or
  higher.
- Requires the writebackup.vim plugin ([vimscript #1828](http://www.vim.org/scripts/script.php?script_id=1828)), version 1.30 or
  higher.
- The writebackupVersionControl.vim plugin ([vimscript #1829](http://www.vim.org/scripts/script.php?script_id=1829)), which
  complements writebackup.vim, fully supports this extension, but is not
  required.

CONFIGURATION
------------------------------------------------------------------------------

For a permanent configuration, put the following commands into your vimrc:

To change the name of the adjacent backup directory, specify a different
template via

    let g:WriteBackupAdjacentDir_BackupDirTemplate = '%s.backup'

This must contain the "%s" placeholder, which is replaced with the original
file's directory, e.g. "backup of %s".

This plugin injects itself into writebackup.vim via the
g:WriteBackup\_BackupDir configuration. Its previous value is saved in
g:WriteBackupAdjacentDir\_BackupDir and used as a fallback, when no adjacent
directory exists. If you need to change the fallback after sourcing the
plugins, use the latter variable. However, to override this for a particular
buffer, you still have to use the b:WriteBackup\_BackupDir variable, as this
plugin does not provide yet another override.

By default, the plugin also searches for backup directories in upper
directories (until it reaches the file system root), and then re-creates the
path to the current file inside that parallel backup directory hierarchy. If
you want to revert to the version 1.x behavior of the plugin, turn this off
via:

    let g:WriteBackupAdjacentDir_IsUpwardsBackupDirSearch = 0

CONTRIBUTING
------------------------------------------------------------------------------

Report any bugs, send patches, or suggest features via the issue tracker at
https://github.com/inkarkat/vim-writebackupToAdjacentDir/issues or email
(address below).

HISTORY
------------------------------------------------------------------------------

##### 2.02    RELEASEME
- Use ingo#compat#glob().

__You need to update to ingo-library ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)) version 1.022!__

##### 2.01    29-Jan-2014
- Compatibility: Fix Funcref errors for Vim 7.0/1.

##### 2.00    02-Aug-2013
- ENH: Implement upwards directory hierarchy search for backup directories,
  and then re-create the path to the current file inside that parallel backup
  directory hierarchy.
- ENH: :WriteBackupMakeAdjacentDir now optionally also takes a target
  directory to better support the new upwards directory hierarchy search.
- Abort :WriteBackupMakeAdjacentDir on error.
- Add dependency to ingo-library ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)).

__You need to separately
  install ingo-library ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)) version 1.011 (or higher)!__

##### 1.10    17-Feb-2012
- ENH: Save configured g:WriteBackup\_BackupDir and use that as a fallback
instead of always defaulting to '.', thereby allowing absolute and dynamic
backup directories as a fallback. Suggested by Geoffrey Nimal.

##### 1.00    02-Jun-2010
- First published version.

##### 0.01    01-Jun-2010
- Started development.

------------------------------------------------------------------------------
Copyright: (C) 2010-2020 Ingo Karkat -
The [VIM LICENSE](http://vimdoc.sourceforge.net/htmldoc/uganda.html#license) applies to this plugin.

Maintainer:     Ingo Karkat &lt;ingo@karkat.de&gt;
