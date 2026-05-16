class TokenscaleCli < Formula
  desc "Command-line entrypoint for the tokenscale dashboard."
  homepage "https://github.com/RobarePruyn/tokenscale"
  version "0.1.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/RobarePruyn/tokenscale/releases/download/v0.1.7/tokenscale-cli-aarch64-apple-darwin.tar.xz"
      sha256 "f9e8a83544247bbbdcbdb81e0de8b94cf6967a66788600e323b1a5135dc8697d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RobarePruyn/tokenscale/releases/download/v0.1.7/tokenscale-cli-x86_64-apple-darwin.tar.xz"
      sha256 "04028219c9088aba7024b2eeb41a0370e7666ab0562f47a670e683c1457a1144"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/RobarePruyn/tokenscale/releases/download/v0.1.7/tokenscale-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "73ff63c870d07196840aaaccf9f44625cae8550988641a68262fea678f149430"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RobarePruyn/tokenscale/releases/download/v0.1.7/tokenscale-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5845b4dfb9248fa2294a2503c1b639635794c853319e2ffb22035f3f1c74f2cc"
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
