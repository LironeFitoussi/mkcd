class Mkcd < Formula
  desc "Create a directory and cd into it, in one command"
  homepage "https://github.com/LironeFitoussi/mkcd"
  url "https://github.com/LironeFitoussi/mkcd/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "4899e1f6c2b3f89731547e98740e78a9113ad397acf399c88f23ef975d916c40"
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
