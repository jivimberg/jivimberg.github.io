# Dev Setup

~~For managing Ruby I'm using [chruby-fish](https://github.com/JeanMertz/chruby-fish) installed through Homebrew.
The project version is set in `.ruby-version` and chruby will auto change when you cd in that directory.~~

This is old advice. I'm no longer using fish shell. I'm using zsh and oh-my-zsh. 
Just install chruby through homebrew and enable the chruby plugin in oh-my-zsh in the `.zshrc` file.

Install ruby-install through Homebrew with `brew install ruby-install`.

If the installation complaints due to Open SSL 1.1 then do this:
```
% brew tap homebrew/core --force
% brew edit --formula openssl@1.1
[remove the `disable!` line]
% HOMEBREW_NO_INSTALL_FROM_API=1 brew install openssl@1.1
```

(Taken from [here](https://github.com/rvm/rvm/issues/5398#issuecomment-2480726983))

I ended up having to do this as well:
```
brew uninstall --ignore-dependencies openssl@3
ruby-install ruby 2.7.2;
brew install openssl@3
```

(Taken from [here](https://stackoverflow.com/questions/76615429/installing-ruby-2-7-5-on-mac-12-6-7-with-rvm))

Then install the version of ruby specified in .ruby-version with `ruby-install ruby-2.7.2` (replace 2.7.2 with the version in .ruby-version).

When installing a gem and things fail sometimes you have to install it with a specific C flag for it to work.
Like for example: `gem install rdiscount:2.2.0.2 -- --with-cflags="-Wno-error=implicit-function-declaration"`
Then run `bundle install` again and it'll work. The specific flag you can get from a Google search or by looking at the error message.

For the Python version I'm using pyenv installed through Homebrew.
I needed to pin version 2.7.X because the `pygments` library (used for code highlighting) fails otherwise when running `rake generate` and `rake preview`.
The error looks like something like this:

```
Pygments can't parse unknown language: sql
```

And this is the comment that set me on the right track: https://github.com/imathis/octopress/issues/1173
The python version is set globally with pyenv doing: `pyenv global 2.7.X` (replace X with the right number).
In the future it might be best to set global to python 3 and use pyenv to configure the local version.

```bash
brew install pyenv
pyenv install 2.7.18
pyenv global 2.7.18
```

I used the command `fish_add_path -v (pyenv root)/shims` to put pyenv execs on the path. But noticed that it was clashing with some chruby configuration that existed under /Users/jvimberg@netflix.com/.config/fish/config.fish. After installing chruby-fish and removing that custom configuration on config.fish then everything started working fine.

If using ZSH add [pyenv plugin](https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/pyenv/pyenv.plugin.zsh)

---

## Liquid Exception: incompatible character encodings: UTF-8 and ASCII-8BIT

--- 

## Errno::ENOENT: No such file or directory @ dir_chdir - _deploy on `rake deploy`

If you delete the `_deploy` directory you have to do: `rake setup_github_pages`

https://github.com/jivimberg/jivimberg.github.io

Ref: https://github.com/imathis/octopress/issues/334

Then do: `git checkout -b master` to create the master branch.
You might need to pull changes with `git pull origin master --rebase`

---

## error: src refspec master does not match any

Change `_deploy` branch to `master` by doing: `git checkout -b master` inside the `_deploy` directory.

---

## Trying to upgrade Ruby version

Tried by setting ruby to version: 3.1.4

And rdiscount to `gem 'rdiscount', '~> 2.2.7.3'` 

Didn't work because Jekyll is pinned to version 2 by Octopress and doesn't work with newer versions of Ruby.