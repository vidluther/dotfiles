# Keyboard shortcuts

Quick reference for our Ghostty → Herdr → agent workflow.
See [Daily workflow](WORKFLOW.md) for details and [Setup](SETUP.md#8-enable-the-herdr-workflow) for plugin registration.

**Hyper** = hold **Caps Lock** (Command+Control+Option+Shift).
**Prefix → key** = press **Ctrl+B**, release, then press the key. Letters are lowercase unless **Shift** is explicitly shown.

## Workspaces, tabs, and panes

| Shortcut | Action |
| --- | --- |
| Prefix → **w** | Open workspace navigator |
| **Option+Shift+J / K** | Next / previous workspace |
| Prefix → **Shift+N** | New workspace |
| Prefix → **Shift+W** | Rename workspace |
| Prefix → **b** | Toggle sidebar |
| Prefix → **c** | New tab, without a naming prompt |
| Prefix → **n / p** | Next / previous tab |
| Prefix → **1–9** | Select tab |
| Prefix → **Shift+T** | Rename tab |
| Prefix → **v** | Split into side-by-side panes |
| Prefix → **-** | Split into stacked panes |
| Prefix → **h / j / k / l** | Focus pane left / down / up / right |
| Prefix → **z** | Zoom / unzoom focused pane |
| Prefix → **?** | Show Herdr shortcut help |
| Prefix → **q** | Detach; leave terminals and agents running |

**Hyper+W** is configured to send prefix → **w**, but currently does not work reliably on this machine. Use **Ctrl+B**, then **w** instead; the cause remains unresolved.

## Agent chooser

Open with **Hyper+O**, or prefix → **Ctrl+O**.

| Key | Action |
| --- | --- |
| **Tab / Shift+Tab** | Cycle Attention / Working / All views |
| Type | Filter agents |
| **Enter** | Focus selected agent |
| **Ctrl+R** | Refresh; also refreshes periodically |
| **Esc** | Close |

Start in **Attention** for blocked or finished agents. Use **Working** for running agents or **All** to include idle ones.
Status cues: `! blocked`, `✓ done`, `▶ working`, `○ idle`.

## URL chooser

Open with **Hyper+U**, or prefix → **Shift+O**.

| Key | Action |
| --- | --- |
| Type | Filter URLs |
| **Enter** | Open selected URL in the default browser |
| **Y** | Copy selected URL |
| **Esc** | Close |

One unambiguous URL opens immediately. Links come from the focused pane's recent output, not the entire conversation history. Reconstructed wrapped links may require confirmation.

## Daily workflow

1. Run `herdr` to start or reconnect.
2. Use one workspace per project, tabs for views, and panes for agents, shells, and development servers.
3. Switch projects with **Option+Shift+J / K** or prefix → **w**.
4. Use **Hyper+O** to find agents needing attention, and **Hyper+U** to open their links.
5. Use prefix → **b** to reclaim sidebar space, or prefix → **z** to focus on one pane.
6. Step away with prefix → **q**, not `/exit` in each agent. Run `herdr` again to reconnect.

Workspaces do **not** isolate Git changes. The host must stay awake for local processes to continue; rebooting ends those processes. Integrations can restore supported agent conversations, but screen-history persistence is disabled.

The sidebar is capped at **20 columns**. Herdr agent notification sounds are disabled; in-app notifications remain enabled. Selecting terminal text copies it automatically, without Herdr's clipboard popup.

## Reload and setup

| Shortcut | Action |
| --- | --- |
| Prefix → **Shift+R** | Reload Herdr configuration |
| **Cmd+Shift+,** | Reload Ghostty configuration |

Stow links plugin files but does **not** register plugins. Run once per machine/account:

```fish
herdr plugin link ~/.config/herdr/plugins/local/agent-chooser
herdr plugin link ~/.config/herdr/plugins/local/url-chooser
```

If a Hyper shortcut fails, try its prefix equivalent to distinguish a keyboard conflict from a Herdr/plugin issue. **Hyper+C** is reserved for clearing notifications in SuperCharge.
