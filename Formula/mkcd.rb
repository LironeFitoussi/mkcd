class Mkcd < Formula
  desc "Create a directory and cd into it, in one command"
  homepage "https://github.com/lironefitoussi/mkcd"
  url "https://github.com/lironefitoussi/mkcd/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "REPLACE_WITH_TARBALL_SHA256" # shasum -a 256 v0.1.0.tar.gz
  license "MIT"

  def install
    pkgshare.install "mkcd.sh"
  end

  def caveats
    <<~EOS
      mkcd is a shell function (a binary can't change your shell's cwd).
      Add this to your ~/.zshrc or ~/.bashrc:

        source #{opt_pkgshare}/mkcd.sh
    EOS
  end

  test do
    output = shell_output("sh -c '. #{pkgshare}/mkcd.sh && mkcd #{testpath}/a/b && pwd'")
    assert_match "a/b", output
  end
end
