import { categoryKeys } from './categories'
import { products } from './products'
import { site } from './site'

export const aboutPage = {
  intro: {
    eyebrow: 'Who we are',
    title: 'Automation built around',
    accent: 'your part and your process.',
    paragraphs: [
      `${site.name} designs, builds and supplies industrial automation from Hansa Industrial Park in Derabassi, Punjab. Our work covers the whole line: robot cells, special purpose machines, vision inspection, conveyors, industrial sensors, automation components, machine safety and control devices.`,
      'Every project starts from your part, your process and your cycle-time target. From there we design a single station, a robot cell or a complete line, build and commission it with PLC / HMI controls and safety built in, and stay on to train your operators and support the line once it is running.',
      'We also upgrade lines you already run, automating manual steps one station at a time, and supply the components, sensors and control devices that go into new machines.',
    ],
    imageAlt: 'A test bench with a clamped part under a pneumatic test head, pressure gauges, a leak test display, an HMI and pass and fail bins',
  },
  facts: [
    { label: 'Based in', value: 'Hansa Industrial Park, Derabassi, Punjab' },
    { label: 'What we do', value: 'Design, build and supply industrial automation' },
    { label: 'Product range', value: `${products.length} products across ${categoryKeys.length} categories` },
    { label: 'After handover', value: 'Operator training and after-sales support' },
  ],
  purpose: {
    eyebrow: 'Vision & mission',
    title: 'What drives',
    accent: 'our work.',
    cards: [
      {
        label: 'Our vision',
        title: site.taglines[0],
        text: 'Automation that makes production more consistent, safer and easier to scale, so people spend their time on work that needs them.',
      },
      {
        label: 'Our mission',
        title: site.taglines[1],
        text: 'Design and build automation around each customer’s part and process, with safety built into every station and support that continues after handover.',
      },
    ],
  },
  whatWeDo: {
    eyebrow: 'What we do',
    title: 'Automation for every stage',
    accent: 'of your line.',
  },
  advantages: {
    eyebrow: 'Why Intellizen',
    title: 'Key advantages',
    details: {
      'Innovative Solutions': 'Robot cells, vision inspection and special purpose machines designed around your part and process.',
      'Increased Efficiency': 'Automated stations take repetitive work off your operators and keep every part consistent.',
      'Cost Savings': 'Upgrade the lines you already run one station at a time, instead of starting from scratch.',
      'Expert Support': 'Programming, commissioning, operator training and after-sales support from our engineers.',
      'Proven Results': 'Every station is built, integrated and commissioned before your team takes it over.',
    } as Record<string, string>,
  },
  faq: {
    eyebrow: 'FAQ',
    title: 'Questions about Intellizen',
    more: 'Still have a question? Contact us',
    items: [
      {
        q: 'What kind of automation does Intellizen build?',
        a: 'Robot cells for handling, tending and assembly, special purpose machines, vision inspection systems and conveyors, together with the sensors, automation components, machine safety and control devices that go into them.',
      },
      {
        q: 'Can you work on a single station rather than a full line?',
        a: 'Yes. Our custom automation work covers new lines, line upgrades and single stations, so you can start with the one step that matters most.',
      },
      {
        q: 'Do you supply parts as well as complete machines?',
        a: 'Yes. We supply automation components, industrial sensors and control and safety devices for new machines and for upgrades to existing ones.',
      },
      {
        q: 'Can you upgrade machines we already run?',
        a: 'Yes. We automate manual steps on existing lines, retrofit vision inspection, add robots that tend existing machines and add safety guarding where it is needed.',
      },
      {
        q: 'How do we start a project with you?',
        a: `Send a short note on the part, the process and the output you need through the contact form, email ${site.emails[1]} or call ${site.phones[0].label}. Photos or a layout of the line help us reply with the right solution.`,
      },
    ],
  },
}
