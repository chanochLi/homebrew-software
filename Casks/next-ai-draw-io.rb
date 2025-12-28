cask "next-ai-draw-io" do
  arch arm: "arm64", intel: "intel"

  version "0.4.7"
  sha256 arm:   "12ecbcfc7864d505c3b25f0459783db1a8cbeeb496885264afe76dffda",
         intel: "f7aa3e741b762ef96a9dbc758e2b2d9e2bef96a1fa68b3a51fdd46bd"

  url "https://github.com/DayuanJiang/next-ai-draw-io/releases/download/v#{version}/Next-AI-Draw.io-#{version}#{arch == "arm64" ? "-arm64" : ""}.dmg",
      verified: "github.com/DayuanJiang/next-ai-draw-io/"
  name "Next AI Draw.io"
  desc "AI-assisted draw.io diagramming (desktop)"
  homepage "https://github.com/DayuanJiang/next-ai-draw-io"

  # If the project tags releases consistently, you can keep this.
  # Otherwise you may want strategy :page_match or similar.
  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true

  # Adjust if you know the minimum supported version.
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

  zap trash: [
    # These are best-effort guesses; confirm actual bundle id paths after running once.
    "~/Library/Application Support/Next AI Draw.io",
    "~/Library/Caches/*next-ai-draw-io*",
    "~/Library/HTTPStorages/*next-ai-draw-io*",
    "~/Library/Logs/Next AI Draw.io",
    "~/Library/Preferences/*next-ai-draw-io*.plist",
    "~/Library/Saved Application State/*next-ai-draw-io*.savedState",
  ]
end
