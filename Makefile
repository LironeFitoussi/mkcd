PREFIX ?= /usr/local
SHAREDIR = $(DESTDIR)$(PREFIX)/share/mkcd

.PHONY: install uninstall test lint

install:
	install -d "$(SHAREDIR)"
	install -m 0644 mkcd.sh "$(SHAREDIR)/mkcd.sh"
	@printf '\nInstalled. Add this line to your ~/.zshrc or ~/.bashrc:\n'
	@printf '  source %s/share/mkcd/mkcd.sh\n' "$(PREFIX)"

uninstall:
	rm -rf "$(SHAREDIR)"

test:
	sh test/test.sh
	bash test/test.sh
	@command -v zsh >/dev/null && zsh test/test.sh || true

lint:
	shellcheck -s sh mkcd.sh test/test.sh
