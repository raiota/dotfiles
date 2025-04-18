# dotfiles

## Setup

1. Install [Homebrew — The Missing Package Manager for macOS (or Linux)](https://brew.sh/)
2. `brew install gcc git chezmoi`
3. `chezmoi init raiota`

## Initial git setup

When using dotfiles for work, perform the following initial setup.
To manage commit users, create the following file:


```sh
mkdir ~/repos/works && touch ~/repos/works/.gitconfig
```

and include the following content:

```plaintext
[user]
    name = "myname"
    email = "myemail"
```

Also, create the work-related root for ghq using the following steps:

```sh
touch ~/.gitconfig.ghq
```

```sh
[ghq "https://github.com/myorg"]
    root = ~/repos/works
```
