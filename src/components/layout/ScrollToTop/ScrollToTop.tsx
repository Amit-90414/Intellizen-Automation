import { useLayoutEffect } from 'react'
import { useLocation } from 'react-router'

export function ScrollToTop() {
  const { hash } = useLocation()

  useLayoutEffect(() => {
    if ('scrollRestoration' in window.history) window.history.scrollRestoration = 'manual'
    const target = hash ? document.getElementById(decodeURIComponent(hash.slice(1))) : null
    if (target) {
      target.scrollIntoView()
      return
    }
    window.scrollTo({ top: 0, left: 0, behavior: 'instant' })
  }, [hash])

  return null
}
