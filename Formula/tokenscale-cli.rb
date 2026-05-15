class TokenscaleCli < Formula
  desc "Command-line entrypoint for the tokenscale dashboard."
  homepage "https://github.com/RobarePruyn/tokenscale"
  version "0.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/RobarePruyn/tokenscale/releases/download/v0.1.4/tokenscale-cli-aarch64-apple-darwin.tar.xz"
      sha256 "6956f1f1caa04e9dafa8a8e3ed368df7974497ab4d51c0dc0284282f2f2191c4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RobarePruyn/tokenscale/releases/download/v0.1.4/tokenscale-cli-x86_64-apple-darwin.tar.xz"
      sha256 "96f6033bed7c9c7656919a1d89dae504559aaf91157705c674cc83fdc356e2bd"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/RobarePruyn/tokenscale/releases/download/v0.1.4/tokenscale-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ea4033e78ab392f3b73496a5ce3ee2bcc6f9c4aea296a94d5c1d0f7600b2c10c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RobarePruyn/tokenscale/releases/download/v0.1.4/tokenscale-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b57a55b9e7484f03c5f80ae98e63969dd179f60b1fa5113c507521e6a2daf477"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "tokenscale" if OS.mac? && Hardware::CPU.arm?
    bin.install "tokenscale" if OS.mac? && Hardware::CPU.intel?
    bin.install "tokenscale" if OS.linux? && Hardware::CPU.arm?
    bin.install "tokenscale" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
