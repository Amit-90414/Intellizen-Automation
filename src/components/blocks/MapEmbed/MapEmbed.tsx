import { mapEmbedUrl } from '../../../data/site'
import { cx } from '../../../utils/cx'
import styles from './MapEmbed.module.css'

type MapEmbedProps = {
  height?: number
  title?: string
  className?: string
}

export function MapEmbed({ height = 260, title = 'Intellizen location map', className }: MapEmbedProps) {
  return (
    <div className={cx(styles.map, className)} style={{ height }}>
      <iframe src={mapEmbedUrl} title={title} loading="lazy" referrerPolicy="no-referrer-when-downgrade" allowFullScreen />
    </div>
  )
}
