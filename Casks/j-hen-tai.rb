cask "j-hen-tai" do
  version "8.0.14"
  sha256 "5ad8497555f82cef08d8e53be754dbe81386d73a63dd7ee9bea9f7ffbc701277"

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
