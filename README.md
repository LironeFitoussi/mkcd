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

Download the `.deb` from the [latest release](https://github.com/lironefitoussi/mkcd/releases), then:

```sh
sudo apt install ./mkcd_0.1.0_all.deb
echo "source /usr/share/mkcd/mkcd.sh" >> ~/.bashrc   # or ~/.zshrc
```

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
2. Tag: `git tag v0.x.0 && git push --tags`. CI builds the `.deb` and
   attaches it to the GitHub release.
3. Homebrew: update `url` + `sha256` in `Formula/mkcd.rb`
   (`shasum -a 256` on the release tarball) and push the formula to
   your `homebrew-tap` repo.

## License

MIT
