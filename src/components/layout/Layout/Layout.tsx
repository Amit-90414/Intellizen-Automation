import type { ReactNode } from 'react'
import { useKeyboardOpen } from '../../../hooks/useKeyboardOpen'
import { Footer } from '../Footer/Footer'
import { Header } from '../Header/Header'
import { SkipLink } from '../SkipLink/SkipLink'
import styles from './Layout.module.css'

export function Layout({ children }: { children: ReactNode }) {
  useKeyboardOpen()

  return (
    <div className={styles.shell}>
      <SkipLink />
      <Header />
      <main id="main" tabIndex={-1} className={styles.main}>
        {children}
      </main>
      <Footer />
    </div>
  )
}
