class Boundary < Formula
  desc "A static analysis tool for evaluating DDD and Hexagonal Architecture"
  homepage "https://github.com/rebelopsio/boundary"
  version "0.9.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rebelopsio/boundary/releases/download/v0.9.0/boundary-aarch64-apple-darwin.tar.xz"
      sha256 "7898ea34b97de895d2e822c9ecc650b81afdff93b220e2f5cdd9cf6affe1cc49"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rebelopsio/boundary/releases/download/v0.9.0/boundary-x86_64-apple-darwin.tar.xz"
      sha256 "3b430f82733b8079af9899ad9bd08131dbbf0d62dc346ddeef60aa14b29ed00e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rebelopsio/boundary/releases/download/v0.9.0/boundary-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "df26a97c68003bd7344bbc1a4e0c273137cc1b1f13e5bb037ace576c3c37050a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rebelopsio/boundary/releases/download/v0.9.0/boundary-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c8c34af340431be0405cd5cae31325967de5d70323c971def471eafa5e65cc85"
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
    bin.install "boundary" if OS.mac? && Hardware::CPU.arm?
    bin.install "boundary" if OS.mac? && Hardware::CPU.intel?
    bin.install "boundary" if OS.linux? && Hardware::CPU.arm?
    bin.install "boundary" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
