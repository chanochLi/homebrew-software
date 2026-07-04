cask "j-hen-tai" do
  version "8.0.14+321"
  sha256 "44e7ed78978a3b7e44b5dd72f8726e400f5ad168b43c8d6da15dda09fcadd7d1"

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
