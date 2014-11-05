# This is my standard config for unix-like systems.

## How it works

Sensitive data is encrypted using a modified\* version of
[gitcrypt](https://github.com/shadowhand/git-encrypt).

*\* Specifically, I changed it to be a git subcommand (eg `git encrypt`) and
to have more consistent config naming.*

It comes bundled with an installer (`./install`) that will put all the files
in the appropriate places.  It's configured by two dotfiles of its own:
`.installignore` has a list of regexps where if the filename matches it
won't be installed, currently this is files that start with a period and
files that end in `.md`.  `.non-dit-dirs` is a list of directories who
shouldn't have their names prefixed with a dot when they're installed,
currently bin, git-bin and svn-bin.

The installer itself will create a ~/.etc git repository for you that holds
actual copies of all of your dotfiles, named as they would be in your home
directory.  It then symlinks those into your home directory.  When copying
updates into ~/.etc it stashes local changes first, installs the updates,
then restores the stash.  This allows you to make local changes and not have
them clobbered by updates-- it also makes it a lot easier to propagate local
changes back to this repository.

Files ending in .patch are encrypted and used to add sensitive information
to config files that are otherwise not sensitive.  (Currently I use this to
add my CPAN credentials to my `.dzil/config.ini`.) This is helpful when part
but not all of a file is sensitive.

Similarly, files ending in .replace are encrypted and used to completely replace
non-encrypted versions. Really, these could just be added to the .gitattributes
lsit of files to encrypt. This feature exists now only for historic reasons.

## How I use it

I look at a dry run of what'll happen with:

`./install`

I install them with:

`./install now`

On a new machine after a clone, `./install now` will get a version of the
dotfiles with bunch of encrypted gibberish.  I do this first because it ALSO
gets me a copy of `gitcrypt`, which allows me to move on to the next step,
configuring it so my sensitive data can be decrypted:

```
git config git-encrypt.salt XXXX
git config git-encrypt.pass XXXX
git config git-encrypt.cipher XXXX
git config filter.encrypt.smudge "git encrypt smudge"
git config filter.encrypt.clean "git encrypt clean"
git config diff.encrypt.textconv "git encrypt diff"
git reset --hard
```

At that point I can run `./install now` again and get the decrypted version.

## Configs of note

### .profile

Adds `~/bin` to the path.

Loads all of the files in `.bash_profiled`

Loads `.bashrc`

### .bashrc

If bash completion scripts aren't available globally where it
expects them, will load a bundled version.

Loads all of the files in `.bashrcd` and `.bash_aliasesd`.

### .emacs

I don't use emacs much but...

* Configures cperl mode
* Enables markdown mode
* Sets some custom syntax coloring (which I probably no longer approve of =p)
* Mostly though, it gives emacs keybindings to match `joe`, which is wordstar-like, except where its emacs-like.

### .gitconfig

Pretty common config here. Of note:

* Make my logs look like: (except with color)

```
0cd5f2f (origin/master, origin/HEAD) Add GNU versions of tools ahead of BSD (Rebecca Turner on 2014-09-19)
f74509d Add nvm (Rebecca Turner on 2014-09-18)
58becd5 Add macports (Rebecca Turner on 2014-09-18)
```

```
[format]
	pretty = format:%C(yellow)%h%C(reset)%w(110,0,8)%C(green)%d%C(reset) %s%w(0) %C(bold black)(%aN on %ad)%C(reset)
```

* Set pushes to just go to whatever my upstream branch is. Not always the same name as my local branch.

```
[push]
	default = upstream
```

* Enables "reuse recorded resolution of conflicted merges" which is super helpful if you're regularly rebuilding integration branches.

```
[rerere]
	enabled = true
```

* This changes the format you get on conflicts. Diff3 gives you them and us,
* but also what we were patching.  This makes it much clearer what the
* intent of the change was.

```
[merge]
	conflictstyle = diff3
```

* Stops me from committing whitespace errors.

```
[apply]
	whitespace = fix
```

* This one's almost certainly a bad idea. If upstream/BRANCH doesn't contain
  HEAD, it does a rebase instead of a merge.  Which *is* usually what I
  want, but `git pull` doesn't give you the opportunity for an interactive
  rebase, which is often problematic.  As such, I often end up aborting it
  and running `git rebase -i upstream/BRANCH`.

```
[pull]
	rebase = true
```

### .tmux.conf

I love `tmux` and before it, `screen`, but I hate the default key binds. So
what this does is change the keybinding to Ctrl-Space, which I find
really-really pleasent.

```
unbind-key C-b
set-option -g prefix C-@
```

And then I make double tapping the space bar toggle between the most recent windows:

```
bind-key C-@ last-window
```

### bin/diff-colorize

A filter that colorizes diff output (`git` spoiled me). Used as:

```
diff -u thinga thingb | diff-colorize | less -REX
```

### bin/tap-colorize

A filter that colorizes tap output from various sources.

### bin/every

A self contained build of [every](https://github.com/iarna/app-every), a
tool for creating crontabs with syntax similar to `at`.  You can get your
own copy with:

```
curl -O https://raw.githubusercontent.com/iarna/App-Every/master/packed/every && chmod u+x every
```

or

```
wget -Oevery https://raw.githubusercontent.com/iarna/App-Every/master/packed/every && chmod u+x every
```

### bin/nprove

A tiny wrapper around Perl's `prove` to execute Node.js tap tests correctly\*,
with the added bonus of colorizing the output with `tap-colorize`.  While
the tap runner bundled with `tap` is usually just fine, there are times when
I prefer `prove`'s summarization.  But even more so, it has other nice
features, like the ability to randomize the order tests are run.

*\* by which I mean, it adds node_modules/.bin to your path and runs prove
with `-e node --ext .js`*

### bin/setup-perlbrew

Configures perlbrew on a new system to manage a global perl installation in /opt/perl5.

### bin/ssh-copy-id.sh

A polyfill for `ssh-copy-id` for use on systems that don't provide one.

### bin/watch.sh

A polyfill for GNU watch-- this version is pretty minimal / limited but it gets the job done.

### git-bin/git-rss
### git-bin/git-rss-items

A copy of [git-rss](https://github.com/iarna/git-rss), which generates an
RSS feed from a git commit history.  Includes a full colorized diff for each
commit.

### .bash_profiled/git_bin_path

Adds `~/git-bin` to my GIT_EXEC_PATH

### .bash_profiled/fink
### .bash_profiled/homebrew_path
### .bash_profiled/macports_path

If detected, sets up environment for fink, homebrew and macports. I've used
all of them over the years.  Currently I'm using macports though.

### .bash_profiled/nvm

If we have a `~/.nvm` then this loads its config

### .bash_aliasesd/mac-like-open

In gnome environments, aliases `open` to `gnome-open`.

### .bash_aliasesd/ssh

Installs the ssh-copy-id polyfill

### .bash_aliasesd/total

A small function for summing newline sparated lists of numbers

### .bash_aliasesd/typos

Corrections for common typos of mine

### .bash_aliasesd/unix-like-gimp

Gives me a command-line tool like X11 gimp for opening image files in MacGimp.

### .bash_aliasesd/watch

Installs the watch polyfill

### .bashrcd/history

Configures my bash history-- I ignore duplicates and append to the history when starting.

### .bashrcd/prompt

Configures my prompt, which is a bog standard `user@hostname:path$ ` with
standard `$` to `#` when root.  Except with colors and the addition of git
information if the CWD is a git repo, at which point its
`user@hostname:path$ [repoinfo] `.
