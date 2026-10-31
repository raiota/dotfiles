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

Homebrew and uv tools are not locked; update them on each machine:

```sh
brew upgrade
brew bundle cleanup --global --force  # uninstall what ~/.Brewfile no longer lists
uv tool install platformio            # once per machine; later `uv tool upgrade --all`
```

When an advisory hits a library that many tools bundle (e.g. Brotli, CVE-2026-111497), updating one runtime is not enough. Check the mise tools, `brew upgrade`, apps that ship their own copy (Claude Code, Electron apps), and restart long-running processes that still run the old binary.

Neovim plugins are not pinned here. lazy.nvim checks for updates every 30 days and lists them in a notification; run `:Lazy sync` on that machine when it does.

## herdr

Coding agents run in [herdr](https://herdr.dev) inside Ghostty: start or reattach with `herdr`, pick a repository with `Ctrl+A f`, and lay out editor, agent and shell with `hdl`.

On each machine, install herdr's Claude Code hook once so agent sessions resume after a herdr restart, and again after upgrading herdr:

```sh
herdr integration install claude
```

`chezmoi apply` keeps the hook entry this adds to Claude Code's `settings.json`.

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
