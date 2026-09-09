cask "j-hen-tai" do
  version "8.0.16+334"
  sha256 "9726958c5a64d03cd9e62509adc2f73c029e963dc918a7dfbd04985433219c96"

  url "https://github.com/jiangtian616/JHenTai/releases/download/v#{version}/JHenTai-#{version}.dmg",
      verified: "github.com/jiangtian616/JHenTai/"
  name "JHenTai"
  desc "Cross-platform E-Hentai browser"
  homepage "https://github.com/jiangtian616/JHenTai"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: :catalina

  app "jhentai.app"

  uninstall quit:   "top.jtmonster.jhentai",
            delete: "/Applications/jhentai.app"

  zap trash: [
    "~/Library/Application Support/top.jtmonster.jhentai",
    "~/Library/Caches/top.jtmonster.jhentai",
    "~/Library/Preferences/top.jtmonster.jhentai.plist",
    "~/Library/Saved Application State/top.jtmonster.jhentai.savedState",
  ]
end
