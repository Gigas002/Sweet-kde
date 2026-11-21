# Audit

An audit of the Sweet Plasma 6 theme's colours (2026-11-21), after a report
that "half of the colours don't work, sometimes text is black-on-black". It
has two parts:

- §2 the black-on-black text, which came from the session, not the theme;
- §3 the colour scheme and the Plasma theme's palette;
- §4 the Plasma theme's SVGs, the window decoration and the global theme's QML.

§5 lists what was left open, and §6 is the checklist to re-run the audit.

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
  `spectacle`; the network, Bluetooth, clipboard and volume applets were
  opened with `plasmawindowed`, the splash with `ksplashqml --test`, the
  logout screen with `ksmserver-logout-greeter`, and the volume OSD over
  D-Bus. The old and new trees were compared pixel by pixel.
- **SVGs.** Every SVG in the Plasma theme was parsed, its element IDs
  compared with Plasma's stock theme, and its hardcoded colours traced to
  the elements that draw them.
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
| Plasma theme | Negative/neutral/positive were Breeze's #da4453, #f67400, #27ae60, and in Complementary and Header another theme's #ed1515, #c9ce3b, #11d116. | low | fixed da2a8a5: the colour scheme's #ed254e, #ff6a00, #71f79f |
| Decoration | Both aurorae themes ask for a white text shadow under the title. | – | OK: Plasma 6 doesn't draw it (checked in the live session) |

## 4. SVGs, decoration and global theme

| Area | Finding | Severity | Status |
| --- | --- | --- | --- |
| Plasma theme | `widgets/button.svgz`, `switch.svgz` and `viewitem.svgz` were gzipped twice (since 02b00ad), so Plasma couldn't parse them: no Sweet buttons, switches or list highlights. In the network applet the off switch had no track, only a white knob. | high | fixed ba6a5cc |
| Plasma theme | Breeze blue (#3daee6, #3daee9, #3498db) in `lineedit`, `switch` and `slider`. | – | OK: only in Inkscape's unused `color` property or at opacity 0; the fills are Sweet's |
| Plasma theme | Elements the stock theme has and Sweet lacks: shadows, hints, `north-*` task frames, `normal-*` list items, `focusframe-*`. | – | OK: shadows and hints are optional; Plasma falls back from `north-*` to the unprefixed frames and from `focusframe` to `focus`; no `normal` item background is meant to be transparent |
| Decoration | Sweet and Sweet-transparent aurorae themes. | – | OK: titlebar and buttons draw in every render |
| Global theme | Splash, logout screen, OSD: QML uses Plasma 6 imports. | – | OK: all three render, no QML errors |

## 5. Left open

- The global theme has no lock screen; Plasma uses Breeze's, which follows
  the colour scheme.
- Widget style: Kvantum (`kvantum-dark` with the Sweet Kvantum theme) has
  its own palette, which lives in the Sweet-kvantum repository.

## 6. Re-running the audit

1. Print the colour roles of `color-schemes/Sweet.colors` and
   `plasma/desktoptheme/Sweet/colors` with KColorScheme. Look for Breeze
   colours (#3daee9, #2980b9, #1d99f3, #2a2e32) and for greys.
2. Check the text colours' contrast against their backgrounds.
3. Render Plasma headless with the repository's files in a private HOME and
   `QT_QPA_PLATFORMTHEME=kde`, and compare with the previous commit.
4. Check that every `.svgz` is gzipped once: `zcat FILE | head -c 5` must
   print `<?xml` or `<svg`.
5. In a real session, check `QT_QPA_PLATFORMTHEME` in plasmashell's
   environment: anything but `kde` (or unset) bypasses the colour scheme.
