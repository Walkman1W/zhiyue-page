# 🎮 游戏自动部署指南

## 项目结构

```
/root/.openclaw/workspace-zhiyue-bot/zhiyue-games/
├── index.html           # 游戏大厅首页（展示所有游戏卡片）
├── deploy.sh            # 一键部署脚本
├── games/               # 所有游戏目录
│   ├── demo-game/
│   │   └── index.html
│   └── <game-name>/
│       └── index.html   # 每个游戏必须有 index.html
└── README.md
```

## 添加新游戏的步骤

### 1. 创建游戏文件
在 `games/<游戏名>/` 目录下创建 `index.html`

### 2. 更新首页
在 `index.html` 的 `<div class="games">` 中添加游戏卡片：
```html
<a class="game-card" href="./games/<游戏名>/">
    <div class="thumb">🎮</div>
    <div class="info">
        <h3>游戏名</h3>
        <p>游戏简介</p>
    </div>
</a>
```

### 3. 部署
```bash
cd /root/.openclaw/workspace-zhiyue-bot/zhiyue-games && ./deploy.sh <游戏名>
```

## 部署流程

1. `git add -A` → 暂存所有变更
2. `git commit` → 提交到本地仓库
3. `git push` → 推送到 GitHub（版本管理）
4. `wrangler pages deploy` → 部署到 Cloudflare Pages

## 访问地址

- Cloudflare Pages: https://zhiyue-games.pages.dev
- 单个游戏: https://zhiyue-games.pages.dev/games/<游戏名>/

## 注意事项

- 每个游戏必须是纯静态（HTML + CSS + JS），不能有后端
- 游戏文件夹名用英文小写+连字符（如 `snake-game`）
- 单个文件建议不超过 1MB
- 部署后大约 1-2 分钟生效
