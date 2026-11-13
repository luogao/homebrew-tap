cask "sotto" do
  version "0.1.2"
  sha256 "22ad118483a1b789a033ffdc9b72dd6fe692e7d132de65efad49eaa4b745769b"

  url "https://github.com/luogao/sotto/releases/download/v#{version}/Sotto-#{version}.dmg"
  name "Sotto"
  desc "Hold a hotkey to talk, release to paste: offline speech-to-text for macOS"
  homepage "https://sotto.rungundam.top"

  depends_on macos: :ventura
  depends_on arch: :arm64

  app "Sotto.app"

  # ad-hoc 签名的应用带 quarantine 会被 Gatekeeper 拦，装完直接去掉，
  # 用户不用再手动 xattr（cask 分发自己的签名产物，风险可控）
  postflight_steps do
    run "/usr/bin/xattr",
        args: ["-dr", "com.apple.quarantine", "{{appdir}}/Sotto.app"],
        writable_paths: ["{{appdir}}/Sotto.app"]
  end

  caveats <<~EOS
    首次启动会在菜单栏出现麦克风图标，并请求麦克风权限。
    Mac mini 等没有内置麦克风的机型需外接麦克风才能录音。
    模型已内置在 app 里，不需要额外下载。
    日志：~/Library/Caches/sotto/sotto.log
  EOS

  zap trash: [
    "~/Library/Caches/sotto",
    "~/Library/Application Support/Sotto",
    "~/Library/Preferences/top.rungundam.sotto.plist",
  ]
end
