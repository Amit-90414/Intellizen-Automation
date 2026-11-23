import { useEffect } from 'react'

const FIELDS = 'input, textarea, select'

export function useKeyboardOpen() {
  useEffect(() => {
    const viewport = window.visualViewport
    if (!viewport) return
    const root = document.documentElement

    const update = () => {
      const active = document.activeElement
      const typing = active instanceof HTMLElement && active.matches(FIELDS)
      root.toggleAttribute('data-keyboard', typing && viewport.height < window.innerHeight * 0.78)
    }
    const later = () => window.setTimeout(update, 320)

    viewport.addEventListener('resize', update)
    document.addEventListener('focusin', later)
    document.addEventListener('focusout', later)
    return () => {
      viewport.removeEventListener('resize', update)
      document.removeEventListener('focusin', later)
      document.removeEventListener('focusout', later)
      root.removeAttribute('data-keyboard')
    }
  }, [])
}
