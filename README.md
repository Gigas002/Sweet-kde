# Sweet-kde

A dark and modern theme for KDE Plasma 6, fork of [Sweet](https://github.com/EliverLara/Sweet/tree/nova/kde).

> This theme is based on the awesome [Helium](https://store.kde.org/p/998869/) theme

![Sweet preview](plasma/desktoptheme/Sweet/preview/preview.png)

## Contents

- `plasma/look-and-feel/Sweet`: the global theme, with its splash screen, logout screen and OSD; it selects all the parts below
- `plasma/desktoptheme/Sweet`: the Plasma style (panel, menus, widgets)
- `color-schemes/Sweet.colors`: the colors
- `aurorae/themes/Sweet` and `Sweet-transparent`: window decorations

The global theme also selects parts kept in other repositories; install them too, or Plasma falls back to its own:

- [Sweet-kvantum](https://github.com/Gigas002/Sweet-kvantum), the application style, through Kvantum
- [Sweet-cursors](https://github.com/Gigas002/Sweet-cursors)
- [candy-icons](https://github.com/EliverLara/candy-icons)

## Install

On Arch Linux, the AUR package `sweet-kde-theme-git` installs it to `/usr/share`.

Otherwise, for one user:

```sh
d=~/.local/share
mkdir -p $d/plasma/desktoptheme $d/plasma/look-and-feel $d/color-schemes $d/aurorae/themes
cp -r plasma/desktoptheme/Sweet $d/plasma/desktoptheme/
cp -r plasma/look-and-feel/Sweet $d/plasma/look-and-feel/
cp color-schemes/Sweet.colors $d/color-schemes/
cp -r aurorae/themes/* $d/aurorae/themes/
```

Then choose Sweet in System Settings -> Colors & Themes -> Global Theme, or:

```sh
plasma-apply-lookandfeel -a Sweet
```
