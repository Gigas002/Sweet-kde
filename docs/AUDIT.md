# Audit

An audit of the Sweet Plasma 6 theme's colours (2026-11-21), after a report
that "half of the colours don't work, sometimes text is black-on-black". It
has two parts:

- §2 the black-on-black text, which came from the session, not the theme;
- §3 the colour scheme and the Plasma theme's palette.

§4 lists what was left open, and §5 is the checklist to re-run the audit.

The fixes are the commits on `master` after 9f667b5
(`git log --reverse --stat 9f667b5..master`). Each finding is one commit.

Each finding says what was found, how serious it is, and what was done:

- **fixed**, with the commit;
- **outside**: not in this repository, fixed or explained where it lives;
- **OK**: checked, nothing to do.

Severity:

- **high**: unreadable or wrong drawing in normal use;
- **medium**: wrong in a reachable case;
- **low**: polish.

## 1. Method

- **Colour roles.** A small KColorScheme program printed every colour set
  (View, Window, Button, Selection, Tooltip, Complementary, Header), in the
  active and inactive states, for the background and foreground roles. This
  is what applications get, after KDE's fallbacks. It was run on
  `color-schemes/Sweet.colors` and on `plasma/desktoptheme/Sweet/colors`,
  before and after each change.
- **Contrast.** Text colours were checked with the WCAG contrast ratio
  against the background they are drawn on (4.5:1 for text).
- **Rendering.** Plasma was started headless in a private HOME with this
  repository's files installed: `kwin_wayland --virtual`, then `plasmashell`,
  Dolphin, System Settings (Colors page) and the launcher menu, captured with
  `spectacle`. The old (9f667b5) and new trees were compared pixel by pixel.
- **The real session.** The user's running Plasma 6.8.3 session was examined
  (process environments, the systemd user environment) and captured with
  `spectacle`.

## 2. Black-on-black text

| Area | Finding | Severity | Status |
| --- | --- | --- | --- |
| Session | Qt apps in Plasma used `QT_QPA_PLATFORMTHEME=qt5ct`, not Plasma's platform theme, so they ignored the colour scheme: dark Breeze text (#232629) on Kvantum's dark background in Dolphin, a white sidebar in System Settings. It reached Plasma two ways: `~/.config/environment.d` sets `qt6ct` for niri/sway/hyprland, and a COSMIC login earlier in the boot left `qt5ct` in the systemd user manager, which outlives a logout. `startplasma-wayland` doesn't set the variable, so Plasma inherited it. Reproduced headless both ways; with `kde`, both apps are right. | high | outside: `~/.config/plasma-workspace/env/qt-platformtheme.sh` exports `QT_QPA_PLATFORMTHEME=kde`; startplasma sources it and pushes it to systemd. Checked in the live session. |

## 3. Colours

| Area | Finding | Severity | Status |
| --- | --- | --- | --- |
| Colour scheme | Button, Tooltip and Window kept Breeze's active #3daee9 and link #2980b9, and Selection's alternate was Breeze #1d99f3. | medium | fixed a15b795: Sweet-gtk's palette, active #00c1e4, link #7cb7ff, visited #c74ded, selection alternate #980ba2 |
| Colour scheme | No `[Colors:Complementary]`: KDE fell back to Breeze's #2a2e32 grey and Breeze accents. Kirigami draws overlays and media headers with this set. | medium | fixed d1a359f |
| Colour scheme | `[WM]` was #2f343f, but the Sweet-transparent decoration's titlebar is #161925. Plasma passes `[WM]` to GTK apps as the titlebar colour, and System Settings' preview showed a grey titlebar. | low | fixed 14eecfd |
| Colour scheme | No `[Colors:Header]`. KDE falls back to Window, which is what Sweet wants. | – | OK |
| Plasma theme | Links and active text were #8500f7: 2.8:1 on #161925, 2.6:1 on the tooltip. Button still had Breeze blues, and visited links were grey. | high | fixed 67b4eb9: #00c1e4 (8.1:1), #7cb7ff (8.4:1), #c74ded (4.8:1). #8500f7 stays as the selection colour (white on it is 6.3:1) |
| Plasma theme | Header, Tooltip and alternate backgrounds were neutral greys (#242424, #212121, #474747, #373737) from another theme. | low | fixed d7b6842: the colour scheme's navy values |
| Decoration | Both aurorae themes ask for a white text shadow under the title. | – | OK: Plasma 6 doesn't draw it (checked in the live session) |

## 4. Left open

- The Plasma theme's negative/neutral/positive colours are Breeze's
  (#da4453, #f67400, #27ae60), and in Complementary and Header those of
  another theme (#ed1515, #c9ce3b, #11d116). The colour scheme uses Sweet's
  #ed254e, #ff6a00, #71f79f.
- The Plasma theme's SVGs (`widgets/`, `dialogs/`) haven't been audited.
- Widget style: Kvantum (`kvantum-dark` with the Sweet Kvantum theme) has
  its own palette, which lives in the Sweet-kvantum repository.

## 5. Re-running the audit

1. Print the colour roles of `color-schemes/Sweet.colors` and
   `plasma/desktoptheme/Sweet/colors` with KColorScheme. Look for Breeze
   colours (#3daee9, #2980b9, #1d99f3, #2a2e32) and for greys.
2. Check the text colours' contrast against their backgrounds.
3. Render Plasma headless with the repository's files in a private HOME and
   `QT_QPA_PLATFORMTHEME=kde`, and compare with the previous commit.
4. In a real session, check `QT_QPA_PLATFORMTHEME` in plasmashell's
   environment: anything but `kde` (or unset) bypasses the colour scheme.
