cask "next-ai-draw-io" do
  arch arm: "arm64"

  version "0.4.12"
  sha256 arm: "40cfc918695ec6ff5c0a805ec2ee685275c5aa74d473107965cf0916b0fef96c"

  url "https://github.com/DayuanJiang/next-ai-draw-io/releases/download/v#{version}/Next-AI-Draw.io-#{version}-arm64.dmg",
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
end
