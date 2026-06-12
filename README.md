# homebrew-software

Personal Homebrew tap for macOS casks maintained by [chanochli](https://github.com/chanochli).

个人 Homebrew tap，用于分发和维护 macOS 应用（Cask）。

## Install / 安装

```bash
brew tap chanochli/software
```

## Available Casks / 可用软件

| Cask | Type | Description |
|------|------|-------------|
| `next-ai-draw-io` | Auto-update | AI-assisted draw.io diagramming (GitHub Releases) |
| `textsniper-old` | Pinned | TextSniper 1.10.1 — intentionally locked legacy version |

```bash
brew install --cask next-ai-draw-io
brew install --cask textsniper-old
```

## Cask Types / 两类维护模式

| | **Pinned** 固定版本 | **Auto-update** 自动更新 |
|---|---|---|
| **Version source** | Hardcoded in cask | GitHub Releases API + CI bump |
| **Bump** | Manual | Scheduled GitHub Actions |
| **Example** | `textsniper-old` | `next-ai-draw-io` |

## Adding Software / 添加新软件

See [docs/ADDING_SOFTWARE.md](docs/ADDING_SOFTWARE.md) for the full guide, conventions, and templates.

添加新软件请参阅 [docs/ADDING_SOFTWARE.md](docs/ADDING_SOFTWARE.md)，其中包含规范、检查清单和模版文件。

Templates live in [`templates/`](templates/):

- `Cask.pinned.rb.template` — pinned version cask
- `Cask.github-release.rb.template` — GitHub Release auto-update cask
- `bump-github-release.sh.template` — bump script
- `workflow-bump.yml.template` — GitHub Actions workflow

## License

MIT — see [LICENSE](LICENSE).
