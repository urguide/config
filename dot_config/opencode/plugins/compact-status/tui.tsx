import { Plugin } from "@opencode/plugin/tui"
import { createMemo } from "solid-js"
import { contextUsage } from "./usage"

const number = new Intl.NumberFormat("en-US", {
  notation: "compact",
  maximumFractionDigits: 1,
})
const money = new Intl.NumberFormat("en-US", {
  style: "currency",
  currency: "USD",
  minimumFractionDigits: 2,
  maximumFractionDigits: 2,
})

export default Plugin.define({
  id: "local.compact-status",
  setup(context) {
    return context.ui.slot({
      append: "session.composer.top",
      render(props) {
        const session = createMemo(() => context.data.session.get(props.sessionID))
        const usage = createMemo(() =>
          contextUsage(
            context.data.session.message.list(props.sessionID),
            context.data.location.model.list(session()?.location ?? context.location),
            session()?.revert?.messageID,
          ),
        )
        const title = createMemo(() => (session()?.title || "新對話").replace(/\s+/g, " "))
        const status = createMemo(() => {
          const current = usage()
          const tokens = current ? number.format(current.tokens) : "—"
          const percent = current?.percent === undefined ? "—" : `${current.percent}%`
          const cost = context.data.session.cost(props.sessionID)
          return `Tokens: ${tokens} │ Context: ${percent}${cost > 0 ? ` │ ${money.format(cost)}` : ""}`
        })

        return (
          <box
            id="compact-status"
            height={1}
            flexShrink={0}
            flexDirection="row"
            gap={1}
            overflow="hidden"
          >
            <text
              width={0}
              minWidth={0}
              flexGrow={1}
              height={1}
              wrapMode="none"
              truncate
              fg={context.theme.text.base}
            >
              {title()}
            </text>
            <text height={1} flexShrink={0} wrapMode="none" fg={context.theme.text.muted}>
              {status()}
            </text>
          </box>
        )
      },
    })
  },
})
