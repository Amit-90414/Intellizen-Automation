export const categories = {
  'machines-robotics': 'Machines & Robotics',
  'plc-electrical': 'PLC & Electrical',
  'inspection-sensing': 'Inspection & Sensing',
  'material-handling': 'Handling & Labelling',
  'safety-controls': 'Safety & Controls',
  'components': 'Conveyor',
  'software': 'Industrial Software',
} as const

export type Category = keyof typeof categories

export const categoryKeys = Object.keys(categories) as Category[]

export const isCategory = (value: string | null): value is Category =>
  value !== null && Object.hasOwn(categories, value)
