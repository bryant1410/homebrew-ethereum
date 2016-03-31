require 'formula'

class Ethereum < Formula
  version '1.3.5'

  homepage 'https://github.com/ethereum/go-ethereum'
  url 'https://github.com/ethereum/go-ethereum.git', :branch => 'master'

  bottle do
    revision 12
    root_url 'https://build.ethdev.com/builds/bottles'
    sha256 '0d5a8107b792921465b5ac774f1ecb2a23c0a09e10114ecd8a736de0b423c26a' => :yosemite
    sha256 '53c9f65c0e4fee1d4d6d65df0eaff725a91c5f7dfb006c1f3cc3250679ec0f58' => :el_capitan
  end

  devel do
    bottle do
      revision 130
      root_url 'https://build.ethdev.com/builds/bottles-dev'
      sha256 'd8fbefa2685c9370a700be2f1f63af0e95d490d999710f37bbce61d5c1975bb5' => :yosemite
      sha256 '5cdb75226a03ded07c29cd3256f559f0cabcd944289a601fc61de38b2449305d' => :el_capitan
    end

    version '1.4.0'
    url 'https://github.com/ethereum/go-ethereum.git', :branch => 'develop'
  end

  depends_on 'go' => :build

  def install
    ENV["GOROOT"] = "#{HOMEBREW_PREFIX}/opt/go/libexec"
    system "go", "env" # Debug env
    system "make", "all"
    bin.install 'build/bin/evm'
    bin.install 'build/bin/geth'
    bin.install 'build/bin/rlpdump'
  end

  test do
    system "make", "test"
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>ThrottleInterval</key>
        <integer>300</integer>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_bin}/geth</string>
            <string>-datadir=#{prefix}/.ethereum</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
      </dict>
    </plist>
    EOS
  end
end
