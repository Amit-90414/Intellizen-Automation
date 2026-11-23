import { useEffect, useState, type RefObject } from 'react'
import { isFirstRender } from '../utils/firstRender'

export type ViewSide = 'shown' | 'above' | 'below'

const supported = typeof IntersectionObserver !== 'undefined'

export function useViewSide<T extends Element>(ref: RefObject<T | null>, margin = '0px 0px -8% 0px') {
  const [side, setSide] = useState<ViewSide>(() => (supported && !isFirstRender() ? 'below' : 'shown'))

  useEffect(() => {
    const node = ref.current
    if (!node || !supported) return
    let first = true
    const observer = new IntersectionObserver(
      ([entry]) => {
        const box = entry.boundingClientRect
        const onScreen = box.top < window.innerHeight && box.bottom > 0
        if (entry.isIntersecting || (first && onScreen)) setSide('shown')
        else setSide(box.top < (entry.rootBounds?.top ?? 0) ? 'above' : 'below')
        first = false
      },
      { rootMargin: margin },
    )
    observer.observe(node)
    return () => observer.disconnect()
  }, [ref, margin])

  return side
}
