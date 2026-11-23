import { useEffect, useState, type CSSProperties } from 'react'
import { Link } from 'react-router'
import { copy, sceneStations } from '../../../data/site'
import { useInView } from '../../../hooks/useInView'
import { cx } from '../../../utils/cx'
import { Cuboid, type Faces } from '../Cuboid/Cuboid'
import styles from './IsometricLine.module.css'

const grid = 'rgba(0, 48, 136, .09)'

const platform: Faces = {
  top: `linear-gradient(${grid} 1px, transparent 1px) 0 0 / 40px 40px, linear-gradient(90deg, ${grid} 1px, transparent 1px) 0 0 / 40px 40px, #FFFFFF`,
  sideY: '#003088',
  sideX: '#002870',
}
const belt: Faces = {
  top: 'repeating-linear-gradient(90deg, #26314D 0 18px, #3A4770 18px 36px)',
  sideY: '#9AABC7',
  sideX: '#6B7C99',
}
const carton: Faces = {
  top: 'linear-gradient(90deg, transparent 18px, #E0A100 18px 26px, transparent 26px), #FFD24D',
  sideY: '#F6B400',
  sideX: '#D99A00',
}
const steel: Faces = { top: '#D6DFEE', sideY: '#B8C6DD', sideX: '#93A4C3' }
const blue: Faces = { top: '#1A4FB0', sideY: '#002870', sideX: '#0A3A8F' }
const yellow: Faces = { top: '#FFD24D', sideY: '#F6B400', sideX: '#D99A00' }
const gripper: Faces = { top: '#8FA0BD', sideY: '#4A5A72', sideX: '#3A4A62' }
const glass: Faces = { top: 'rgba(0, 88, 192, .2)', sideY: 'rgba(0, 88, 192, .14)', sideX: 'rgba(0, 88, 192, .14)' }
const post: Faces = { top: '#4A5A72', sideY: '#4A5A72', sideX: '#3A4A62' }
const green: Faces = { top: '#22C55E', sideY: '#22C55E', sideX: '#22C55E' }
const amber: Faces = { top: '#C99300', sideY: '#A87B00', sideX: '#8A6500' }
const red: Faces = { top: '#A31E17', sideY: '#8A1912', sideX: '#70140E' }

const boxes = [
  { delay: 0, still: 60 },
  { delay: -3.5, still: 250 },
  { delay: -7, still: 470 },
  { delay: -10.5, still: 650 },
]

const glassFace: CSSProperties = { border: '2px solid #0058C0', boxSizing: 'border-box' }

function useTabVisible() {
  const [visible, setVisible] = useState(() => document.visibilityState !== 'hidden')
  useEffect(() => {
    const update = () => setVisible(document.visibilityState !== 'hidden')
    document.addEventListener('visibilitychange', update)
    return () => document.removeEventListener('visibilitychange', update)
  }, [])
  return visible
}

export function IsometricLine() {
  const [stageRef, inView] = useInView<HTMLDivElement>({ rootMargin: '60px' })
  const tabVisible = useTabVisible()
  const paused = !inView || !tabVisible

  return (
    <div ref={stageRef} className={cx(styles.stage, paused && styles.paused)}>
      <div className={styles.shadow} aria-hidden="true" />

      <div className={styles.scaler} role="img" aria-label={copy.home.sceneLabel}>
        <div className={styles.floor}>
          <Cuboid x={0} y={0} w={920} d={300} h={20} z={-20} c={platform} />
          <div className={styles.hazard} />

          <Cuboid x={20} y={120} w={880} d={80} h={34} c={belt} topClassName={styles.belt} />

          {boxes.map((box) => (
            <Cuboid
              key={box.delay}
              x={30}
              y={138}
              w={44}
              d={44}
              h={44}
              z={34}
              c={carton}
              className={styles.box}
              style={{ animationDelay: `${box.delay}s`, '--still-x': `${box.still}px` } as CSSProperties}
            />
          ))}

          <Cuboid x={290} y={96} w={14} d={14} h={130} c={steel} />
          <Cuboid x={290} y={210} w={14} d={14} h={130} c={steel} />
          <Cuboid x={290} y={96} w={14} d={128} h={14} z={130} c={steel} />
          <Cuboid x={280} y={143} w={34} d={34} h={28} z={102} c={blue} />
          <div className={styles.scanSpot} />
          <div className={cx(styles.beam, styles.beamX)} />
          <div className={cx(styles.beam, styles.beamY)} />

          <Cuboid x={528} y={24} w={64} d={64} h={28} c={blue} />
          <div className={styles.pivot}>
            <Cuboid x={-12} y={-12} w={24} d={24} h={100} z={28} c={yellow} />
            <Cuboid x={-16} y={-16} w={32} d={32} h={16} z={120} c={blue} />
            <Cuboid x={-10} y={-4} w={20} d={110} h={18} z={124} c={yellow} />
            <Cuboid x={-9} y={92} w={18} d={18} h={40} z={84} c={gripper} />
          </div>

          <Cuboid x={730} y={100} w={100} d={120} h={96} c={glass} faceStyle={glassFace} />
          <Cuboid x={812} y={108} w={6} d={6} h={28} z={96} c={post} />
          <Cuboid x={808} y={104} w={14} d={14} h={14} z={124} c={green} faceClassName={styles.blink} />
          <Cuboid x={808} y={104} w={14} d={14} h={14} z={138} c={amber} />
          <Cuboid x={808} y={104} w={14} d={14} h={14} z={152} c={red} />
        </div>
      </div>

      <nav className={cx(styles.scaler, styles.labelLayer)} aria-label="Production line stations">
        <div className={styles.floor}>
          {sceneStations.map((station) => (
            <Link
              key={station.slug}
              to={`/products/${station.slug}`}
              className={styles.label}
              style={{ left: station.x, top: 238 }}
            >
              <span className={styles.num}>{station.num}</span>
              {station.label}
            </Link>
          ))}
        </div>
      </nav>
    </div>
  )
}
