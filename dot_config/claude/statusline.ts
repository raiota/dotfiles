#!/usr/bin/env bun

/**
 * Claude Code Statusline - Pattern 5: Braille Dots
 *
 * Displays rate limit usage (5h / 7d windows) as braille dot progress bars
 * with color gradients: green (0-49%) → yellow (50-74%) → red (75-100%)
 *
 * Usage in settings.json:
 *   "statusLine": { "type": "command", "command": "bun ~/.config/claude/statusline.ts" }
 */

interface RateLimit {
  used_percentage: number;
  resets_at?: number;
}

interface StatusInput {
  rate_limits?: {
    five_hour?: RateLimit;
    seven_day?: RateLimit;
  };
}

const RESET = "\x1b[0m";

// Braille characters from empty → full (8 levels, Pattern 5)
const BRAILLE = [" ", "⣀", "⣄", "⣤", "⣦", "⣶", "⣷", "⣿"] as const;
const BAR_WIDTH = 10;

/** RGB color gradient: green (0%) → yellow (50%) → red (100%) */
function getColor(pct: number): string {
  let r: number, g: number;
  if (pct < 50) {
    r = Math.round(pct * 5.1);
    g = 255;
  } else {
    r = 255;
    g = Math.round(200 - (pct - 50) * 4);
  }
  return `\x1b[38;2;${r};${g};0m`;
}

function brailleBar(pct: number): string {
  const clamped = Math.min(Math.max(pct, 0), 100);
  const filled = (clamped / 100) * BAR_WIDTH;
  const fullBlocks = Math.floor(filled);
  const partial = filled - fullBlocks;

  let bar = "";
  for (let i = 0; i < BAR_WIDTH; i++) {
    if (i < fullBlocks) {
      bar += "⣿";
    } else if (i === fullBlocks && partial > 0) {
      // Map partial fraction to intermediate braille chars (excluding last "⣿")
      const idx = Math.round(partial * (BRAILLE.length - 2));
      bar += BRAILLE[idx];
    } else {
      bar += "⣀";
    }
  }
  return bar;
}

function formatResetTime(resetsAt: number): string {
  const remaining = resetsAt - Date.now() / 1000;
  if (remaining <= 0) return "resetting";
  const h = Math.floor(remaining / 3600);
  const m = Math.floor((remaining % 3600) / 60);
  return h > 0 ? `${h}h${m}m` : `${m}m`;
}

const raw = await Bun.stdin.text();

let data: StatusInput;
try {
  data = JSON.parse(raw);
} catch {
  process.exit(0);
}

const rl = data.rate_limits;
if (!rl) process.exit(0);

const lines: string[] = [];

if (rl.five_hour != null) {
  const pct = rl.five_hour.used_percentage ?? 0;
  const color = getColor(pct);
  const bar = brailleBar(pct);
  const time = rl.five_hour.resets_at ? ` ${formatResetTime(rl.five_hour.resets_at)}` : "";
  lines.push(`${color}5h ${bar} ${Math.round(pct)}%${time}${RESET}`);
}

if (rl.seven_day != null) {
  const pct = rl.seven_day.used_percentage ?? 0;
  const color = getColor(pct);
  const bar = brailleBar(pct);
  const time = rl.seven_day.resets_at ? ` ${formatResetTime(rl.seven_day.resets_at)}` : "";
  lines.push(`${color}7d ${bar} ${Math.round(pct)}%${time}${RESET}`);
}

if (lines.length > 0) {
  process.stdout.write(lines.join("\n") + "\n");
}
