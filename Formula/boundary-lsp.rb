class BoundaryLsp < Formula
  desc "LSP server for boundary architecture analysis"
  homepage "https://github.com/rebelopsio/boundary"
  version "0.22.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rebelopsio/boundary/releases/download/v0.22.0/boundary-lsp-aarch64-apple-darwin.tar.xz"
      sha256 "1f8f2b311b4ef8518f9c820f4a3011ce3aa91db9f19ee39d2142e64a05d96905"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rebelopsio/boundary/releases/download/v0.22.0/boundary-lsp-x86_64-apple-darwin.tar.xz"
      sha256 "c659a049c566883ba3b85dfc34d627ad562e70cf0c689c041130b8df0196c58f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rebelopsio/boundary/releases/download/v0.22.0/boundary-lsp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6ba20d9ad2adc85461dcffdc8dbe9b3282cc0b454ab00019c6e66f2833b7b3cb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rebelopsio/boundary/releases/download/v0.22.0/boundary-lsp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1ce1a739a3e864506a14804d278dbbf03509432422a5c9efdcc2ad028e33360f"
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
