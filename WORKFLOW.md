# Daily Workflow

[Overview](README.md) · [Setup and maintenance](SETUP.md)

## Keyboard cheat sheet

**Hyper** means holding Caps Lock with the configured Karabiner profile. It sends Command+Control+Option+Shift. Hyper shortcuts below are defined in Ghostty and intended for a focused Herdr session.

**Prefix** means press **Ctrl+B**, release, then press the next key/chord.

| Shortcut | Action |
| --- | --- |
| **Hyper+O** | Open the agent chooser. Herdr equivalent: prefix, **Ctrl+O**. |
| **Hyper+U** | Open the URL chooser for the focused pane. Herdr equivalent: prefix, **Shift+O**. |
| **Option+Shift+J / K** | Next / previous Herdr workspace. |
| Prefix, **C** | New tab, without a naming prompt. |
| Prefix, **N / P** | Next / previous tab. |
| Prefix, **V** | Split into side-by-side panes. |
| Prefix, **-** | Split into stacked panes. |
| Prefix, **H / J / K / L** | Focus the pane left / down / up / right. |
| Prefix, **Z** | Toggle focused-pane zoom. |
| Prefix, **W** | Workspace navigation. |
| Prefix, **Q** | Detach; leave terminals and agents running. |
| Prefix, **Shift+R** | Reload Herdr configuration. |
| **Cmd+Shift+,** | Reload Ghostty configuration. |

Hyper+O is deliberate: Hyper+C is assigned to clearing notifications in SuperCharge on this machine.

## Workspaces and persistence

Use a workspace per project, tabs for different views, and panes for the agent, shell, and development server. A workspace is a terminal container, not a separate Git checkout.

Start or reattach with `herdr`. To step away, use prefix, **Q**, instead of `/exit` in each agent. Running `herdr` again reconnects to the live server and its workspaces.

The host must stay awake for local work to continue. A reboot ends the original processes; Herdr can restore layout and resume supported agent conversations through its integrations. Screen-history persistence is not enabled in this configuration.

## Agent chooser

Press **Hyper+O**:

- **Attention** lists blocked or finished agents, newest state changes first.
- **Working** lists agents still running; **All** includes idle agents too.
- **Tab / Shift+Tab** cycles views; type to filter.
- **Enter** focuses the selected agent; **Esc** closes the popup.
- **Ctrl+R** refreshes. The picker also refreshes periodically while open.

Status labels include `! blocked`, `✓ done`, `▶ working`, and `○ idle`, so color is not the only cue.

## URL chooser

Press **Hyper+U** to extract URLs from the focused pane's recent output (roughly a screenful):

- A single unambiguous URL opens directly in the default browser.
- With multiple URLs, type to filter, **Enter** to open, or **Y** to copy.
- **Esc** closes the picker. If no URLs are found, press any key to close the message.

The script attempts to join wrapped links and asks you to verify reconstructed candidates when it cannot confirm them. This is a text-based URL finder, not a search of every link in the agent's conversation history.

## Ghostty appearance and configuration

The primary config is [`.config/ghostty/config`](.config/ghostty/config), linked as `~/.config/ghostty/config`. It selects Menlo, GitHub Dark Colorblind, extra row spacing and padding, and a short cursor-warp animation.

Ghostty can also load `~/Library/Application Support/com.mitchellh.ghostty/config`. **Cmd+,** may open that file rather than the dotfiles copy. The macOS-specific location loads after the XDG location, so check both when settings disagree.

```fish
# See available font family names and the effective configuration.
ghostty +list-fonts
ghostty +show-config
ghostty +validate-config
```

Use a font's family name in `font-family`, not its Homebrew cask name. Reload with **Cmd+Shift+,**; padding changes require a new terminal surface. To remove the cursor animation, comment out `custom-shader` and reload.

## Herdr notifications and plugins

The config uses in-app agent notifications, distinct status symbols, and automatic copy-on-select. Herdr's clipboard popup is disabled. Other applications, including an agent TUI, can still show their own copy notifications.

Plugin source lives under `.config/herdr/plugins/local/`; registration lives outside version control. If a chooser is missing on another machine, follow [plugin setup](SETUP.md#8-enable-the-herdr-workflow).

```fish
herdr plugin list
herdr plugin log list --plugin agent-chooser --limit 5
herdr plugin log list --plugin url-chooser --limit 5
```

If a Hyper shortcut triggers a different app, check global shortcuts in tools such as SuperCharge. Try the Herdr prefix shortcut to distinguish a keyboard conflict from a plugin error.
