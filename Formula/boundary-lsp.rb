class BoundaryLsp < Formula
  desc "LSP server for boundary architecture analysis"
  homepage "https://github.com/rebelopsio/boundary"
  version "0.14.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rebelopsio/boundary/releases/download/v0.14.0/boundary-lsp-aarch64-apple-darwin.tar.xz"
      sha256 "b4a2a8c1cd3781c4dadf0d5bdd0254f0301b8f17e2b68850538d7b5e88a98c44"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rebelopsio/boundary/releases/download/v0.14.0/boundary-lsp-x86_64-apple-darwin.tar.xz"
      sha256 "a3980fbe5dd8a92a0d276bab133417d0506a8a83d15ee6956a3c1ebfa58e85ca"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rebelopsio/boundary/releases/download/v0.14.0/boundary-lsp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bdda01fca5b04441ea89ff338e474beda12123d4e201fbcc51c981d11e203ac1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rebelopsio/boundary/releases/download/v0.14.0/boundary-lsp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "284cc9ae66c8f39edf31f765213f4afc8ed881db25827c2dc7e8906c444f24fb"
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
