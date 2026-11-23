import type { CSSProperties, ReactNode } from 'react'

export type Faces = { top: string; sideY: string; sideX: string }

type CuboidProps = {
  x: number
  y: number
  w: number
  d: number
  h: number
  z?: number
  c: Faces
  className?: string
  style?: CSSProperties
  faceStyle?: CSSProperties
  faceClassName?: string
  topClassName?: string
  children?: ReactNode
}

export function Cuboid({ x, y, w, d, h, z = 0, c, className, style, faceStyle, faceClassName, topClassName, children }: CuboidProps) {
  const f = (s: CSSProperties): CSSProperties => ({
    position: 'absolute',
    backfaceVisibility: 'hidden',
    WebkitBackfaceVisibility: 'hidden',
    ...faceStyle,
    ...s,
  })

  return (
    <div
      className={className}
      style={{
        position: 'absolute',
        left: x,
        top: y,
        width: w,
        height: d,
        transformStyle: 'preserve-3d',
        transform: `translateZ(${z + h / 2}px)`,
        ...style,
      }}
    >
      <div
        className={topClassName ?? faceClassName}
        style={f({ left: 0, top: 0, width: w, height: d, transform: `translateZ(${h / 2}px)`, background: c.top })}
      />
      <div
        className={faceClassName}
        style={f({ left: 0, top: (d - h) / 2, width: w, height: h, transform: `rotateX(90deg) translateZ(${d / 2}px)`, background: c.sideY })}
      />
      <div
        className={faceClassName}
        style={f({ left: 0, top: (d - h) / 2, width: w, height: h, transform: `rotateX(-90deg) translateZ(${d / 2}px)`, background: c.sideY })}
      />
      <div
        className={faceClassName}
        style={f({ left: (w - h) / 2, top: 0, width: h, height: d, transform: `rotateY(90deg) translateZ(${w / 2}px)`, background: c.sideX })}
      />
      <div
        className={faceClassName}
        style={f({ left: (w - h) / 2, top: 0, width: h, height: d, transform: `rotateY(-90deg) translateZ(${w / 2}px)`, background: c.sideX })}
      />
      {children}
    </div>
  )
}
