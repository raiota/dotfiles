#!/usr/bin/env bun

/**
 * Claude Code Statusline - Pattern 5: Braille Dots
 *
 * Displays rate limit usage (5h / 7d windows) as braille dot progress bars
 * with color gradients. Based on the original Pattern 5 by @gyakuse.
 *
 * Usage in settings.json:
 *   "statusLine": { "type": "command", "command": "bun ~/.config/claude/statusline.ts" }
 */

interface RateLimit {
  used_percentage: number;
}

interface StatusInput {
  model?: { display_name?: string };
  context_window?: { used_percentage?: number };
  rate_limits?: {
    five_hour?: RateLimit;
    seven_day?: RateLimit;
  };
}

const RESET = "\x1b[0m";
const DIM = "\x1b[2m";

// 8 braille characters: index 0 (empty/space) → index 7 (full ⣿)
const BRAILLE = " ⣀⣄⣤⣦⣶⣷⣿";
const BAR_WIDTH = 8;

/** RGB color gradient matching original: green (0%) → yellow (50%) → red (100%) */
function gradient(pct: number): string {
  if (pct < 50) {
    const r = Math.floor(pct * 5.1);
    return `\x1b[38;2;${r};200;80m`;
  } else {
    const g = Math.max(Math.floor(200 - (pct - 50) * 4), 0);
    return `\x1b[38;2;255;${g};60m`;
  }
}

/** Build braille bar using seg_start/seg_end approach (matches original algorithm) */
function brailleBar(pct: number): string {
  const clamped = Math.min(Math.max(pct, 0), 100);
  const level = clamped / 100;
  let bar = "";
  for (let i = 0; i < BAR_WIDTH; i++) {
    const segStart = i / BAR_WIDTH;
    const segEnd = (i + 1) / BAR_WIDTH;
    if (level >= segEnd) {
      bar += BRAILLE[7]; // fully filled: ⣿
    } else if (level <= segStart) {
      bar += BRAILLE[0]; // empty: space
    } else {
      const frac = (level - segStart) / (segEnd - segStart);
      bar += BRAILLE[Math.min(Math.floor(frac * 7), 7)]; // partial
    }
  }
  return bar;
}

/** Format one segment: [DIM label RESET] [color bar RESET] pct% */
function fmt(label: string, pct: number): string {
  const p = Math.round(pct);
  return `${DIM}${label}${RESET} ${gradient(pct)}${brailleBar(pct)}${RESET} ${p}%`;
}

const raw = await Bun.stdin.text();

let data: StatusInput;
try {
  data = JSON.parse(raw);
} catch {
  process.exit(0);
}

const parts: string[] = [];

const modelName = data.model?.display_name;
if (modelName) parts.push(modelName);

const ctx = data.context_window?.used_percentage;
if (ctx != null) parts.push(fmt("ctx", ctx));

const rl = data.rate_limits;
if (rl?.five_hour != null) parts.push(fmt("5h", rl.five_hour.used_percentage ?? 0));
if (rl?.seven_day != null) parts.push(fmt("7d", rl.seven_day.used_percentage ?? 0));

if (parts.length > 0) {
  process.stdout.write(parts.join(` ${DIM}│${RESET} `));
}
