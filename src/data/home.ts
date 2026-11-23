import { hasItemIcon } from '../components/ui/ItemIcon/icons'
import { productGroups } from './menu'
import { getProduct, products, type Product } from './products'
import { site } from './site'

const product = (slug: string): Product => {
  const found = getProduct(slug)
  if (!found) throw new Error(`Unknown product slug: ${slug}`)
  return found
}

const application = (slug: string, title: string) => {
  const item = product(slug)
  const match = item.applications.find((entry) => entry.title === title)
  if (!match) throw new Error(`Unknown application "${title}" for ${slug}`)
  return { ...match, slug, productName: item.name, icon: item.icon }
}

export const heroVideos = [1, 2, 3, 4, 5].map((n) => ({
  src: `/assets/hero/hero-${n}.mp4`,
  poster: `/assets/hero/hero-${n}.jpg`,
}))

export const homeHero = {
  tags: ['Derabassi, Punjab', 'Industrial automation', 'Design · Build · Support'],
  servicesLabel: 'What we do',
  services: productGroups.map((group) => ({
    key: group.key,
    label: group.label,
    icon: group.icon,
  })),
}

export const applicationsSection = {
  eyebrow: 'Applications',
  title: 'Put repetitive work',
  accent: 'on autopilot.',
  text: 'Pick and place, palletising, machine tending, testing and inspection. These are the jobs where an automated station takes the load off your operators and keeps every part consistent.',
  items: [
    application('industrial-robotics', 'Pick & place'),
    application('industrial-robotics', 'Palletising'),
    application('industrial-robotics', 'Machine tending'),
    application('scada-systems', 'Plant monitoring'),
    application('vision-camera-systems', 'Defect detection'),
    application('conveyors-handling-systems', 'Sorting'),
  ],
}

const featuredJobs = new Set(applicationsSection.items.map((item) => item.title))

export const marquee = {
  label: 'Jobs we automate',
  items: Array.from(
    new Map(
      products.flatMap((item) => item.applications.map((entry) => [entry.title, { key: entry.title, label: entry.title, icon: item.icon }] as const)),
    ).values(),
  ).filter((item) => !featuredJobs.has(item.label) && hasItemIcon(item.label)),
}

export const stationsSection = {
  eyebrow: 'Inside a production line',
  title: 'One line,',
  accent: 'four stations.',
  text: 'The line below is a small version of what we build: product moves on a conveyor, gets checked by a camera, is handled by a robot and finishes inside a guarded special purpose machine.',
  chipsLabel: 'Featured solutions',
  chips: [
    { slug: 'conveyors-handling-systems', label: 'Conveyor', text: 'Moves product between stations' },
    { slug: 'vision-camera-systems', label: 'Vision QC', text: 'Pass/fail straight to your PLC' },
    { slug: 'industrial-robotics', label: 'Robot cell', text: 'Pick, place, palletise, tend' },
    { slug: 'machine-safety', label: 'Machine safety', text: 'Guarding, light curtains, interlocks' },
  ].map((chip) => ({ ...chip, icon: product(chip.slug).icon })),
}

export const blogSection = {
  eyebrow: 'Blog',
  title: 'Guides from',
  accent: 'our engineers.',
  text: 'Practical reading on robot cells, vision inspection, conveyors, machine safety and automating the lines you already run.',
  link: 'View all articles',
  count: 3,
}

export const processSection = {
  eyebrow: 'How we work',
  title: 'Designed around your line.',
  accent: 'Supported after handover.',
  steps: [
    { title: 'Process study', text: 'We start from your part, your process and your cycle-time target.' },
    { title: 'Concept & design', text: 'Concept design for a single station, a robot cell or a complete line.' },
    { title: 'Build & commissioning', text: 'Build, integration and commissioning, with PLC / HMI controls and safety built in.' },
    { title: 'Training & support', text: 'Operator training and after-sales support from our engineers once the line is running.' },
  ],
}

const tech = (label: string, slug: string) => {
  const item = product(slug)
  return { label, slug, icon: item.icon, productName: item.name }
}

