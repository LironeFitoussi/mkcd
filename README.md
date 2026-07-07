# mkcd

Create a directory and `cd` into it, in one command.

```sh
mkcd src/deeply/nested/dir   # mkdir -p + cd, done
```

`mkcd` is a shell function, not a binary — a child process can't change
your shell's working directory, so the function must live in your shell.
The package installs one sourceable POSIX file; you add one line to your rc.

## Install

### Homebrew (macOS / Linux)

```sh
brew install lironefitoussi/tap/mkcd
echo "source $(brew --prefix)/share/mkcd/mkcd.sh" >> ~/.zshrc   # or ~/.bashrc
```

### apt (Debian / Ubuntu)

```sh
curl -fsSL https://lironefitoussi.github.io/mkcd/gpg.key \
  | sudo gpg --dearmor -o /usr/share/keyrings/mkcd-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/mkcd-archive-keyring.gpg] https://lironefitoussi.github.io/mkcd stable main" \
  | sudo tee /etc/apt/sources.list.d/mkcd.list
sudo apt update && sudo apt install mkcd
echo "source /usr/share/mkcd/mkcd.sh" >> ~/.bashrc   # or ~/.zshrc
```

(Standalone `.deb` also attached to each [release](https://github.com/LironeFitoussi/mkcd/releases).)

### Manual

```sh
git clone https://github.com/lironefitoussi/mkcd && cd mkcd
sudo make install                    # installs to /usr/local/share/mkcd
echo "source /usr/local/share/mkcd/mkcd.sh" >> ~/.zshrc
```

Open a new shell (or `source` your rc) and `mkcd` is available, with
directory tab-completion in bash and zsh.

## Usage

```
usage: mkcd <directory>
```

- Creates parents as needed (`mkdir -p`).
- `cd -P` resolves symlinks to the physical path.
- Safe with spaces and leading-dash names.
- `mkcd --help`, `mkcd --version`.

## Development

```sh
make test    # runs test suite under sh, bash, and zsh
make lint    # shellcheck
```

## Releasing

1. Bump version in `mkcd.sh` and `packaging/debian/control`.
2. Tag: `git tag v0.x.0 && git push --tags`. CI builds the `.deb`,
   attaches it to the GitHub release, and republishes the signed APT
   repository to GitHub Pages (signing key: `APT_GPG_PRIVATE_KEY` secret).
3. Homebrew: update `url` + `sha256` in `Formula/mkcd.rb`
   (`shasum -a 256` on the release tarball) and push the formula to
   your `homebrew-tap` repo.

## License

MIT
