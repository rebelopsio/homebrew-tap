class Boundary < Formula
  desc "A static analysis tool for evaluating DDD and Hexagonal Architecture"
  homepage "https://github.com/rebelopsio/boundary"
  version "0.8.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rebelopsio/boundary/releases/download/v0.8.1/boundary-aarch64-apple-darwin.tar.xz"
      sha256 "040640190564e200489f533ce70ccb82d991178e3c10044ca094ee2075b2f79f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rebelopsio/boundary/releases/download/v0.8.1/boundary-x86_64-apple-darwin.tar.xz"
      sha256 "8f350a9d576447c7814273f72cc7b4b1d1d13e26bdc3427c5ea3380f189147a3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rebelopsio/boundary/releases/download/v0.8.1/boundary-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ba5c46d2cf9768b3e281c0bcc6f0829cd8b8e34539472b765aab145e862a80c3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rebelopsio/boundary/releases/download/v0.8.1/boundary-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "071d7f2ef247d76b8c96253c8e5781e8aae80521a7928d1244c52ffa771cfcaf"
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
