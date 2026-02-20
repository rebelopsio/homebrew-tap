class BoundaryLsp < Formula
  desc "LSP server for boundary architecture analysis"
  homepage "https://github.com/rebelopsio/boundary"
  version "0.10.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rebelopsio/boundary/releases/download/v0.10.2/boundary-lsp-aarch64-apple-darwin.tar.xz"
      sha256 "12408819d0e3bc2e55634d9c121b96794fdbe6df155c6eaedac01b7b06a374bb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rebelopsio/boundary/releases/download/v0.10.2/boundary-lsp-x86_64-apple-darwin.tar.xz"
      sha256 "e50e43b0d2fa694e39860c455f6014ce7ccc07b3de24ee211c6ebfc9ab162317"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rebelopsio/boundary/releases/download/v0.10.2/boundary-lsp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a8cc580c3b1358a3ac924ac6d602fa9967e647dc18d49e4659f2190199c6d0bb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rebelopsio/boundary/releases/download/v0.10.2/boundary-lsp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3b8f272aabc5c0bf9440f9eb7b699ddf4222d7937b99ff5a53da653eaa7908f6"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

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
    bin.install "boundary-lsp" if OS.mac? && Hardware::CPU.arm?
    bin.install "boundary-lsp" if OS.mac? && Hardware::CPU.intel?
    bin.install "boundary-lsp" if OS.linux? && Hardware::CPU.arm?
    bin.install "boundary-lsp" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
