import { MiniCube } from '../../three-d/MiniCube/MiniCube'
import styles from './AdvantageCard.module.css'

type AdvantageCardProps = {
  title: string
  index: number
  text?: string
}

export function AdvantageCard({ title, index, text }: AdvantageCardProps) {
  return (
    <div className={styles.card}>
      <span className={styles.cube}>
        <MiniCube size={34} tone={index % 2 === 0 ? 'yellow' : 'blue'} delay={index * -1.6} />
      </span>
      <div className={styles.body}>
        <h3 className={styles.title}>{title}</h3>
        {text && <p className={styles.text}>{text}</p>}
      </div>
    </div>
  )
}
