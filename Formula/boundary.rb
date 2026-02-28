class Boundary < Formula
  desc "A static analysis tool for evaluating DDD and Hexagonal Architecture"
  homepage "https://github.com/rebelopsio/boundary"
  version "0.23.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rebelopsio/boundary/releases/download/v0.23.0/boundary-aarch64-apple-darwin.tar.xz"
      sha256 "28ad59eaa911a4a5a2753103fbcafb185207071098e518f215177752e1bb437e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rebelopsio/boundary/releases/download/v0.23.0/boundary-x86_64-apple-darwin.tar.xz"
      sha256 "532fe057508f862cf5bf7ae213b5224cdd0163abf9611040c765790674a93c0c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rebelopsio/boundary/releases/download/v0.23.0/boundary-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "45488efcd66e2f78b492e24be202fe8876d68b4b4b9ac3fff5917936175ac66f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rebelopsio/boundary/releases/download/v0.23.0/boundary-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8a060dff5c9bda8568564192d439ec2882e5da66c9f3d9dbce0cd122468f7aa1"
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
