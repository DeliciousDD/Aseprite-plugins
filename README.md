# Aseprite Plugins

一组用于 [Aseprite](https://www.aseprite.org/) 的小型实用插件。

## 插件目录

| 插件 | 说明 | 安装包 |
| --- | --- | --- |
| [Alpha 不透明](pixel-alpha-opaque/README.md) | 将当前普通图层中所有半透明像素设为完全不透明。 | `pixel-alpha-opaque.aseprite-extension` |

## 安装

从本仓库的 [Releases](../../releases) 下载 `.aseprite-extension` 文件，然后在 Aseprite 中选择 `编辑 → 首选项 → 扩展 → 添加扩展`。安装后如未立即显示命令，请重启 Aseprite。

## 开发与打包

每个插件放在独立目录中，并以该目录内的 `package.json` 作为扩展清单。发布前将扩展目录的内容压缩为 ZIP，并将扩展名改为 `.aseprite-extension`；压缩包根目录必须直接包含 `package.json`。

发布版本与各插件的改动记录见 [CHANGELOG.md](CHANGELOG.md)。
