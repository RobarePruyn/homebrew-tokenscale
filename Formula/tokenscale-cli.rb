class TokenscaleCli < Formula
  desc "Command-line entrypoint for the tokenscale dashboard."
  homepage "https://github.com/RobarePruyn/tokenscale"
  version "0.1.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/RobarePruyn/tokenscale/releases/download/v0.1.5/tokenscale-cli-aarch64-apple-darwin.tar.xz"
      sha256 "6853b545242becde58ea5019a6434ec9329133c7390fab1d85b61ab4870b6c0f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RobarePruyn/tokenscale/releases/download/v0.1.5/tokenscale-cli-x86_64-apple-darwin.tar.xz"
      sha256 "ce9066e643509807835d0e90e58b0465900403a029a38549baaff5bb4e0bf11e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/RobarePruyn/tokenscale/releases/download/v0.1.5/tokenscale-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ab0308b3191c8f383cbc0bb165e26b933a578eed7203324319c5b66da4156104"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RobarePruyn/tokenscale/releases/download/v0.1.5/tokenscale-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6051d4720311b4eb3b8cec5f030c4bd75e256f54e1c8dca09356f6e249904bcc"
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
