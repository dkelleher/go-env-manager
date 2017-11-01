# go-env-manager

The go-env-manager script is a script to handle multiple go environment
at once.  The idea was shamelessly pilfered from the python
[virtualenvwrapper
project](https://github.com/bernardofire/virtualenvwrapper) if you use
python check it out.

### Setup

To setup you need only set `GOENVPATH` and source the script.  Currently
I've only made a zsh script but at some point I'll adapt it to bash.

in my `~/zshrc`:

```shell
export GOENVPATH=$HOME/.golang
source ~/.go-env-manager/go-env-wrapper.zsh
```

