class BoundaryLsp < Formula
  desc "LSP server for boundary architecture analysis"
  homepage "https://github.com/rebelopsio/boundary"
  version "0.16.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rebelopsio/boundary/releases/download/v0.16.0/boundary-lsp-aarch64-apple-darwin.tar.xz"
      sha256 "968e11df782006323da2684f37cbf865cc1227381c77275d557f05bddaa356b6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rebelopsio/boundary/releases/download/v0.16.0/boundary-lsp-x86_64-apple-darwin.tar.xz"
      sha256 "057e021112086d6b439b2468622eb2cf0f8573bc0197366dc74eb5c9154fa04a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rebelopsio/boundary/releases/download/v0.16.0/boundary-lsp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2f96f8dd3bd4c8216470e44648bb6177616c375af7526b5f904d386ccacf43e6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rebelopsio/boundary/releases/download/v0.16.0/boundary-lsp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "19b030bc5805b4f619b394c5c541170d586a547c665b907cda4f35d0bdf7804c"
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
