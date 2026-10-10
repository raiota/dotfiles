# dotfiles

## Prerequisites

1. Install [Homebrew — The Missing Package Manager for macOS (or Linux)](https://brew.sh/)

## Setup

```sh
brew install chezmoi
chezmoi init --apply raiota
```

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
