class TokenscaleCli < Formula
  desc "Command-line entrypoint for the tokenscale dashboard."
  homepage "https://github.com/RobarePruyn/tokenscale"
  version "0.1.12"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/RobarePruyn/tokenscale/releases/download/v0.1.12/tokenscale-cli-aarch64-apple-darwin.tar.xz"
      sha256 "c7daaf1507bc920f6ada9d9469b2ddcae34157eb409b1726fb11cb6432afe11e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RobarePruyn/tokenscale/releases/download/v0.1.12/tokenscale-cli-x86_64-apple-darwin.tar.xz"
      sha256 "ba3823218fb89d86c5c6d908f678aa2f2a4e3c8b79f898c3a321c7a8e123dda4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/RobarePruyn/tokenscale/releases/download/v0.1.12/tokenscale-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7c0d8299069ff3a4920081d0ac4928a8be2f467102b6756ab5b59265382a5d8b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RobarePruyn/tokenscale/releases/download/v0.1.12/tokenscale-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0e1dabc7e79ed2c64203d9b831c4d70850c99f34137a077df66131863e68d72d"
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
  # BEGIN-tokenscale-amendment — see .github/workflows/amend-formula.yml
  def caveats
    <<~EOS
      tokenscale is installed. To start the local dashboard:

        tokenscale serve

      That binds http://127.0.0.1:8787 and runs the auto-scan loop.

      To run it as a background service (auto-starts on login):

        brew services start tokenscale-cli

      Then open: http://127.0.0.1:8787

      Config (created on first run):
        ~/Library/Application Support/tokenscale/config.toml   (macOS)
        ~/.config/tokenscale/config.toml                       (Linux)

      Service log (when running under brew services):
        #{var}/log/tokenscale.log
    EOS
  end

  service do
    run [opt_bin/"tokenscale", "serve"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/tokenscale.log"
    error_log_path var/"log/tokenscale.log"
  end
  # END-tokenscale-amendment

end
