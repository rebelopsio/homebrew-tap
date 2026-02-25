class Boundary < Formula
  desc "A static analysis tool for evaluating DDD and Hexagonal Architecture"
  homepage "https://github.com/rebelopsio/boundary"
  version "0.20.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rebelopsio/boundary/releases/download/v0.20.0/boundary-aarch64-apple-darwin.tar.xz"
      sha256 "b9a633fc66058c3a6249156319228c206929c9092297a21b020f686c97995f65"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rebelopsio/boundary/releases/download/v0.20.0/boundary-x86_64-apple-darwin.tar.xz"
      sha256 "3be8dde19b1cb7693e87bb2b2b3c397dcef5e6dcd061891a9903ce9bf20f20ed"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rebelopsio/boundary/releases/download/v0.20.0/boundary-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "72998aeb9b3f6513880a7b5d4c0eddd0bbf7e7da870eadcf15a611132726c625"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rebelopsio/boundary/releases/download/v0.20.0/boundary-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "18331f842f0162bec6bd87ae81242edaa86498b1f9ef357afda36acbd88815d1"
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
