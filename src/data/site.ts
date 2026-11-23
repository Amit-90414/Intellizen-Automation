import type { Category } from './categories'

export const site = {
  name: 'Intellizen Automation Solutions',
  taglines: ['Innovating Automation for a Smarter Future.', 'Solutions for a Smarter Tomorrow'],
  address: 'Plot No 250, Village Kuranwala, Hansa Industrial Park, Derabassi, SAS Nagar, Punjab 140501',
  emails: ['info@intellizen.co.in', 'sales@intellizen.co.in'],
  phones: [
    { label: '+91 86992 01062', tel: '+918699201062' },    
    { label: '+91 79018 03375', tel: '+917901803375' },

  ],
  gstin: '03EXNPS1739C1ZF',
  advantages: ['Innovative Solutions', 'Increased Efficiency', 'Cost Savings', 'Expert Support', 'Proven Results'],
  showClients: false,
  mapsUrl: 'https://www.google.com/maps?q=Hansa+Industrial+Park,+Kuranwala,+Derabassi,+Punjab+140501',
}

export const social = [
  { label: 'Instagram', handle: '@intellizenautomation', href: 'https://www.instagram.com/intellizenautomation/' },
]

export const siteUrl = 'https://intellizen.co.in'

export const mapEmbedUrl = `${site.mapsUrl}&output=embed`

export const nav = [
  { label: 'Home', to: '/' },
  { label: 'About Us', to: '/about' },
  { label: 'Products', to: '/products' },
  { label: 'Blog', to: '/blog' },
  { label: 'Contact Us', to: '/contact' },
]

export const sceneStations = [
  { num: '01', label: 'CONVEYOR', x: 40, slug: 'conveyors-handling-systems' },
  { num: '02', label: 'VISION QC', x: 250, slug: 'vision-camera-systems' },
  { num: '03', label: 'ROBOT CELL', x: 495, slug: 'industrial-robotics' },
  { num: '04', label: 'SPM + SAFETY', x: 715, slug: 'special-purpose-machines' },
]

