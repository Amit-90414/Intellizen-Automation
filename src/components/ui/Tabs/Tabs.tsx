import { useId, useRef, useState, type KeyboardEvent, type ReactNode } from 'react'
import { AnimatePresence, motion } from 'motion/react'
import styles from './Tabs.module.css'

export type TabItem = { id: string; label: string; content: ReactNode }

type TabsProps = {
  items: TabItem[]
  label: string
}

export function Tabs({ items, label }: TabsProps) {
  const baseId = useId()
  const [active, setActive] = useState(0)
  const tabRefs = useRef<Array<HTMLButtonElement | null>>([])
  const current = items[active]

  const select = (index: number) => {
    setActive(index)
    const tab = tabRefs.current[index]
    tab?.focus()
    tab?.scrollIntoView({ block: 'nearest', inline: 'nearest' })
  }

  const onKeyDown = (event: KeyboardEvent<HTMLDivElement>) => {
    const last = items.length - 1
    let next: number
    switch (event.key) {
      case 'ArrowRight':
        next = active === last ? 0 : active + 1
        break
      case 'ArrowLeft':
        next = active === 0 ? last : active - 1
        break
      case 'Home':
        next = 0
        break
      case 'End':
        next = last
        break
      default:
        return
    }
    event.preventDefault()
    select(next)
  }

  return (
    <div className={styles.tabs}>
      <div role="tablist" aria-label={label} className={styles.list} onKeyDown={onKeyDown}>
        {items.map((item, i) => (
          <button
            key={item.id}
            ref={(el) => {
              tabRefs.current[i] = el
            }}
            type="button"
            role="tab"
            id={`${baseId}-tab-${item.id}`}
            aria-selected={i === active}
            aria-controls={`${baseId}-panel-${item.id}`}
            tabIndex={i === active ? 0 : -1}
            className={styles.tab}
            onClick={() => select(i)}
          >
            {item.label}
          </button>
        ))}
      </div>

      <div className={styles.panels}>
        <AnimatePresence mode="wait" initial={false}>
          <motion.div
            key={current.id}
            role="tabpanel"
            id={`${baseId}-panel-${current.id}`}
            aria-labelledby={`${baseId}-tab-${current.id}`}
            tabIndex={0}
            className={styles.panel}
            initial={{ opacity: 0, x: 8 }}
            animate={{ opacity: 1, x: 0 }}
            exit={{ opacity: 0, x: -8 }}
            transition={{ duration: 0.2, ease: [0.2, 0.7, 0.2, 1] }}
          >
            {current.content}
          </motion.div>
        </AnimatePresence>
      </div>
    </div>
  )
}
