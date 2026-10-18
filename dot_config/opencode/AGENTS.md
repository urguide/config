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

## Git commit / push

- 使用者要求 commit,或 commit + push 時,直接在該 repo 執行:

  ```
  /usr/local/bin/gpp
  ```

- `gpp` 已封裝 add、commit、push 全流程。
- 不要自行拆成 `git add` / `git commit` / `git push`。
- 不要預先讀取或分析 `gpp` 腳本內容。
- 只有 `gpp` 執行出錯時,才進一步調查原因。
