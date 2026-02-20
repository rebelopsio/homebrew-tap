class BoundaryLsp < Formula
  desc "LSP server for boundary architecture analysis"
  homepage "https://github.com/rebelopsio/boundary"
  version "0.12.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rebelopsio/boundary/releases/download/v0.12.0/boundary-lsp-aarch64-apple-darwin.tar.xz"
      sha256 "e2651ae31d2dc7e47034ad185918fc79221f2578700277ed1d9925ea71fa3835"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rebelopsio/boundary/releases/download/v0.12.0/boundary-lsp-x86_64-apple-darwin.tar.xz"
      sha256 "aa112f57f7156868c94fcc5789cf3aa39bd7ad0730fba661d9cfa21e26c47e6e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rebelopsio/boundary/releases/download/v0.12.0/boundary-lsp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e6163317f35d7bf242fe7ccfb8df409c8fbb34acdb379def80592abd999daee6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rebelopsio/boundary/releases/download/v0.12.0/boundary-lsp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a852d39189fa207f6e3108854f6f77193039a840cf621f77f79f642c8e562f40"
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
