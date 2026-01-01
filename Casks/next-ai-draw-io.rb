cask "next-ai-draw-io" do
  arch arm: "arm64"

  version "0.4.8"
  sha256 arm:   "4a83a3a8ed91e99e49c3650ca769e2595328d1e554bed74cb89d1820ebbe3a29"

  url "https://github.com/DayuanJiang/next-ai-draw-io/releases/download/v#{version}/Next-AI-Draw.io-#{version}#{arch == "arm64" ? "-arm64" : ""}.dmg",
      verified: "github.com/DayuanJiang/next-ai-draw-io/"
  name "Next AI Draw.io"
  desc "AI-assisted draw.io diagramming (desktop)"
  homepage "https://github.com/DayuanJiang/next-ai-draw-io"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true

  depends_on macos: ">= :monterey"

  app "Next AI Draw.io.app"

  # shim script (https://github.com/Homebrew/homebrew-cask/issues/18809)
  shimscript = "#{staged_path}/next-ai-draw-io.wrapper.sh"
  binary shimscript, target: "next-ai-draw-io"

  preflight do
    File.write shimscript, <<~EOS
      #!/bin/bash
      exec '#{appdir}/Next AI Draw.io.app/Contents/MacOS/Next AI Draw.io' "$@"
    EOS
  end
  caveats <<~EOS
  This app is not code-signed/notarized. macOS may show security warnings.

  If you see “App is damaged”, you can remove the quarantine attribute:

    sudo xattr -rd com.apple.quarantine "#{appdir}/Next AI Draw.io.app"

  the command is to be executed by homebrew
EOS

postflight do
  system_command "/usr/bin/xattr",
                 args: ["-rd", "com.apple.quarantine", "#{appdir}/Next AI Draw.io.app"],
                 sudo: true
end

end
