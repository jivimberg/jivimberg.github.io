# Dev Setup

For managing Ruby I'm using [chruby-fish](https://github.com/JeanMertz/chruby-fish) installed through Homebrew.
The project version is set in `.ruby-version` and chruby will auto change when you cd in that directory.

For the Python version I'm using pyenv installed through Homebrew.
I needed to pin version 2.7.X because the `pygments` library (used for code highlighting) fails otherwise when runnking `rake generate` and `rake preview`.
The error looks like something like this:

```
Pygments can't parse unknown language: sql
```

And this is the comment that set me on the right track: https://github.com/imathis/octopress/issues/1173
The python version is set globally with pyenv doing: `pyenv global 2.7.X` (replace X with the right number).
In the future it might be best to set global to python 3 and use pyenv to configure the local version.

I used the command `fish_add_path -v (pyenv root)/shims` to put pyenv execs on the path. But noticed that it was clashing with some chruby configuration that existed under /Users/jvimberg@netflix.com/.config/fish/config.fish. After installing chruby-fish and removing that custom configuration on config.fish then everything started working fine.
