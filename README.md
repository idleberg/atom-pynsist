# pynsist for Atom

[![apm](https://flat.badgen.net/apm/license/pynsist)](https://atom.io/packages/pynsist)
[![apm](https://flat.badgen.net/apm/v/pynsist)](https://atom.io/packages/pynsist)
[![apm](https://flat.badgen.net/apm/dl/pynsist)](https://atom.io/packages/pynsist)
[![CircleCI](https://flat.badgen.net/circleci/github/idleberg/atom-pynsist)](https://circleci.com/gh/idleberg/atom-pynsist)
[![David](https://flat.badgen.net/david/dep/idleberg/atom-pynsist)](https://david-dm.org/idleberg/atom-pynsist)

Snippets and build-system for [pynsist](https://pypi.python.org/pypi/pynsist), a tool to build Windows installers for your Python applications.

## Installation

### apm

Install `pynsist` from Atom's [Package Manager](http://flight-manual.atom.io/using-atom/sections/atom-packages/) or the command-line equivalent:

`$ apm install pynsist`

### Using Git

Change to your Atom packages directory:

```bash
# Windows
$ cd %USERPROFILE%\.atom\packages

# Linux & macOS
$ cd ~/.atom/packages/
```

Clone repository as `pynsist`:

```bash
$ git clone https://github.com/idleberg/atom-pynsist pynsist
```

Inside the cloned directory, install Node dependencies:

```bash
$ yarn || npm install
```

### Package Dependencies

This package automatically installs third-party packages it depends on. You can prevent this by disabling the *Manage Dependencies* option in the package settings.

## Related

- [sublime-pynsist](https://packagecontrol.io/packages/Pynsist)
- [vscode-pynsist](https://marketplace.visualstudio.com/items?itemName=idleberg.pynsist)

## License

This work is dual-licensed under [The MIT License](https://opensource.org/licenses/MIT) and the [GNU General Public License, version 2.0](https://opensource.org/licenses/GPL-2.0)
