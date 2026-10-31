cask "next-ai-draw-io" do
  arch arm: "arm64"

  version "0.5.1"
  sha256 arm: "050213bc49893d542bf077312aa2f987cb72a7d5a5290727aa62157947fb47de"

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
  depends_on macos: :monterey

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
