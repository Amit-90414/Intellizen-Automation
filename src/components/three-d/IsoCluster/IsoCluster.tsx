import { cx } from '../../../utils/cx'
import { MiniCube } from '../MiniCube/MiniCube'
import styles from './IsoCluster.module.css'

export function IsoCluster({ className }: { className?: string }) {
  return (
    <div className={cx(styles.cluster, className)} aria-hidden="true">
      <span className={styles.ring} />
      <MiniCube size={64} tone="yellow" className={styles.big} />
      <MiniCube size={40} tone="blue" delay={-2.6} className={styles.mid} />
      <MiniCube size={26} tone="yellow" delay={-5.3} className={styles.small} />
    </div>
  )
}
