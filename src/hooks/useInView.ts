import { useEffect, useRef, useState } from 'react'

type Options = {
  once?: boolean
  rootMargin?: string
  threshold?: number
}

export function useInView<T extends Element>({ once = false, rootMargin = '0px', threshold = 0 }: Options = {}) {
  const ref = useRef<T>(null)
  const [inView, setInView] = useState(() => typeof IntersectionObserver === 'undefined')

  useEffect(() => {
    const node = ref.current
    if (!node || typeof IntersectionObserver === 'undefined') return

    const observer = new IntersectionObserver(
      ([entry]) => {
        setInView(entry.isIntersecting)
        if (entry.isIntersecting && once) observer.disconnect()
      },
      { rootMargin, threshold },
    )
    observer.observe(node)
    return () => observer.disconnect()
  }, [once, rootMargin, threshold])

  return [ref, inView] as const
}
