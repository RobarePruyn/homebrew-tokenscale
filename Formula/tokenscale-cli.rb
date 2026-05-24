class TokenscaleCli < Formula
  desc "Command-line entrypoint for the tokenscale dashboard."
  homepage "https://github.com/RobarePruyn/tokenscale"
  version "0.1.17"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/RobarePruyn/tokenscale/releases/download/v0.1.17/tokenscale-cli-aarch64-apple-darwin.tar.xz"
      sha256 "f7e42aab4da3438dd21a9d0d4c24c9d3a8e76d9cf30a607c379d4c60a63ec407"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RobarePruyn/tokenscale/releases/download/v0.1.17/tokenscale-cli-x86_64-apple-darwin.tar.xz"
      sha256 "1cbe351d361660a993d4efcbfc5c002b676954d78dbb8ff3f72da82f9fb04b03"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/RobarePruyn/tokenscale/releases/download/v0.1.17/tokenscale-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7821faea57c90cd5ae2cef12aa28f7e28d823e3f9918e1ad69f5cdc62a70c79b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RobarePruyn/tokenscale/releases/download/v0.1.17/tokenscale-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "115a7d87c56b1bda969322166cfa9348b84f70059bae72f35779742d0e5df2c0"
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
