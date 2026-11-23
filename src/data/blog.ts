export const blogCategories = ['Robotics & machines', 'Vision & sensing', 'Material handling', 'Machine safety', 'Line automation'] as const

export type BlogCategory = (typeof blogCategories)[number]

export type BlogBlock =
  | { type: 'h2'; text: string }
  | { type: 'h3'; text: string }
  | { type: 'p'; text: string }
  | { type: 'list'; items: string[] }
  | { type: 'table'; head: string[]; rows: string[][] }
  | { type: 'note'; text: string }

export type BlogPost = {
  slug: string
  title: string
  seoTitle?: string
  category: BlogCategory
  excerpt: string
  intro: string
  image: string
  imageAlt: string
  published: string
  tags: string[]
  products: string[]
  body: BlogBlock[]
  faq: { q: string; a: string }[]
}

export const blogAuthor = {
  name: 'Intellizen Engineering Team',
  role: 'Industrial automation · Derabassi, Punjab',
}

const B = '/assets/blog/'

export const posts: BlogPost[] = [
  {
    slug: 'robot-cell-vs-special-purpose-machine',
    seoTitle: 'Robot Cell or Special Purpose Machine? | Intellizen',
    title: 'Robot Cell or Special Purpose Machine: Which Fits Your Production Line?',
    category: 'Robotics & machines',
    excerpt: 'Both take repetitive work off your operators, but they solve different problems. Here is how to choose between a robot cell and a machine built for one job.',
    intro:
      'When a manual station becomes the bottleneck on a line, the first automation question is usually the same: do we put in a robot, or build a machine dedicated to the job? Both remove repetitive work from operators, and both run happily alongside conveyors, vision and safety systems. The right answer depends on how much the job changes, how fast it has to run and how the station will be used in the years after it is installed.',
    image: B + 'robot-cell-vs-special-purpose-machine.jpg',
    imageAlt: 'Guarded robot palletising cell with a six-axis robot, an infeed conveyor and a stacked pallet in a factory',
    published: '2026-11-13',
    tags: ['Industrial robotics', 'Special purpose machines', 'Machine tending', 'Line design'],
    products: ['industrial-robotics', 'special-purpose-machines', 'machine-safety'],
    body: [
      { type: 'h2', text: 'What a robot cell does well' },
      {
        type: 'p',
        text: 'An industrial robot is a general-purpose arm. Inside a cell it gets a gripper or tool, fixtures, guarding and a controller, and is then programmed for the task in front of it. The same arm can pick and place, palletise, tend a machine or assemble parts, and it can be taught a new job later.',
      },
      {
        type: 'list',
        items: [
          '**Several part variants** can run on one cell with program and gripper changes.',
          '**Product changes** are handled in software rather than with new hardware.',
          '**A large working area** lets one arm serve more than one machine or pallet position.',
          '**Handling between machines**, such as loading a CNC or press, is where robots are strongest.',
        ],
      },
      { type: 'h2', text: 'What a special purpose machine does well' },
      {
        type: 'p',
        text: 'A special purpose machine (SPM) is designed around a single process on a defined family of parts. Assembly, pressing, testing and marking are typical examples. The tooling, motion and controls are built for that one job, which is why an SPM is usually compact, fast and simple for line staff to run.',
      },
      {
        type: 'list',
        items: [
          '**A fixed, repeatable cycle** tuned to the one operation.',
          '**Process forces** such as pressing, riveting or crimping are designed into the frame.',
          '**A compact footprint** built around the part rather than around an arm’s reach.',
          '**Straightforward operation** with an HMI made for that process.',
        ],
      },
      { type: 'h2', text: 'Robot cell vs special purpose machine at a glance' },
      {
        type: 'table',
        head: ['Factor', 'Robot cell', 'Special purpose machine'],
        rows: [
          ['Best for', 'Handling, tending, palletising, varied parts', 'One process on one part family'],
          ['Flexibility', 'High: re-program and change grippers', 'Low: tooling is made for the job'],
          ['Process forces', 'Limited by the robot’s payload', 'Designed in for pressing, joining or testing'],
          ['Product changes', 'Program and gripper changes', 'Tooling changes or a modified machine'],
          ['Footprint', 'Larger, with a guarded working area', 'Compact around the process'],
          ['Typical role', 'Moving parts between stations', 'Doing the work on the part'],
        ],
      },
      { type: 'h2', text: 'Questions to answer before you decide' },
      {
        type: 'list',
        items: [
          'How many part variants will run on this station, and how often do they change?',
          'Does the job need force (pressing, riveting, crimping) or mainly movement?',
          'What cycle time does the line need from this station?',
          'How much floor space is available, including room for guarding?',
          'Will the station need to take on a different job in a few years?',
        ],
      },
      {
        type: 'p',
        text: 'If the answers point to many variants and changing products, a robot cell usually makes more sense. If they point to one demanding operation at a steady rate, a special purpose machine is often the better fit.',
      },
      { type: 'h2', text: 'When the answer is both' },
      {
        type: 'p',
        text: 'Many lines combine the two. A robot loads and unloads parts while a special purpose machine performs the process, a vision camera checks the result and conveyors link the stations. The robot brings flexibility to the handling, and the SPM brings speed and force to the operation itself.',
      },
      { type: 'h2', text: 'How we approach it' },
      {
        type: 'p',
        text: 'We start from your part, your process and your cycle-time target before recommending a robot cell, a special purpose machine or a combination of both. From there we handle concept design, build, integration and commissioning, with PLC / HMI controls and safety built in, and support the station once it is running.',
      },
    ],
    faq: [
      {
        q: 'Is a robot cell always more flexible than a special purpose machine?',
        a: 'For handling tasks, usually yes, because a robot can be re-programmed and fitted with a different gripper. For a single process that needs high force or a very specific motion, a special purpose machine is often the more practical choice.',
      },
      {
        q: 'Can a robot load an existing machine?',
        a: 'Yes. Machine tending, where a robot loads and unloads CNC, press or moulding machines, is one of the most common robot applications and can be added to machines you already run.',
      },
      {
        q: 'Do both options need safety guarding?',
        a: 'Yes. Robot cells and special purpose machines both need guarding, interlocks or light curtains chosen through a risk assessment for the station.',
      },
      {
        q: 'Can one robot serve more than one machine?',
        a: 'Often, yes, if the machines sit within the robot’s reach and their cycle times leave the robot enough time to load and unload each one. This is checked during concept design.',
      },
      {
        q: 'What do you need from us to recommend the right option?',
        a: 'Your part or a sample, the process, the number of variants you run and the cycle time the line needs. Drawings and photos of the current station help too.',
      },
    ],
  },
  {
    slug: 'vision-inspection-on-the-production-line',
    seoTitle: 'Vision Inspection on the Production Line | Intellizen',
    title: 'Vision Inspection on the Production Line: What a Camera Can Check',
    category: 'Vision & sensing',
    excerpt: 'From presence checks to reading codes, a vision system checks every part and sends a pass/fail signal to your PLC. Here is what it can do and how to plan one.',
    intro:
      'Manual inspection works until the line speeds up, the shift gets long or the defect is too small to see at a glance. A vision system checks every part in the same way, every time, and turns the result into a simple pass/fail signal your line can act on. Here is how it works, what it can check and what to prepare before you add one.',
    image: B + 'vision-inspection-on-the-production-line.jpg',
    imageAlt: 'Vision inspection station with a camera and ring light above parts on a conveyor, beside a control cabinet',
    published: '2026-11-13',
    tags: ['Vision inspection', 'Quality control', 'Barcode reading', 'OCR'],
    products: ['vision-camera-systems', 'industrial-sensors', 'barcode-label-printers', 'conveyors-handling-systems'],
    body: [
      { type: 'h2', text: 'How a vision system works' },
      {
        type: 'p',
        text: 'A sensor detects that a part has arrived and triggers the camera. The camera captures an image under controlled lighting, the inspection software measures or compares what it sees, and the result goes to the PLC as a pass or fail. The PLC then lets the part continue, stops the line or diverts the part to a reject lane.',
      },
      {
        type: 'list',
        items: [
          '**Camera and lens** sized for the part and the smallest detail you need to see.',
          '**Lighting** that makes the feature or defect stand out clearly.',
          '**Inspection software** that measures, compares or reads the image.',
          '**A trigger and an output** wired into your line’s controls.',
        ],
      },
      { type: 'h2', text: 'What a camera can check' },
      {
        type: 'table',
        head: ['Check', 'What it looks for', 'Typical use'],
        rows: [
          ['Presence check', 'Is every component fitted?', 'Assemblies, kits, caps and clips'],
          ['Dimension check', 'Are key features within tolerance?', 'Machined and moulded parts'],
          ['Defect detection', 'Scratches, dents and misprints', 'Surfaces, labels and packaging'],
          ['Code reading', 'Barcodes, QR codes and printed text', 'Traceability and labelling'],
        ],
      },
      { type: 'h2', text: 'Lighting matters as much as the camera' },
      {
        type: 'p',
        text: 'Most inspection problems are lighting problems. The goal is to make the feature you care about look the same on every image, whatever the time of day or the condition of the part.',
      },
      {
        type: 'list',
        items: [
          '**Backlighting** shows a sharp silhouette, which suits outlines and dimensions.',
          '**Diffuse lighting** reduces glare on shiny or curved parts.',
          '**Low-angle lighting** picks up scratches, dents and embossed text.',
          '**Enclosures or shrouds** keep changing ambient light out of the image.',
        ],
      },
      { type: 'h2', text: 'Connecting the result to your line' },
      {
        type: 'p',
        text: 'A vision system is only useful if the line acts on its result. The pass/fail signal goes to the PLC, which can stop the conveyor, raise an alarm on the HMI or trigger a diverter that moves faulty parts to a reject lane. Results can also be logged for traceability, and codes read by the camera can be matched against the order being produced.',
      },
      { type: 'h2', text: 'What to prepare before you start' },
      {
        type: 'list',
        items: [
          'Sample parts, both good and faulty, including borderline cases.',
          'A clear definition of what counts as a defect and what does not.',
          'The line speed and how parts are presented to the camera.',
          'Where a rejected part should go and who needs to know about it.',
        ],
      },
      {
        type: 'note',
        text: 'Vision systems fit new lines and can also be retrofitted onto existing machines, so inspection does not have to wait for the next line build.',
      },
      { type: 'h2', text: 'How we approach it' },
      {
        type: 'p',
        text: 'We build vision inspection into new lines and retrofit it onto existing machines, from camera and lighting selection to the pass/fail signal into your PLC and the reject handling around it.',
      },
    ],
    faq: [
      {
        q: 'Can a vision system be added to a machine we already run?',
        a: 'Yes. Cameras, lighting and the PLC connection can usually be retrofitted onto an existing machine or conveyor, so you can add inspection without replacing the line.',
      },
      {
        q: 'Can a camera read printed text as well as barcodes?',
        a: 'Yes. Along with barcodes and QR codes, vision systems can read printed text such as batch numbers and dates using optical character recognition.',
      },
      {
        q: 'What happens to a part that fails inspection?',
        a: 'The camera sends a fail signal to the PLC, which can stop the line, raise an alarm or trigger a diverter that moves the part to a reject lane.',
      },
      {
        q: 'Does a vision system need special lighting?',
        a: 'Usually, yes. Lighting is chosen to make the feature or defect stand out, such as backlighting for outlines, diffuse light for shiny parts or low-angle light for scratches, and shrouds keep changing daylight out.',
      },
      {
        q: 'Can inspection results be saved for traceability?',
        a: 'Yes. Results can be logged, and codes read by the camera can be matched against the order being produced.',
      },
    ],
  },
  {
    slug: 'belt-roller-or-modular-conveyor',
    seoTitle: 'Belt, Roller or Modular Conveyor? | Intellizen',
    title: 'Belt, Roller or Modular Conveyor: Choosing the Right One for Your Line',
    category: 'Material handling',
    excerpt: 'Conveyors link every station on a line. The right type depends on what you move, how it needs to queue and how it transfers between stations.',
    intro:
      'Conveyors rarely get the attention that robots and vision systems do, yet every part on an automated line rides on one. Pick the wrong type and parts slip, jam or arrive at the next station in the wrong position. This guide compares belt, roller and modular conveyors and the transfers that connect them.',
    image: B + 'belt-roller-or-modular-conveyor.jpg',
    imageAlt: 'Belt, roller and modular belt conveyors carrying cartons in a factory',
    published: '2026-11-13',
    tags: ['Conveyors', 'Material handling', 'Accumulation', 'Sorting'],
    products: ['conveyors-handling-systems', 'industrial-sensors', 'vfd-industrial-motors', 'industrial-robotics'],
    body: [
      { type: 'h2', text: 'Belt conveyors' },
      {
        type: 'p',
        text: 'A belt conveyor carries products on a continuous surface. Because the belt supports the whole base of the product, it handles small, light or irregular items that would fall between rollers, and it can run on inclines.',
      },
      {
        type: 'list',
        items: ['Small, light or irregular products', 'Inclines and declines between levels', 'Steady transport between stations'],
      },
      { type: 'h2', text: 'Roller conveyors' },
      {
        type: 'p',
        text: 'A roller conveyor moves products over a series of rollers, either powered or by gravity. It suits items with a firm, flat base such as cartons, totes and pallets, and is well suited to letting products queue, or accumulate, before the next station.',
      },
      {
        type: 'list',
        items: ['Cartons, totes and pallets', 'Accumulation zones before a station', 'Heavier loads on a flat base'],
      },
      { type: 'h2', text: 'Modular conveyors' },
      {
        type: 'p',
        text: 'A modular conveyor uses a belt made of interlocking plastic modules. It can run around curves, is easy to repair one section at a time and copes well with wet or wash-down areas.',
      },
      {
        type: 'list',
        items: ['Curved and complex layouts', 'Wet or wash-down environments', 'Sections that need quick repair'],
      },
      { type: 'h2', text: 'Comparison at a glance' },
      {
        type: 'table',
        head: ['Factor', 'Belt', 'Roller', 'Modular'],
        rows: [
          ['Best products', 'Small, light, irregular', 'Cartons, totes, pallets', 'Mixed, wet or packaged items'],
          ['Accumulation', 'Limited', 'Well suited', 'Possible with the right design'],
          ['Curves', 'Limited', 'With curved roller sections', 'Well suited'],
          ['Inclines', 'Well suited', 'Shallow only, with powered rollers', 'Possible with flights'],
          ['Maintenance', 'Belt tracking and tension', 'Rollers and drives', 'Replace individual modules'],
        ],
      },
      { type: 'h2', text: 'Transfers and diverters' },
      {
        type: 'p',
        text: 'Lines are rarely one straight conveyor. Transfers move products from one conveyor to another, and diverters send them to different lanes for sorting, rejects or packing. Sensors along the conveyor detect each product so the controls know when to stop, queue or divert it.',
      },
      { type: 'h2', text: 'Planning checklist' },
      {
        type: 'list',
        items: [
          'Product size, weight and the shape of its base',
          'Where products need to queue before a station',
          'The layout of the line, including curves and level changes',
          'Where sorting, rejects or transfers are needed',
          'How robots, vision and sensors will interact with the conveyor',
        ],
      },
      { type: 'h2', text: 'How we approach it' },
      {
        type: 'p',
        text: 'We design belt, roller and modular conveyors together with the transfers, sensors and controls around them, so products arrive at each station, robot or camera in the position it expects.',
      },
    ],
    faq: [
      {
        q: 'Which conveyor is best for cartons?',
        a: 'Roller conveyors are a common choice for cartons because their firm, flat base rides well on rollers and they can queue before a station. Belt conveyors also work, especially on inclines.',
      },
      {
        q: 'Can a conveyor sort products into different lanes?',
        a: 'Yes. Diverters controlled by the PLC can send products to different lanes for sorting, packing or rejects, based on sensor or vision signals.',
      },
      {
        q: 'Can different conveyor types be used on the same line?',
        a: 'Yes. Many lines mix belt, roller and modular sections, joined by transfers, so each part of the line uses the type that suits it.',
      },
      {
        q: 'How does a conveyor know where a product is?',
        a: 'Sensors along the conveyor detect each product, so the PLC knows when to stop it, let it queue or divert it to another lane.',
      },
      {
        q: 'Which conveyor works in wet or wash-down areas?',
        a: 'Modular conveyors, with belts made of interlocking plastic modules, cope well with wet or wash-down environments and can be repaired one section at a time.',
      },
    ],
  },
  {
    slug: 'machine-safety-guarding-light-curtains-interlocks',
    seoTitle: 'Machine Safety: Guarding & Light Curtains | Intellizen',
    title: 'Machine Safety Basics: Guarding, Light Curtains and Interlocks',
    category: 'Machine safety',
    excerpt: 'Every automated station must keep people away from moving parts. Here is how fencing, interlocks, light curtains, scanners and emergency stops work together.',
    intro:
      'Automation removes people from repetitive work, but people still load parts, clear jams and maintain machines. Machine safety makes sure they can do that without being exposed to moving parts. No single device does the job alone: guarding, interlocks, light curtains, scanners and emergency stops each cover a different situation, and a safety control system ties them together.',
    image: B + 'machine-safety-guarding-light-curtains-interlocks.jpg',
    imageAlt: 'Hydraulic press guarded by mesh safety fencing, with a light curtain, a floor safety scanner and an emergency stop',
    published: '2026-11-13',
    tags: ['Machine safety', 'Light curtains', 'Interlocks', 'Emergency stops'],
    products: ['machine-safety', 'control-safety-devices', 'machine-modifications', 'industrial-robotics'],
    body: [
      { type: 'h2', text: 'Start with a risk assessment' },
      {
        type: 'p',
        text: 'Safety measures are chosen from a risk assessment of the specific machine: who works near it, what they do there, and what could hurt them. The general principles are set out in ISO 12100, and the outcome decides which of the measures below a station needs.',
      },
      { type: 'h2', text: 'Fixed guarding and safety fencing' },
      {
        type: 'p',
        text: 'Physical guarding keeps people out of areas they never need to enter while the machine runs. Mesh fencing around a robot cell is the familiar example. Fixed guards are simple and reliable, so they are usually the first choice wherever access is not needed during production.',
      },
      { type: 'h2', text: 'Interlocked doors' },
      {
        type: 'p',
        text: 'Where people do need access, for example to clear a jam or change tooling, the door in the guarding is fitted with a safety interlock. Opening the door stops the hazardous motion, and the machine can only restart once the door is closed and the system has been reset.',
      },
      { type: 'h2', text: 'Light curtains' },
      {
        type: 'p',
        text: 'A light curtain protects an opening that operators reach through often, such as a loading station. When a hand or body breaks the beams, the machine stops. Light curtains must be mounted far enough from the hazard that motion stops before a person can reach it. That distance depends on the machine’s stopping time and on the light curtain’s response time and resolution, and is covered in ISO 13855. A light curtain only suits machines that can stop part-way through a cycle; a mechanical press with a full-revolution clutch needs a different kind of guarding.',
      },
      { type: 'h2', text: 'Safety scanners' },
      {
        type: 'p',
        text: 'A safety laser scanner watches an area on the floor rather than a single opening. It can slow or stop a machine when someone walks into the protected zone, which suits larger cells and areas where people and machines share space.',
      },
      { type: 'h2', text: 'Emergency stops and safety relays' },
      {
        type: 'p',
        text: 'Emergency stop buttons let anyone near the machine stop it quickly, so they need to be within easy reach of every operator position. Safety relays or safety controllers monitor the E-stops, interlocks and light curtains and switch off hazardous motion when any of them is triggered.',
      },
      { type: 'h2', text: 'Which device protects what' },
      {
        type: 'table',
        head: ['Device', 'What it protects', 'Typical place'],
        rows: [
          ['Safety fencing', 'Areas with no access during production', 'Around robot cells and conveyors'],
          ['Interlocked door', 'Access points used for jams and changeovers', 'Doors in the guarding'],
          ['Light curtain', 'Openings operators reach through often', 'Loading stations'],
          ['Safety scanner', 'Floor areas people may walk into', 'Larger cells and shared areas'],
          ['Emergency stop', 'A backup way to stop the machine, not a guard', 'Panels, pedestals and stations'],
        ],
      },
      {
        type: 'note',
        text: 'This article is a general overview. The right combination of safety measures for a machine comes from a risk assessment carried out for that machine.',
      },
      { type: 'h2', text: 'How we approach it' },
      {
        type: 'p',
        text: 'We supply and integrate machine safety guarding, light curtains and interlocks, together with control and safety devices such as push buttons, emergency stops and tower lights, for robot cells, presses, special purpose machines and conveyors.',
      },
    ],
    faq: [
      {
        q: 'Is a light curtain enough on its own?',
        a: 'Usually not. A light curtain protects one opening, so it is normally combined with fixed guarding, interlocked doors and emergency stops chosen through the risk assessment.',
      },
      {
        q: 'Where should emergency stop buttons go?',
        a: 'Within easy reach of every place an operator works on or near the machine, so anyone can stop it quickly.',
      },
      {
        q: 'Can safety guarding be added to an existing machine?',
        a: 'In many cases, yes. Fencing, interlocks and light curtains can be added to existing machines after an assessment of how the machine is used.',
      },
      {
        q: 'What does a safety relay do?',
        a: 'It monitors emergency stops, interlocks and light curtains, and switches off hazardous motion as soon as any of them is triggered.',
      },
      {
        q: 'Where should we start with machine safety?',
        a: 'With a risk assessment of the machine: who works near it, what they do there and what could hurt them. The general principles are set out in ISO 12100.',
      },
    ],
  },
  {
    slug: 'automating-an-existing-line',
    seoTitle: 'Automating an Existing Production Line | Intellizen',
    title: 'Automating an Existing Line Without Starting From Scratch',
    category: 'Line automation',
    excerpt: 'You do not need a new factory to automate. Here is a step-by-step way to automate the manual steps on a line you already run.',
    intro:
      'Most factories do not have the space or the budget to replace a working line, yet they still want to remove manual handling, improve consistency and keep up with demand. The good news is that automation can be added one station at a time. Upgrading an existing line is often the most practical way to start.',
    image: B + 'automating-an-existing-line.jpg',
    imageAlt: 'Older power press retrofitted with a new control cabinet, HMI, light curtains and sensors',
    published: '2026-11-13',
    tags: ['Line upgrades', 'Custom automation', 'Retrofit', 'PLC / HMI'],
    products: ['custom-automation-solutions', 'machine-modifications', 'plc-hmi-systems', 'industrial-robotics', 'vision-camera-systems'],
    body: [
      { type: 'h2', text: 'Find the station that holds the line back' },
      {
        type: 'p',
        text: 'Start with a process study of the line as it runs today. Look for the station that sets the pace, the steps where quality varies between operators, and the tasks that are heavy, repetitive or awkward. These are usually the best candidates for the first automated station.',
      },
      { type: 'h2', text: 'Match the step to an automation option' },
      {
        type: 'table',
        head: ['Manual step today', 'Automation option'],
        rows: [
          ['Moving parts between machines', 'Robot cell for pick & place or machine tending'],
          ['Visual checks by an operator', 'Vision inspection with a pass/fail signal'],
          ['Carrying parts between stations', 'Conveyors with transfers and sensors'],
          ['Pressing, assembly or testing by hand', 'Special purpose machine for that process'],
          ['Stacking cartons at the end of the line', 'Robot palletising'],
        ],
      },
      { type: 'h2', text: 'Make new and old equipment work together' },
      {
        type: 'p',
        text: 'A new station has to fit the line around it. Sensors tell it when a part has arrived, a PLC coordinates it with the machines before and after it, and an HMI shows operators what it is doing. Guarding, interlocks and light curtains are planned at the same time, so the upgraded area is safe from the first day.',
      },
      { type: 'h2', text: 'Plan the installation around production' },
      {
        type: 'p',
        text: 'Much of the build and testing can be done before the new station reaches your floor. That keeps the time the line is stopped for installation and commissioning as short as possible, and the work can be planned around your production schedule.',
      },
      { type: 'h2', text: 'A step-by-step path' },
      {
        type: 'list',
        items: [
          '**Process study:** we start from your part, your process and your cycle-time target.',
          '**Concept & design:** a concept for a single station, a robot cell or a complete line.',
          '**Build & commissioning:** build, integration and commissioning, with PLC / HMI controls and safety built in.',
          '**Training & support:** operator training and after-sales support once the line is running.',
        ],
      },
      { type: 'h2', text: 'What to share at the start' },
      {
        type: 'list',
        items: [
          'The part, or a sample, and any drawings you have',
          'The process as it runs today and the output you need',
          'Photos or a layout of the line and the space around it',
          'The controls already on the line, if known',
        ],
      },
      { type: 'h2', text: 'How we approach it' },
      {
        type: 'p',
        text: 'Our custom automation work covers new lines, line upgrades that automate manual steps on existing lines, and single stations, from concept and design through build, installation and support.',
      },
    ],
    faq: [
      {
        q: 'Do we have to replace the whole line to automate it?',
        a: 'No. Automation can be added one station at a time, starting with the step that holds the line back or the task that is hardest on operators.',
      },
      {
        q: 'Can a new station work with our existing machines?',
        a: 'Usually yes. Sensors and a PLC coordinate the new station with the machines before and after it, and an HMI shows operators what it is doing.',
      },
      {
        q: 'What should we share to get started?',
        a: 'A short note on the part, the process and the output you need, plus photos or a layout of the line, is enough to begin the conversation.',
      },
      {
        q: 'Which station should we automate first?',
        a: 'Usually the station that sets the pace of the line, the step where quality varies between operators, or the task that is heaviest or most repetitive for your team.',
      },
      {
        q: 'Will the line need to stop for the installation?',
        a: 'Only for part of it. Much of the build and testing is done before the new station reaches your floor, and the installation is planned around your production schedule.',
      },
    ],
  },
]

const textOf = (block: BlogBlock): string[] => {
  if (block.type === 'list') return block.items
  if (block.type === 'table') return [...block.head, ...block.rows.flat()]
  return [block.text]
}

export const readMinutes = (post: BlogPost) => {
  const words = [post.intro, ...post.body.flatMap(textOf)].join(' ').split(/\s+/).filter(Boolean).length
  return Math.max(1, Math.round(words / 200))
}

export const getPost = (slug?: string) => posts.find((post) => post.slug === slug)

export const postsForProduct = (slug: string, count = 3) =>
  [...posts.filter((post) => post.products.includes(slug)), ...posts.filter((post) => !post.products.includes(slug))].slice(0, count)

export const formatDate = (iso: string) =>
  new Date(`${iso}T00:00:00`).toLocaleDateString('en-IN', { day: 'numeric', month: 'short', year: 'numeric' })
