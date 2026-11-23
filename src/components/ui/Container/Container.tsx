import type { ElementType, ReactNode } from 'react'
import { cx } from '../../../utils/cx'
import styles from './Container.module.css'

type ContainerProps = {
  children: ReactNode
  className?: string
  as?: ElementType
}

export function Container({ children, className, as: Tag = 'div' }: ContainerProps) {
  return <Tag className={cx(styles.container, className)}>{children}</Tag>
}
