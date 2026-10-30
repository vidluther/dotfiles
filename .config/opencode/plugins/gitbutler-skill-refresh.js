// Keep the gitbutler skill in sync with the installed `but` CLI.
// Runs ~/work/personal/skills/scripts/refresh-gitbutler-skill.sh once when
// OpenCode loads plugins; the script is a no-op when the versions already match.

import { execFile } from "node:child_process";
import { homedir } from "node:os";
import { join } from "node:path";

const SCRIPT = join(homedir(), "work/personal/skills/scripts/refresh-gitbutler-skill.sh");

export const GitbutlerSkillRefresh = async () => {
  execFile("bash", [SCRIPT], { timeout: 30_000 }, () => {});
  return {};
};
