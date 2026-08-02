cask "j-hen-tai" do
  version "8.0.14+328"
  sha256 "2b8f6e4b56df137bf1cd772e5bc7a1f58df3305a42fdcbf79e6a1a06c378fc94"

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
