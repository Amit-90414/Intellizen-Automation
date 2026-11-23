import { useRef, useState, type ReactNode } from 'react'
import { motion, useReducedMotion, type Variants } from 'motion/react'
import { useViewSide } from '../../../hooks/useViewSide'
import { isFirstRender } from '../../../utils/firstRender'

type RevealProps = {
  children: ReactNode
  className?: string
  delay?: number
  as?: 'div' | 'li'
  effect?: 'rise' | 'zoom'
}

const ease = [0.2, 0.7, 0.2, 1] as const

export function Reveal({ children, className, delay = 0, as = 'div', effect = 'rise' }: RevealProps) {
  const reduce = useReducedMotion()
  const ref = useRef<HTMLDivElement & HTMLLIElement>(null)
  const [first] = useState(isFirstRender)
  const side = useViewSide(ref)
  const distance = reduce ? 0 : effect === 'zoom' ? 32 : 40
  const scale = reduce || effect === 'rise' ? 1 : 0.92

  const variants: Variants = {
    below: { opacity: 0, y: distance, scale },
    above: { opacity: 0, y: -distance, scale },
    shown: { opacity: 1, y: 0, scale: 1, transition: { duration: effect === 'zoom' ? 0.8 : 0.6, delay, ease } },
  }

  const motionProps = {
    ref,
    className,
    variants,
    initial: first ? false : 'below',
    animate: side,
    transition: { duration: 0.35, ease },
  }

  if (as === 'li') return <motion.li {...motionProps}>{children}</motion.li>
  return <motion.div {...motionProps}>{children}</motion.div>
}
