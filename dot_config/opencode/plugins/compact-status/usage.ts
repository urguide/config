import type { ModelInfo, SessionMessageInfo } from "@opencode/client"

// Match the built-in sidebar: latest measured step after compaction and before undo.
// SessionInfo.tokens is cumulative billing usage, not the current context size.
export function contextUsage(
  messages: readonly SessionMessageInfo[],
  models: readonly ModelInfo[] | undefined,
  revertMessageID?: string,
): { tokens: number; percent?: number } | undefined {
  const boundary = revertMessageID
    ? messages.findIndex((message) => message.id === revertMessageID)
    : messages.length
  if (boundary < 0) return

  for (let index = boundary - 1; index >= 0; index--) {
    const message = messages[index]
    if (message.type === "compaction" && message.status === "completed") return
    if (message.type !== "assistant" || !message.tokens) continue

    const usage = message.tokens
    const tokens = usage.input + usage.output + usage.reasoning + usage.cache.read + usage.cache.write
    if (tokens <= 0) return

    const model = models?.find(
      (model) => model.providerID === message.model.providerID && model.id === message.model.id,
    )
    return {
      tokens,
      percent: model?.limit.context ? Math.round((tokens / model.limit.context) * 100) : undefined,
    }
  }
}