const techGroups = [
  {
    key: 'motion',
    tone: 'blue' as const,
    label: 'Motion & handling',
    items: [
      tech('Pneumatic cylinders', 'automation-components'),
      tech('Valves & fittings', 'automation-components'),
      tech('Motors & drives', 'vfd-industrial-motors'),
      tech('Variable frequency drives', 'vfd-industrial-motors'),
      tech('Actuators', 'automation-components'),
      tech('Transfers & diverters', 'conveyors-handling-systems'),
    ],
  },
  {
    key: 'sensing',
    tone: 'green' as const,
    label: 'Sensing & vision',
    items: [
      tech('Inductive sensors', 'industrial-sensors'),
      tech('Capacitive sensors', 'industrial-sensors'),
      tech('Photoelectric sensors', 'industrial-sensors'),
      tech('Vision cameras', 'vision-camera-systems'),
      tech('Barcode & QR reading', 'vision-camera-systems'),
      tech('Text (OCR) reading', 'vision-camera-systems'),
    ],
  },
  {
    key: 'safety',
    tone: 'yellow' as const,
    label: 'Safety',
    items: [
      tech('Safety fencing', 'machine-safety'),
      tech('Light curtains', 'machine-safety'),
      tech('Safety interlocks', 'machine-safety'),
      tech('Safety scanners', 'machine-safety'),
      tech('Safety relays', 'control-safety-devices'),
      tech('Emergency stops', 'control-safety-devices'),
    ],
  },
  {
    key: 'controls',
    tone: 'navy' as const,
    label: 'Controls',
    items: [
      tech('PLC / HMI controls', 'plc-hmi-systems'),
      tech('SCADA monitoring', 'scada-systems'),
      tech('Electrical control panels', 'electrical-control-panels'),
      tech('Push buttons', 'control-safety-devices'),
      tech('Selector switches', 'control-safety-devices'),
      tech('Pilot lights', 'control-safety-devices'),
      tech('Tower lights', 'control-safety-devices'),
      tech('Control panels', 'control-safety-devices'),
      tech('Electrical & panel components', 'automation-components'),
    ],
  },
]

const techItems = techGroups.flatMap((group) => group.items.map((item) => ({ ...item, group: group.key, tone: group.tone })))

export const techSection = {
  eyebrow: 'What we work with',
  title: 'The parts behind',
  accent: 'every automated line.',
  text: 'Every station we build comes together from the same building blocks. Pick a group to see what goes into motion, sensing, safety and controls.',
  groups: techGroups,
  items: techItems,
  band: {
    title: 'See every part we work with',
    text: `All ${techItems.length} parts and technologies across motion, sensing, safety and controls, each linked to the product it belongs to.`,
    cta: 'See all parts & technology',
  },
}

export const locationSection = {
  eyebrow: 'Visit us',
  title: 'Find us in',
  accent: 'Derabassi, Punjab.',
  text: `${site.name} works from Hansa Industrial Park in Derabassi. Visit us, call, or send your requirement and our team will get back to you.`,
  officeLabel: 'Derabassi · Punjab',
  officeName: site.name,
  directions: 'Get directions',
  follow: 'Follow us',
}

const names = products.map((item) => item.name.replace(/\b[A-Z][a-z]+/g, (word) => word.toLowerCase()))
const productList = `${names.slice(0, -1).join(', ')} and ${names[names.length - 1]}`

export const faqSection = {
  eyebrow: 'FAQ',
  title: 'Common questions',
  more: 'Still have a question? Contact us',
  items: [
    {
      q: `What does ${site.name} do?`,
      a: `We design, build and supply industrial automation: ${productList}.`,
    },
    {
      q: 'Can you automate a line we already run?',
      a: 'Yes. Line upgrades automate manual steps on existing lines, machine modifications add new controls, safety or automation to individual machines, and our vision systems retrofit onto machines you already run.',
    },
    {
      q: 'Do you take on complete projects or only supply parts?',
      a: 'Both. We handle complete automation projects, from concept and design through build, installation and support, and we also supply automation components, sensors and control devices for new machines or upgrades.',
    },
    {
      q: 'Can a robot work with the machines we already have?',
      a: 'Yes. Robot cells can tend CNC, press and moulding machines you already run, loading and unloading parts, and are integrated with your conveyors, vision and safety guarding.',
    },
    {
      q: 'How do you keep operators safe around new automation?',
      a: 'Safety is planned from a risk assessment for each station: guarding and fencing, light curtains, interlocks and safety relays, with emergency stops as a backup. Tower lights then show machine status at a glance.',
    },
  ],
}
