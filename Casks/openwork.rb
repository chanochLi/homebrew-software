cask "openwork" do
  arch arm: "aarch64", intel: "x64"

  version "0.3.7"
  sha256 arm:   "610543927eefc808837da26be90db2548ce1e9131368714553cfe89e8b263017",
         intel: "774b956727c0919fe24817535f7169ea0f0f3359ca0e092fe4f9848624d3b458"

  url "https://github.com/different-ai/openwork/releases/download/v#{version}/openwork-desktop-darwin-#{arch}.dmg",
      verified: "github.com/different-ai/openwork/"
  name "OpenWork"
  desc "Open-source desktop agent (opencode-based)"
  homepage "https://github.com/different-ai/openwork"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :monterey"

  app "OpenWork.app"
end
