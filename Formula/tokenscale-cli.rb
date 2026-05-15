class TokenscaleCli < Formula
  desc "Command-line entrypoint for the tokenscale dashboard."
  homepage "https://github.com/RobarePruyn/tokenscale"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/RobarePruyn/tokenscale/releases/download/v0.1.3/tokenscale-cli-aarch64-apple-darwin.tar.xz"
      sha256 "2275075f011b86f0cc65cedb8badb46c4828f387cd2b5f820c215e01f9c7dadb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RobarePruyn/tokenscale/releases/download/v0.1.3/tokenscale-cli-x86_64-apple-darwin.tar.xz"
      sha256 "7eff69f2add74b21e9ef587f7d6f3de08c1e2275b374956eec4f2ed1a9e8f729"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/RobarePruyn/tokenscale/releases/download/v0.1.3/tokenscale-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f7d46555a3fdb4866a3e6e4b398c235dfebbe93d9e23858b780570339e5ec628"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RobarePruyn/tokenscale/releases/download/v0.1.3/tokenscale-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "238a3c5b1d55184ce489128b1a9bfab11640d9f1f2ecf5ac64093cecdc917791"
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
