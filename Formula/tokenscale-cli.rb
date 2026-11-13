class TokenscaleCli < Formula
  desc "Command-line entrypoint for the tokenscale dashboard."
  homepage "https://github.com/RobarePruyn/tokenscale"
  version "0.1.25"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/RobarePruyn/tokenscale/releases/download/v0.1.25/tokenscale-cli-aarch64-apple-darwin.tar.xz"
      sha256 "0dc8cc7959893de855f17b2d87247fed246c5d70e4c73483204406503d14e5dd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RobarePruyn/tokenscale/releases/download/v0.1.25/tokenscale-cli-x86_64-apple-darwin.tar.xz"
      sha256 "511aa89810f523c6be7f6edc70df452eeb7e4c9ea919a798a8ac7382b21e76a5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/RobarePruyn/tokenscale/releases/download/v0.1.25/tokenscale-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e7cf3981e492ce88aae198e760b54e93582f936a6fa5fba9a28221403a28978b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RobarePruyn/tokenscale/releases/download/v0.1.25/tokenscale-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7497f4727a5e1d56e70e4f332c72faf6dd6150ad443a6c7f006061eaf91910b6"
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
