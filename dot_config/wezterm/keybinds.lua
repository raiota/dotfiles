local wezterm = require 'wezterm'
local act = wezterm.action

local module = {}

function module.apply_to_config(config)
  -- Leader キー設定 (tmuxのprefixに相当)
  -- CTRL+A を押してから、次のキーを押す
  config.leader = {
    key = 'a',
    mods = 'CTRL',
    timeout_milliseconds = 1500,
  }

  config.keys = {
    -- ペイン分割 (tmux風)
    -- LEADER + | : 左右に分割
    {
      key = '|',
      mods = 'LEADER|SHIFT',
      action = act.SplitHorizontal { domain = 'CurrentPaneDomain' },
    },
    -- LEADER + - : 上下に分割
    {
      key = '-',
      mods = 'LEADER',
      action = act.SplitVertical { domain = 'CurrentPaneDomain' },
    },

    -- ペイン移動 (vim風) LEADER + hjkl
    {
      key = 'h',
      mods = 'LEADER',
      action = act.ActivatePaneDirection 'Left',
    },
    {
      key = 'l',
      mods = 'LEADER',
      action = act.ActivatePaneDirection 'Right',
    },
    {
      key = 'k',
      mods = 'LEADER',
      action = act.ActivatePaneDirection 'Up',
    },
    {
      key = 'j',
      mods = 'LEADER',
      action = act.ActivatePaneDirection 'Down',
    },

    -- ペインリサイズ (vim風・Shift付き) LEADER + HJKL
    {
      key = 'H',
      mods = 'LEADER|SHIFT',
      action = act.AdjustPaneSize { 'Left', 5 },
    },
    {
      key = 'L',
      mods = 'LEADER|SHIFT',
      action = act.AdjustPaneSize { 'Right', 5 },
    },
    {
      key = 'K',
      mods = 'LEADER|SHIFT',
      action = act.AdjustPaneSize { 'Up', 5 },
    },
    {
      key = 'J',
      mods = 'LEADER|SHIFT',
      action = act.AdjustPaneSize { 'Down', 5 },
    },

    -- LEADER + z : ペインズーム/ズーム解除
    {
      key = 'z',
      mods = 'LEADER',
      action = act.TogglePaneZoomState,
    },

    -- LEADER + x : 現在のペインを閉じる
    {
      key = 'x',
      mods = 'LEADER',
      action = act.CloseCurrentPane { confirm = true },
    },

    -- タブ管理
    -- LEADER + c : 新しいタブを作成
    {
      key = 'c',
      mods = 'LEADER',
      action = act.SpawnTab 'CurrentPaneDomain',
    },
    -- LEADER + n/p : 次/前のタブへ移動
    {
      key = 'n',
      mods = 'LEADER',
      action = act.ActivateTabRelative(1),
    },
    {
      key = 'p',
      mods = 'LEADER',
      action = act.ActivateTabRelative(-1),
    },

    -- LEADER + 1〜9 : タブ番号で直接移動
    { key = '1', mods = 'LEADER', action = act.ActivateTab(0) },
    { key = '2', mods = 'LEADER', action = act.ActivateTab(1) },
    { key = '3', mods = 'LEADER', action = act.ActivateTab(2) },
    { key = '4', mods = 'LEADER', action = act.ActivateTab(3) },
    { key = '5', mods = 'LEADER', action = act.ActivateTab(4) },
    { key = '6', mods = 'LEADER', action = act.ActivateTab(5) },
    { key = '7', mods = 'LEADER', action = act.ActivateTab(6) },
    { key = '8', mods = 'LEADER', action = act.ActivateTab(7) },
    { key = '9', mods = 'LEADER', action = act.ActivateTab(8) },

    -- LEADER + & : 現在のタブを閉じる
    {
      key = '&',
      mods = 'LEADER|SHIFT',
      action = act.CloseCurrentTab { confirm = true },
    },

    -- コピー・テキスト選択
    -- LEADER + [ : コピーモード開始
    {
      key = '[',
      mods = 'LEADER',
      action = act.ActivateCopyMode,
    },
    -- LEADER + Space : QuickSelect
    {
      key = 'Space',
      mods = 'LEADER',
      action = act.QuickSelect,
    },

    -- CTRL+A の素通し (LEADER + CTRL+A で実際のCTRL+Aを送信)
    {
      key = 'a',
      mods = 'LEADER|CTRL',
      action = act.SendKey { key = 'a', mods = 'CTRL' },
    },

    -- クリップボード操作
    {
      key = 'C',
      mods = 'CTRL|SHIFT',
      action = act.CopyTo 'Clipboard',
    },
    {
      key = 'V',
      mods = 'CTRL|SHIFT',
      action = act.PasteFrom 'Clipboard',
    },

    -- フォントサイズ変更
    { key = '+', mods = 'CTRL',       action = act.IncreaseFontSize },
    { key = '-', mods = 'CTRL',       action = act.DecreaseFontSize },
    { key = '0', mods = 'CTRL',       action = act.ResetFontSize },

    -- その他
    -- LEADER + r : 設定リロード
    {
      key = 'r',
      mods = 'LEADER',
      action = act.ReloadConfiguration,
    },
    -- LEADER + f : コマンドパレット
    {
      key = 'f',
      mods = 'LEADER',
      action = act.ActivateCommandPalette,
    },
    -- LEADER + ? : デバッグオーバーレイ
    {
      key = '?',
      mods = 'LEADER|SHIFT',
      action = act.ShowDebugOverlay,
    },
  }

  -- コピーモード内のキーバインド (vim風)
  local copy_mode = wezterm.gui.default_key_tables().copy_mode
  config.key_tables = {
    copy_mode = copy_mode,
  }
end

return module
