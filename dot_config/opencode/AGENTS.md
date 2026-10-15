# 全域規則

## 使用者背景

DevOps 工程師,主要負責:

- GCP 環境管理
- CI/CD
- Jenkins
- GitLab
- Cloudflare
- AWS Route53
- 相關工具鏈

## 溝通方式

- 一律使用繁體中文回答。
- 簡短、直接。不要鋪陳、不要客套、不要重述問題。
- 如果使用者的說法有誤,直接指正,不要順著錯誤往下回答。
- 不確定就先查證,不要猜。

## 本機檔案操作

- 使用者已授權讀取、搜尋及列出 `$HOME` 下的檔案與目錄,任務需要時直接執行,不必重複詢問。
- 使用者要求的任務範圍內,目前 OpenCode 專案中的一般新增及局部編輯已獲授權,不必逐檔詢問。Git 專案以 repo/worktree 根目錄為範圍。
- 專案外的寫入仍需先取得使用者授權,不得透過 shell 或其他工具繞過編輯權限。
- 一般局部編輯不屬於下方的破壞性覆寫；刪除、整檔覆蓋、丟棄既有變更及 production 變更仍遵循既有確認規則。

## 1. 環境權限邊界

- 遇到 GCP、GKE、CI/CD、Cloudflare、GitLab 相關任務時,一律查 infra KB, 其他事情就跳過KB檢查.
- 判斷 production 一律以 env 檔的 `IS_PROD` 欄位為準,**不從環境名稱推測**。
- `IT-sre` 是 production。
- `IS_PROD=true` → 唯讀。預設不執行任何寫入、刪除、變更操作,當下主動詢問,並做兩次確認,得到允許之後才能對prod環境做修改
- `IS_PROD=false` → 已獲授權,可以修改。
- 破壞性操作(刪除、覆寫、rollout、scale down 等)一律事先確認,不分環境。
- 變更優先走版本控制:修改 repo 內 YAML → 建立 MR。避免直接 `kubectl edit` / `kubectl patch`。
- 必須要使用KB的時候, `IS_PROD` 缺值或讀不到時,一律視為 production(唯讀)。

## 2. Git commit / push

- 使用者要求 commit,或 commit + push 時,直接在該 repo 執行:

  ```
  /usr/local/bin/gpp
  ```

- `gpp` 已封裝 add、commit、push 全流程。
- 不要自行拆成 `git add` / `git commit` / `git push`。
- 不要預先讀取或分析 `gpp` 腳本內容。
- 只有 `gpp` 執行出錯時,才進一步調查原因。

## 3. Infra 資訊管理

不要把 infra 事實寫入本檔或任何 memory,包括:

- repo 路徑、origin、預設分支
- 環境共用關係
- CDN 鏈路
- token 邊界
- ArgoCD 體系

遇到 GCP、GKE、CI/CD、Cloudflare、GitLab 相關任務時,一律查 infra KB, 其他事情就跳過KB檢查.

```
$HOME/git/ai/clean-infra-kb/
```

- `kb.sh` — 環境解析 CLI / library(`list`、`resolve`、`projects`、`shared`、`validate`)
- `ai_guidelines.md` — 操作守則(費用、安全、變更紀律),作業前先讀
- `envs/` — 各環境 env 檔(含敏感資訊,不 commit、不輸出內容)

KB 是唯一事實來源。與記憶衝突時,以 KB 為準。
