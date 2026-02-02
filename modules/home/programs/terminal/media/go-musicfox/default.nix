{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  persist = osConfig.wktlnix.system.persist.enable;

  cfg = config.wktlnix.programs.terminal.media.go-musicfox;
in
{
  options.wktlnix.programs.terminal.media.go-musicfox = {
    enable = mkEnableOption "Whether or not to enable support for go-musicfox.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      go-musicfox
    ];

    home.persistence = mkIf persist {
      "/persist" = {
        directories = [ ".local/share/go-musicfox" ];
      };
    };
    xdg.configFile = {
      "go-musicfox/config.toml".text = ''
        # 启动页相关配置
        [startup]
        # 是否显示启动页
        enable = true
        # 启动页进度条是否具有回弹效果
        progressOutBounce = true
        # 启动页的持续时长（秒）
        loadingSeconds = 2
        # 启动页欢迎语
        welcome = "musicfox"
        # 启动时是否自动签到 (网易云有风控，建议关闭)
        signIn = false
        # 启动时是否检查应用更新
        checkUpdate = true

        # 主界面与核心功能配置
        [main]
        # altScreen 显示模式
        altScreen = true
        # 是否在界面中启用鼠标事件
        enableMouseEvent = false
        # 是否开启 Debug 模式
        debug = false
        # 播放时 UI 刷新帧率（更高帧率可使动画更平滑，但消耗更多cpu）
        frameRate = 30

        # 桌面通知相关设置
        [main.notification]
        # 是否启用桌面通知
        enable = true
        # (Windows/Linux) 默认通知图标
        icon = "logo.png"
        # (Windows/Linux) 是否使用歌曲的专辑封面作为通知图标（如为否则使用默认通知图标）
        albumCover = true

        # 歌词显示相关设置
        [main.lyric]
        # 是否显示歌词
        show = true
        # 是否显示翻译歌词
        showTranslation = true
        # 歌词显示时间的全局偏移量（毫秒），正值表示歌词提前显示
        offset = 0
        # 忽略歌词解析错误
        skipParseErr = false
        # YRC 歌词渲染模式（仅对逐字歌词有效）
        # 可选: "simple"(简单，默认), "smooth"(平滑), "wave"(波浪), "glow"(发光)
        renderMode = "glow"

        # 封面图显示设置（需要支持Kitty图形协议的终端，如Kitty、WezTerm、Ghostty等）
        [main.lyric.cover]
        # 是否显示封面图
        show = true
        # 封面图宽度占窗口宽度的比例（取值范围 0.1-0.8，默认 0.3）
        widthRatio = 0.06
        # 封面图圆角半径百分比（取值范围 0-100，默认 8 即 8%，0 则关闭，越大越圆）
        cornerRadius = 8
        # 是否启用旋转封面（需要更高的帧率支持平滑效果）
        spin = true
        # Kitty图形协议不支持角度变化目前只能以动画呈现，合成动画需要更高的CPU性能
        # 旋转封面帧率（取值范围 1-60，默认 30，更高帧率更流畅但消耗更多CPU）
        spinFPS = 30
        # 旋转一圈的时长（秒，取值范围 1-30，默认 6）
        # 时长和帧率挂钩：60fps*6s=360帧，30fps*6s=180帧，30fps*12s=360帧
        spinDuration = 6

        # 主题设置
        [theme]
        # 是否在界面顶部显示标题
        showTitle = true
        # 菜单加载时显示的提示文字
        loadingText = "[加载中...]"
        # 是否使用双列布局（需要等宽字体以获得最佳体验）
        doubleColumn = true
        # 菜单行数是否根据终端高度动态变化
        dynamicMenuRows = false
        # 界面所有内容居中（实验性功能，未来版本中可能会大幅改动）
        centerEverything = false
        # 主题颜色
        # 随机
        # primaryColor = "random"
        primaryColor = "#ea403f" # 经典网易云音乐红

        # 进度条字符样式配置
        [theme.progress]
        # 进度条渲染模式
        # 可选: "smooth"(平滑，默认), "wave"(波浪), "glow"(发光)
        renderMode = "glow"
        # 进度条已加载字符
        fullChar = "#"
        fullCharWhenFirst = "#"
        fullCharWhenLast = "#"
        lastFullChar = "#"
        # 进度条未加载字符
        emptyChar = "·"
        emptyCharWhenFirst = "·"
        emptyCharWhenLast = "·"
        firstEmptyChar = "·"

        # 下载、缓存等文件存储相关配置
        [storage]
        # 下载目录
        # 若设置了 MUSICFOX_ROOT 变量，则默认为 MUSICFOX_ROOT}download
        # 若未设置 MUSICFOX_ROOT 变量，则为相应系统的默认下载目录的 go-musicfox 子目录
        # 请使用绝对路径
        downloadDir = ""
        # 歌词文件的默认下载目录。如果为空，则与downloadDir保持一致。
        lyricDir = ""
        # 下载歌曲时是否同时下载歌词文件（仅当下载歌曲成功时）
        downloadSongWithLyric = false
        # 下载文件的命名模板
        # 可用字段参考 #自定义分享模板 中的 song 部分，FileExt 为自适应的后缀名
        # fileNameTpl = "{{.SongName}}-{{.SongArtists}}.{{.FileExt}}"

        # 音乐播放缓存相关设置
        [storage.cache]
        # 缓存目录
        # 若设置了 MUSICFOX_ROOT 变量，则默认为 MUSICFOX_ROOT/cache
        # 若未设置 MUSICFOX_ROOT 变量，则为相应系统的默认缓存目录的 go-musicfox 子目录
        dir = ""
        # 音乐缓存路径，相对路径相对于 dir
        # 注意：如果使用 mpd，mpd 配置中的 "music_directory" 必须与 musicDir 路径一致
        musicDir = "music_cache"
        # 音乐缓存文件的总大小限制（单位：MB）
        # 0 为不使用缓存，-1 为不限制
        limit = 0

        # 播放器引擎与行为配置
        [player]
        # 播放引擎，可选: "beep", "mpd", "mpv", "osx", "win_media", "auto"（根据系统自动选择）
        # Mac 默认 "osx", Windows 默认 "win_media", 其他系统默认 "beep"
        engine = "auto"
        # 允许的最大连续失败重试次数
        maxPlayErrCount = 3
        # 期望的歌曲音质
        # 可选: "standard", "exhigh", "higher", "lossless", "hires",
        #       "jyeffect"(高清环绕声), "sky"(沉浸环绕声), "jymaster"(超清母带)
        songLevel = "sky"
        # 是否获取并显示歌单下的所有歌曲，默认前 1000 首
        # 开启后可能会占用更多内存（大量歌曲数据）和带宽（会同时发送多个请求获取歌单下歌曲数据）
        showAllSongsOfPlaylist = true
        # Ctrl + 鼠标滚轮单次滚动调节的音量值 (取值范围 1-20)
        mouseVolumeStep = 1

        # `beep` 引擎专属配置 (跨平台)
        [player.beep]
        # MP3解码器，可选: "go-mp3", "minimp3"
        # "minimp3" CPU占用更低，但稳定性可能稍逊于 "go-mp3"
        mp3Decoder = "go-mp3"

        # UNM (Unlock NetEase Music) 相关配置，用于解锁灰色或无版权歌曲
        [unm]
        # 是否启用 UNM 功能
        enable = false
        # 音源匹配来源，可配置多个，用逗号分隔
        # 可选: "kuwo", "kugou", "migu", "qq"
        sources = ["qq"]
        # UNM搜索其他平台限制 0-3
        searchLimit = 0
        # 解除会员限制
        enableLocalVip = true
        # 解除音质限制
        unlockSoundEffects = true
        # 用于获取QQ音乐音源的Cookie文件路径
        qqCookieFile = ""
        # 检测到无效的歌（如提示酷我...）时跳过播放，该效果计入播放错误计数
        skipInvalidTracks = false
      '';
    };
  };
}
