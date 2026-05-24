class TokenscaleCli < Formula
  desc "Command-line entrypoint for the tokenscale dashboard."
  homepage "https://github.com/RobarePruyn/tokenscale"
  version "0.1.16"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/RobarePruyn/tokenscale/releases/download/v0.1.16/tokenscale-cli-aarch64-apple-darwin.tar.xz"
      sha256 "17d371172efb07453c5dcd2f864cf6bb397b36e93e47814456b215f30ab21f48"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RobarePruyn/tokenscale/releases/download/v0.1.16/tokenscale-cli-x86_64-apple-darwin.tar.xz"
      sha256 "79b95df7f270f7840002fb8dfc7a98a63485a5f6913b2f053ec546d97c10d586"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/RobarePruyn/tokenscale/releases/download/v0.1.16/tokenscale-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5ce6605ac097f3b54e33b1c0b92c47810602ab62b4ef1493ced5313a07c387a7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RobarePruyn/tokenscale/releases/download/v0.1.16/tokenscale-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2104fb3ac61447db153012f6f17fd3ec50cad5b1a35a82dac7f6e8b5f16b9391"
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
