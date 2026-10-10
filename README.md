# dotfiles

## Prerequisites

1. Install [Homebrew — The Missing Package Manager for macOS (or Linux)](https://brew.sh/)

## Setup

```sh
brew install chezmoi
chezmoi init --apply raiota
```

## Update

Run `dotup` (a fish function) on one machine. It updates the mise tools while skipping releases younger than 3 days, locks them for every platform, then commits and pushes `mise.lock` together with any uncommitted edits to the mise config. Other machines install the same versions with `chezmoi update`.

Keep mise up to date on every machine: a mise older than the lockfile format refuses to read `mise.lock`.

## Git Configuration

Firstly, applying this project will generate git configuration directories like below.

```plaintext
.
├── .gitconfig
├── .gitconfig.ghq
└── repos/
    ├── personal/
    ├── read/
    └── work/
        └── .gitconfig
```

Make sure to

- Set up work-related ghq roots in `~/.gitconfig.ghq`
- Define git settings for work repositories in `~/repos/work/.gitconfig`
