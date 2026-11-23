import type { ComponentProps, ReactNode } from 'react'
import { Link } from 'react-router'
import { cx } from '../../../utils/cx'
import styles from './Button.module.css'

type Variant = 'primary' | 'secondary' | 'dark' | 'ghost'

type Common = {
  variant?: Variant
  block?: boolean
  className?: string
  children: ReactNode
}

type LinkButton = Common & { to: string; href?: never } & Omit<ComponentProps<typeof Link>, 'to' | 'className' | 'children'>
type AnchorButton = Common & { href: string; to?: never } & Omit<ComponentProps<'a'>, 'href' | 'className' | 'children'>
type NativeButton = Common & { to?: never; href?: never } & Omit<ComponentProps<'button'>, 'className' | 'children'>

export type ButtonProps = LinkButton | AnchorButton | NativeButton

const classes = (variant: Variant = 'primary', block = false, className?: string) =>
  cx(styles.button, styles[variant], block && styles.block, className)

export function Button(props: ButtonProps) {
  if (props.to !== undefined) {
    const { variant, block, className, children, ...rest } = props
    return (
      <Link {...rest} className={classes(variant, block, className)}>
        {children}
      </Link>
    )
  }

  if (props.href !== undefined) {
    const { variant, block, className, children, ...rest } = props
    return (
      <a {...rest} className={classes(variant, block, className)}>
        {children}
      </a>
    )
  }

  const { variant, block, className, children, type = 'button', ...rest } = props
  return (
    <button {...rest} type={type} className={classes(variant, block, className)}>
      {children}
    </button>
  )
}