export const copy = {
  header: {
    cta: 'Request a quote',
    megaNote: 'Explore the full range of automation products, from single sensors to complete production lines.',
    megaAll: 'View all products',
  },
  cta: {
    title: 'Plan your next line with us.',
    primary: 'Request a quote',
    call: `Call ${site.phones[0].label}`,
  },
  home: {
    title: 'Industrial Automation & Robotics in Punjab | Intellizen',
    description:
      'Industrial automation company in Derabassi, Mohali, near Chandigarh: robot cells, special purpose machines, PLC panels, SCADA, vision inspection and conveyors.',
    h1: 'Industrial Automation, Robot Cells and Special Purpose ',
    status: 'Industrial automation · Derabassi, Punjab',
    heading: { before: 'Solutions for a ', highlight: 'smarter', after: ' tomorrow.' },
    sub: 'From PLC panels, drives and sensors to robot cells, special purpose machines and vision inspection — automation for every stage of your line.',
    primary: 'Request a quote',
    secondary: 'See the solutions',
    productsEyebrow: 'Products & services',
    productsTitle: 'Every stage of your line, covered.',
    productsLink: 'View all products',
    advantagesTitle: 'Key advantages',
    clientsTitle: 'Trusted by',
    clientsPlaceholder: '[Client logos]',
    sceneLabel:
      'Animated isometric production line: boxes move along a conveyor through a vision inspection gantry, past a robot arm and into a guarded special purpose machine',
  },
  products: {
    title: 'Automation Products & Services in Punjab | Intellizen',
    description:
      'Robot cells, SPMs, PLC & HMI, SCADA, VFDs, control panels, vision, sensors, conveyors, label printers and labelling machines from Intellizen, Derabassi, Punjab.',
    tags: ['Products', 'Industrial automation'],
    heading: 'Automation products & services',
    sub: 'From PLC panels, drives, sensors and labelling to robot cells, special purpose machines and test benches. Open any product for details, specifications and applications.',
    imageAlt: 'Automated line with an infeed conveyor, a vision inspection gantry, a guarded palletising robot and control cabinets',
    noteTitle: 'From one part to a full line',
    noteText: 'Pick a category below, or tell us the job and we suggest the right mix.',
    all: 'All',
  },
  product: {
    related: 'Related products',
    quote: 'Request a quote',
    call: `Call ${site.phones[0].label}`,
    photoSoon: 'Photos coming soon',
    glance: 'At a glance',
    notes: {
      'machines-robotics': { title: 'Concept to commissioning', text: 'Designed around your part and cycle time, with PLC / HMI controls and safety built in.' },
      'plc-electrical': { title: 'Designed, wired, tested', text: 'Panels, programs and screens built for your machine and checked before they go live.' },
      'inspection-sensing': { title: 'Matched to your parts', text: 'Cameras and sensors chosen for what you need to detect, then linked to your PLC.' },
      'material-handling': { title: 'Built around your line', text: 'Sized to your products and speeds, and tied into the controls you already run.' },
      'safety-controls': { title: 'Safety by design', text: 'Guarding and safety devices chosen from a risk assessment of your machine.' },
      components: { title: 'Selected for your machine', text: 'Pneumatic, motion and electrical parts picked for a new build or an upgrade.' },
      software: { title: 'Built around your process', text: 'Software set up for your plant and linked to the machines, printers and systems you already use.' },
    } as Record<Category, { title: string; text: string }>,
    aboutEyebrow: 'About this product',
    includesTitle: 'What’s included',
    featuresEyebrow: 'Key features',
    featuresTitle: 'What makes it',
    featuresAccent: 'work on your line.',
    processEyebrow: 'How we deliver it',
    processTitle: 'From first study',
    processAccent: 'to a running line.',
    faqEyebrow: 'FAQ',
    faqTitle: 'Questions about this product',
    specPending: 'Confirmed in your quote',
    specNote: 'These figures are set for each project from your part, cycle time and line. Send your requirement and we confirm them in the quote.',
  },
  technology: {
    title: 'Automation Parts & Technology | Intellizen Automation',
    description:
      'Pneumatics, motors, conveyors, sensors, vision, machine safety, PLC / HMI controls and panel components that Intellizen builds into automated lines.',
    tags: ['What we work with', 'Parts & technology'],
    heading: 'Parts & technology',
    sub: 'Every station we build comes together from the same building blocks: motion, sensing, safety and controls.',
    noteText: 'Pick a group below, then open any part to see the product it belongs to.',
    jumpLabel: 'Jump to a group',
    imageAlt: 'Automation components on a workbench: an open control enclosure with power supply, breakers, contactors and PLC, an electric motor and a pneumatic cylinder with valves',
    noteTitle: 'Motion, sensing, safety, controls',
  },
  blog: {
    title: 'Industrial Automation Blog & Guides | Intellizen',
    description:
      'Practical guides on robot cells, special purpose machines, vision inspection, conveyors, machine safety and line automation from Intellizen.',
    tags: ['Blog', 'Automation guides'],
    heading: 'Automation guides & insights',
    sub: 'Practical guides on robot cells, vision inspection, conveyors, machine safety and automating the lines you already run.',
    read: 'Read the articles',
    noteTitle: 'Written by our engineers',
    noteText: 'Guides on robotics, vision, conveyors, safety and line automation.',
    imageAlt: 'Close-up of an HMI touch screen with start, stop, selector and emergency stop buttons on a pedestal',
    listTitle: 'Articles',
    all: 'All',
    filterLabel: 'Filter articles by topic',
    searchLabel: 'Search articles',
    searchPlaceholder: 'Search articles, machines, sensors, safety…',
    empty: 'No articles match your search.',
    clear: 'Clear filters',
    related: 'Related articles',
    relatedEyebrow: 'Keep reading',
    allPosts: 'View all articles',
    faqEyebrow: 'FAQ',
    faqTitle: 'Questions about this topic',
    writtenBy: 'Written by',
    published: 'Published',
    readTime: 'Read time',
    category: 'Category',
    progress: 'Reading progress',
    share: 'Share',
    copy: 'Copy link',
    copied: 'Link copied',
    products: 'Products in this article',
    ctaTitle: 'Build with our team',
    ctaText: 'Tell us the part, the process and the output you need. Our engineers will get back to you.',
    ctaButton: 'Request a quote',
    tagsLabel: 'Tags',
  },
  about: {
    title: 'About Intellizen | Industrial Automation Company, Punjab',
    description:
      'Intellizen Automation Solutions designs, builds and supports industrial automation from Hansa Industrial Park, Derabassi (Mohali), near Chandigarh, Punjab.',
    tags: ['About us', 'Derabassi, Punjab'],
    heading: 'About Intellizen',
    sub: 'Robot cells, special purpose machines, PLC panels, SCADA, vision inspection, conveyors, labelling and machine safety, designed and supported from Hansa Industrial Park, Derabassi, Punjab.',
    heroImageAlt: 'Control cabinets with an HMI, emergency stop and tower light behind the infeed conveyor of an automated line',
    noteTitle: 'Design · Build · Support',
    noteText: 'From process study and concept design to commissioning, training and after-sales support.',
  },
  contact: {
    title: 'Contact Intellizen | Industrial Automation in Derabassi',
    description:
      `Contact Intellizen Automation Solutions, Hansa Industrial Park, Derabassi, Mohali, near Chandigarh. Call ${site.phones[0].label} or email ${site.emails[1]}.`,
    tags: ['Contact', 'Derabassi, Punjab'],
    heading: 'Let’s automate your line',
    sub: 'Tell us what you want to automate. Our team will get back to you.',
    success: 'Thank you — we’ll get back to you soon.',
    error: `Couldn’t send. Please call ${site.phones[0].label} or email ${site.emails[1]}.`,
    mailOpened: `Your email app should now open with the enquiry filled in. If it doesn’t, email ${site.emails[1]} or call ${site.phones[0].label}.`,
    subject: 'Website enquiry',
    form: 'Send an enquiry',
    imageAlt: 'Special purpose machine with a pneumatic press head, polycarbonate guards, light curtains, an HMI and a two-hand control station',
    office: 'Our office',
  },
  notFound: {
    title: 'Page not found',
    sub: 'The page you’re looking for doesn’t exist.',
    home: 'Go home',
    products: 'View products',
  },
  footer: {
    about: 'We design, build and support industrial automation, from a single station to a complete line, for manufacturers who want faster, safer and more consistent production.',
    company: 'Company',
    products: 'Products',
    blog: 'Blogs',
    allPosts: 'View all blogs',
    links: [
      { label: 'About Us', to: '/about' },
      { label: 'Products', to: '/products' },
      { label: 'Parts & technology', to: '/technology' },
      { label: 'Blog', to: '/blog' },
      { label: 'Contact Us', to: '/contact' },
      { label: 'Privacy Policy', to: '/privacy-policy' },
      { label: 'Cookie Policy', to: '/cookie-policy' },
    ],
  },
}
