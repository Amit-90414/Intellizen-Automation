import type { ReactElement } from 'react'
import type { IconKey } from '../../../data/products'

const shapes: Record<IconKey, ReactElement> = {
  robotics: (
    <>
      <path d="M4 21h9" />
      <path d="M8.5 21v-3.5" />
      <circle cx="8.5" cy="15" r="2.4" />
      <path d="M10.3 13.4 14.2 9" />
      <circle cx="15.4" cy="7.8" r="1.8" />
      <path d="M17 8.6l2.6 2.2" />
      <path d="M19.4 10.6l1.6-.9M19.6 10.8l.4 1.8" />
    </>
  ),
  spm: (
    <>
      <rect x="3" y="3.5" width="18" height="13" rx="1.5" />
      <path d="M3 12.5h18" />
      <path d="M12 3.5v4" />
      <rect x="9.5" y="7.5" width="5" height="3" rx=".6" />
      <path d="M6.5 16.5v4M17.5 16.5v4M4.5 20.5h15" />
    </>
  ),
  vision: (
    <>
      <rect x="2.5" y="7" width="13" height="10" rx="1.6" />
      <path d="M15.5 10.2 21 8v8l-5.5-2.2" />
      <circle cx="9" cy="12" r="2.6" />
    </>
  ),
  conveyor: (
    <>
      <rect x="2.5" y="14.5" width="19" height="4.5" rx="2.25" />
      <circle cx="6" cy="16.75" r=".9" />
      <circle cx="12" cy="16.75" r=".9" />
      <circle cx="18" cy="16.75" r=".9" />
      <rect x="5.5" y="7.5" width="5.5" height="5.5" rx=".6" />
      <rect x="13" y="9" width="4.5" height="4" rx=".6" />
    </>
  ),
  sensor: (
    <>
      <rect x="2.5" y="10" width="9" height="4" rx="1" />
      <path d="M11.5 11h2.2v2h-2.2" />
      <path d="M16.6 8.3a5.2 5.2 0 0 1 0 7.4" />
      <path d="M19.4 5.6a9 9 0 0 1 0 12.8" />
    </>
  ),
  components: (
    <>
      <circle cx="12" cy="12" r="3" />
      <circle cx="12" cy="12" r="6.6" />
      <path d="M12 2.6v2.8M12 18.6v2.8M2.6 12h2.8M18.6 12h2.8M5.4 5.4l2 2M16.6 16.6l2 2M5.4 18.6l2-2M16.6 7.4l2-2" />
    </>
  ),
  safety: (
    <>
      <path d="M12 2.8 19.5 6v5.4c0 4.6-3.1 8.4-7.5 9.9-4.4-1.5-7.5-5.3-7.5-9.9V6z" />
      <path d="M8.8 12.1l2.2 2.2 4.3-4.4" />
    </>
  ),
  controls: (
    <>
      <rect x="8.5" y="2.5" width="7" height="12.5" rx="1.2" />
      <path d="M8.5 6.7h7M8.5 10.8h7" />
      <path d="M12 15v3.5" />
      <path d="M6.5 21.2h11" />
    </>
  ),
  custom: (
    <>
      <path d="M12 2.8l4.2 2.4v4.8L12 12.4 7.8 10V5.2z" />
      <path d="M7.8 12.2l4.2 2.4v4.8l-4.2 2.4-4.2-2.4v-4.8z" />
      <path d="M16.2 12.2l4.2 2.4v4.8l-4.2 2.4-4.2-2.4v-4.8z" />
    </>
  ),
  plc: (
    <>
      <rect x="2.5" y="5" width="19" height="14" rx="1.5" />
      <path d="M9 5v14M13 5v14M17 5v14" />
      <path d="M5 8.5h1.6M5 11h1.6" />
      <circle cx="11" cy="8.5" r=".5" />
      <circle cx="15" cy="8.5" r=".5" />
      <circle cx="19.2" cy="8.5" r=".5" />
      <path d="M2.5 15.5h19" />
    </>
  ),
  scada: (
    <>
      <rect x="2.5" y="3.5" width="19" height="13" rx="1.5" />
      <path d="M8.5 20.5h7M12 16.5v4" />
      <path d="M5.5 13l3.5-3.5 2.8 2.3 4.7-4.8" />
      <circle cx="18.5" cy="6.5" r=".6" />
    </>
  ),
  drive: (
    <>
      <rect x="3" y="7" width="11.5" height="10" rx="2" />
      <path d="M14.5 12h3M17.5 10v4h3v-4z" />
      <path d="M6.5 7V5h4.5v2" />
      <path d="M6.5 10.5v3M9 10.5v3M11.5 10.5v3" />
      <path d="M4.5 17v2.5M13 17v2.5M3 19.5h12" />
    </>
  ),
  panel: (
    <>
      <rect x="4" y="2.5" width="16" height="17" rx="1.2" />
      <path d="M12 2.5v17M6 21.5v-2M18 21.5v-2" />
      <circle cx="8" cy="7" r="1.1" />
      <circle cx="8" cy="10.5" r="1.1" />
      <path d="M16.2 6l-1.8 3.4h2.4l-1.8 3.4" />
      <path d="M14.5 15.5h3" />
    </>
  ),
  printer: (
    <>
      <path d="M6.5 9V3.5h11V9" />
      <rect x="3" y="9" width="18" height="7.5" rx="1.5" />
      <path d="M7 14h10v7H7z" />
      <path d="M9 16.2v3M10.8 16.2v3M13 16.2v3M15 16.2v3" />
      <circle cx="17.5" cy="11.8" r=".6" />
    </>
  ),
  labeller: (
    <>
      <path d="M8 2.5h3v2.5l1.3 2.2V21H6.7V7.2L8 5z" />
      <path d="M6.7 11h5.6v5H6.7z" />
      <circle cx="18" cy="8" r="3.5" />
      <circle cx="18" cy="8" r="1" />
      <path d="M14.5 8.5l-2 3" />
      <path d="M3 21h18" />
    </>
  ),
  testbench: (
    <>
      <path d="M2.5 13.5h19" />
      <path d="M4.5 13.5V21M19.5 13.5V21" />
      <circle cx="12" cy="7" r="4.5" />
      <path d="M12 7l2.4-2" />
      <path d="M9.2 9.6h5.6" />
    </>
  ),
  retrofit: (
    <>
      <path d="M14.4 3.6a4.2 4.2 0 0 0-5.3 5.3l-6 6a1.6 1.6 0 0 0 2.3 2.3l6-6a4.2 4.2 0 0 0 5.3-5.3l-2.5 2.5-2.1-.4-.4-2.1z" />
      <path d="M18.5 21v-6.5M16 17l2.5-2.5L21 17" />
    </>
  ),
  chain: (
    <>
      <rect x="2.5" y="9" width="9" height="6" rx="3" />
      <rect x="8.5" y="9" width="9" height="6" rx="3" />
      <path d="M20.5 5.5l-1.5 13" />
    </>
  ),
  warehouse: (
    <>
      <path d="M3 21V9l9-5 9 5v12" />
      <path d="M7 21v-8h10v8" />
      <path d="M7 17h10" />
      <path d="M10.5 13v4M13.5 17v4" />
    </>
  ),
  tracking: (
    <>
      <path d="M3 3.5v8M5.4 3.5v8M7.6 3.5v8M10 3.5v8" />
      <path d="M17.5 21s4-4.1 4-7.3a4 4 0 0 0-8 0c0 3.2 4 7.3 4 7.3z" />
      <circle cx="17.5" cy="13.6" r="1.3" />
      <path d="M3 15.5h3M8 15.5h3" />
    </>
  ),
  asset: (
    <>
      <path d="M3 11.5v-7A1.5 1.5 0 0 1 4.5 3h7l9.2 9.2a1.6 1.6 0 0 1 0 2.3l-6.2 6.2a1.6 1.6 0 0 1-2.3 0z" />
      <circle cx="7.5" cy="7.5" r="1.4" />
      <path d="M10.6 13.4l3 3M12.6 11.4l3 3" />
    </>
  ),
  recipe: (
    <>
      <rect x="5" y="4" width="14" height="17" rx="1.5" />
      <path d="M9 4V2.8h6V4" />
      <path d="M8.5 10h7M8.5 14h7M8.5 18h4" />
      <circle cx="11" cy="10" r="1" />
      <circle cx="14" cy="14" r="1" />
    </>
  ),
  weighing: (
    <>
      <rect x="3" y="16" width="18" height="4.5" rx="1.2" />
      <path d="M7 16v-2h10v2" />
      <path d="M8.5 5.5h7l1.2 8.5H7.3z" />
      <path d="M10.5 5.5a1.5 1.5 0 0 1 3 0" />
    </>
  ),
}

type ProductIconProps = {
  name: IconKey
  size?: number
  className?: string
}

export function ProductIcon({ name, size = 24, className }: ProductIconProps) {
  return (
    <svg
      viewBox="0 0 24 24"
      width={size}
      height={size}
      fill="none"
      stroke="currentColor"
      strokeWidth={1.7}
      strokeLinecap="round"
      strokeLinejoin="round"
      aria-hidden="true"
      focusable="false"
      className={className}
    >
      {shapes[name]}
    </svg>
  )
}
