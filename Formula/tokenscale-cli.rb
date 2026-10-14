class TokenscaleCli < Formula
  desc "Command-line entrypoint for the tokenscale dashboard."
  homepage "https://github.com/RobarePruyn/tokenscale"
  version "0.1.23"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/RobarePruyn/tokenscale/releases/download/v0.1.23/tokenscale-cli-aarch64-apple-darwin.tar.xz"
      sha256 "c6cbd9e2a44610b3589e4cbb201700cb1bb9a2e526762e6e9c7ec8afed1a2d80"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RobarePruyn/tokenscale/releases/download/v0.1.23/tokenscale-cli-x86_64-apple-darwin.tar.xz"
      sha256 "c7723e2ac4612bc9f27d90801e26d3e9fec614b2bcb54bcc91a23a327c4712e1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/RobarePruyn/tokenscale/releases/download/v0.1.23/tokenscale-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3597fdcc8ac49ee9778938e9201f79cd53941364b9cfe075664bf99e3bdaf256"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RobarePruyn/tokenscale/releases/download/v0.1.23/tokenscale-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "17aaa1ad83dbbc8aebd46aae0d7829ef1b42c96ff17ca18c73f5967177f71eb2"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "tokenscale"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "tokenscale"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "tokenscale"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "tokenscale"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
