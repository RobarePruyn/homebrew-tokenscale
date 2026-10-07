class TokenscaleCli < Formula
  desc "Command-line entrypoint for the tokenscale dashboard."
  homepage "https://github.com/RobarePruyn/tokenscale"
  version "0.1.22"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/RobarePruyn/tokenscale/releases/download/v0.1.22/tokenscale-cli-aarch64-apple-darwin.tar.xz"
      sha256 "231089dd2387fed1c413d95cc4629b2cab19cd1027a74f032c1c43af93693558"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RobarePruyn/tokenscale/releases/download/v0.1.22/tokenscale-cli-x86_64-apple-darwin.tar.xz"
      sha256 "2a2890231bf6ad0376f1a0e3a3e705e3c12037d125cc229c220fc29a3310e873"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/RobarePruyn/tokenscale/releases/download/v0.1.22/tokenscale-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "16f7efa16c0bd9c28f79c6618b4bf2d1623ef636c6688f32385864b3c705847b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RobarePruyn/tokenscale/releases/download/v0.1.22/tokenscale-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f1906f7652cf2b80bc7f39eac99cc949da9dd34ef3ac4aef02b6f798c645f49f"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin": {},
    "x86_64-pc-windows-gnu": {},
    "x86_64-unknown-linux-gnu": {}
  }

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
  # BEGIN-tokenscale-amendment — see .github/workflows/amend-formula.yml
  def caveats
    <<~EOS
      tokenscale is installed. It is designed to run on demand:

        tokenscale serve        # dashboard at http://127.0.0.1:8787; scans on startup and every minute while running

      Stop it with Ctrl-C when you are done. Nothing runs at login unless you opt in.

      Optional background service (opt in):

        brew services start tokenscale-cli

      The service restarts only after a crash, at most once per 5 minutes. A
      deliberate refusal (exit code 3: the database was migrated by a newer
      tokenscale) does not restart; the fix is `brew upgrade tokenscale-cli`.

      Config (created on first run):
        ~/Library/Application Support/tokenscale/config.toml   (macOS)
        ~/.config/tokenscale/config.toml                       (Linux)

      Service log (only when running under brew services; WARN level and above):
        #{var}/log/tokenscale.log
    EOS
  end

  service do
    run [opt_bin/"tokenscale", "serve"]
    # Restart only after a crash (signal exit), never after a deliberate
    # non-zero exit such as the schema-newer-than-binary refusal (code 3),
    # and never more often than every 5 minutes. Incident 2026-10-07:
    # keep_alive true hot-looped a stale binary 41,095 times and grew a
    # 529 MB log.
    keep_alive crashed: true
    throttle_interval 300
    environment_variables RUST_LOG: "warn"
    working_dir HOMEBREW_PREFIX
    log_path var/"log/tokenscale.log"
    error_log_path var/"log/tokenscale.log"
  end
  # END-tokenscale-amendment

end
