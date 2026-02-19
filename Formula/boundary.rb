class Boundary < Formula
  desc "A static analysis tool for evaluating DDD and Hexagonal Architecture"
  homepage "https://github.com/rebelopsio/boundary"
  version "0.10.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rebelopsio/boundary/releases/download/v0.10.0/boundary-aarch64-apple-darwin.tar.xz"
      sha256 "29816d5d8a1ee9d4302c8b05d146249c9de53ec9009a654327450b2bc81a5b77"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rebelopsio/boundary/releases/download/v0.10.0/boundary-x86_64-apple-darwin.tar.xz"
      sha256 "749f4d137815b72e059f134ae2aaec35fc2ad407301d5e5b7df3435462dc155b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rebelopsio/boundary/releases/download/v0.10.0/boundary-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ef56d17b083569beacbe03eb2096653ba6fa0455695a5db4d9b68e723a271a75"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rebelopsio/boundary/releases/download/v0.10.0/boundary-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "714a0311bbac54595135dfe3780f99fb49f95eb5416079bbed8197283dedee47"
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
