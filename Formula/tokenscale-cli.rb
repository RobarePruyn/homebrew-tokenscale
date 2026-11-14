class TokenscaleCli < Formula
  desc "Command-line entrypoint for the tokenscale dashboard."
  homepage "https://github.com/RobarePruyn/tokenscale"
  version "0.1.26"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/RobarePruyn/tokenscale/releases/download/v0.1.26/tokenscale-cli-aarch64-apple-darwin.tar.xz"
      sha256 "97ed1711772dba1f14ebeb5390df7ad9bac56dd3eed7f027a67788c57d5e485d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RobarePruyn/tokenscale/releases/download/v0.1.26/tokenscale-cli-x86_64-apple-darwin.tar.xz"
      sha256 "c781ed600dae18b8ceff0b69fa5dbed48d5b139ad4a7f46cddb0fb38dc6b23c5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/RobarePruyn/tokenscale/releases/download/v0.1.26/tokenscale-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "08d6e02f824873f23009f7a107f001cfa0987fc6994691ba4dfdf79c9151ba72"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RobarePruyn/tokenscale/releases/download/v0.1.26/tokenscale-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "397771ed235c7ffcec2e2e432497ecb296777d7f3b85d8fc372deaa57843f431"
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
