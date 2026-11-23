import { site, siteUrl } from './site'

export type LegalSection = {
  id: string
  title: string
  paragraphs?: string[]
  list?: string[]
  after?: string[]
}

export type LegalDoc = {
  path: string
  title: string
  description: string
  heading: string
  sub: string
  updated: string
  sections: LegalSection[]
}

const contactLines = [
  `Email: ${site.emails[0]}`,
  `Phone: ${site.phones[0].label}`,
  `Address: ${site.name}, ${site.address}`,
]

export const privacyPolicy: LegalDoc = {
  path: '/privacy-policy',
  title: 'Privacy Policy | Intellizen Automation Solutions',
  description: 'How Intellizen Automation Solutions collects, uses and protects personal information shared through this website and our enquiry form.',
  heading: 'Privacy Policy',
  sub: 'How we collect, use and protect the information you share with us through this website.',
  updated: '2026-11-14',
  sections: [
    {
      id: 'who-we-are',
      title: 'Who we are',
      paragraphs: [
        `This website, ${siteUrl}, is operated by ${site.name} (GSTIN ${site.gstin}), ${site.address}. In this policy, “we”, “us” and “our” refer to ${site.name}.`,
        'This policy explains what personal information we collect through this website, why we collect it, how we use and protect it, and the choices you have.',
      ],
    },
    {
      id: 'information-we-collect',
      title: 'Information we collect',
      paragraphs: ['We only collect the information you choose to share with us, along with the basic technical information any website receives.'],
      list: [
        'Enquiry form: your name, company, phone number, email address, the product you are interested in and your message.',
        'Direct contact: the details you share when you email, call or message us, including through Instagram.',
        'Technical information: like most websites, our hosting provider may record standard server logs such as your IP address, browser type, the pages you request and the date and time of each request.',
      ],
      after: ['You do not need to create an account to use this website, and we do not take payments through it.'],
    },
    {
      id: 'how-we-use-information',
      title: 'How we use your information',
      list: [
        'To reply to your enquiry and prepare quotes or proposals.',
        'To design, supply, install and support the products and services you ask us about.',
        'To keep records of our communication with customers and prospective customers.',
        'To keep this website secure and working properly.',
        'To meet our legal and regulatory obligations.',
      ],
      after: ['We do not sell your personal information, and we do not use it for purposes unrelated to your enquiry.'],
    },
    {
      id: 'enquiry-form',
      title: 'How enquiry form submissions are handled',
      paragraphs: [
        'When you send the enquiry form, your details are sent by email from our own web server to our sales team, and a copy of the enquiry is kept in a private log on that server so no enquiry is lost.',
        'If you give an email address, we send you one automatic message confirming that we received your enquiry. We do not add you to any mailing list.',
      ],
    },
    {
      id: 'third-party-services',
      title: 'Third-party services on this website',
      list: [
        'Google Fonts: the fonts on this website are loaded from Google’s servers, so Google receives your IP address when the page loads.',
        'Google Maps: our location map is embedded from Google Maps. When the map loads, Google may set cookies and collect information under its own privacy policy.',
        'Instagram: links to our Instagram profile take you to Instagram, which has its own privacy policy.',
        'Hosting and email providers: the services that host this website and deliver our email process information on our behalf.',
      ],
    },
    {
      id: 'analytics-and-advertising',
      title: 'Analytics and advertising',
      paragraphs: [
        'We do not currently use analytics or advertising tracking on this website. If we add them in future, for example to measure a marketing campaign, we will update this policy and our Cookie Policy before doing so and ask for your consent where it is required.',
      ],
    },
    {
      id: 'sharing',
      title: 'When we share information',
      list: [
        'With service providers who process information on our behalf, such as hosting, email and form-processing services.',
        'When we are required to by law, regulation or a valid request from a government authority.',
        'To protect our rights, our customers or the security of this website.',
      ],
    },
    {
      id: 'retention',
      title: 'How long we keep information',
      paragraphs: [
        'We keep enquiry details for as long as we need them to respond to you, to carry out any work you ask us to do and to maintain our business records, and we delete them when they are no longer needed for those purposes.',
      ],
    },
    {
      id: 'security',
      title: 'How we protect information',
      paragraphs: [
        'We take reasonable technical and organisational measures to protect personal information against loss, misuse and unauthorised access, including serving this website over a secure HTTPS connection. No method of transmission over the internet is completely secure, so we cannot guarantee absolute security.',
      ],
    },
    {
      id: 'your-rights',
      title: 'Your rights',
      paragraphs: [
        'Subject to applicable law, including India’s Digital Personal Data Protection Act, 2023, you can ask us to:',
      ],
      list: [
        'Tell you what personal information we hold about you.',
        'Correct or update information that is inaccurate or incomplete.',
        'Delete your information where we no longer need to keep it.',
        'Withdraw any consent you have given us.',
      ],
      after: ['To make a request or raise a concern about how we handle your information, contact us using the details below.'],
    },
    {
      id: 'children',
      title: 'Children',
      paragraphs: ['This website is intended for businesses and is not directed at children. We do not knowingly collect personal information from children.'],
    },
    {
      id: 'changes',
      title: 'Changes to this policy',
      paragraphs: ['We may update this policy from time to time. The date at the top of this page shows when it was last updated.'],
    },
    {
      id: 'contact',
      title: 'Contact us',
      paragraphs: ['For questions about this policy or your personal information, contact us at:'],
      list: contactLines,
    },
  ],
}

export const cookiePolicy: LegalDoc = {
  path: '/cookie-policy',
  title: 'Cookie Policy | Intellizen Automation Solutions',
  description: 'How the Intellizen Automation Solutions website uses cookies, browser storage and third-party services, and how you can control them.',
  heading: 'Cookie Policy',
  sub: 'How this website uses cookies and browser storage, and how you can control them.',
  updated: '2026-11-14',
  sections: [
    {
      id: 'what-are-cookies',
      title: 'What cookies are',
      paragraphs: [
        'Cookies are small text files that a website or a third-party service saves in your browser. Browser storage, such as local storage, works in a similar way and lets a website remember small pieces of information between visits.',
      ],
    },
    {
      id: 'our-cookies',
      title: 'Cookies and storage we use',
      paragraphs: [
        'This website does not set its own cookies. It saves one small item in your browser’s local storage:',
      ],
      list: [
        'iz-hero-video: remembers which background video was shown on the home page last time, so a different one plays on your next visit. It contains a single number and no personal information.',
      ],
    },
    {
      id: 'third-party-cookies',
      title: 'Third-party services',
      list: [
        'Google Maps: our location map is embedded from Google Maps. When the map loads, Google may set its own cookies, which are covered by Google’s privacy policy.',
        'Google Fonts: fonts are loaded from Google’s servers. This does not set cookies, but Google receives your IP address when the fonts load.',
        'Instagram: links to our Instagram profile do not load any Instagram content on this website until you follow them.',
      ],
    },
    {
      id: 'analytics-and-advertising',
      title: 'Analytics and advertising cookies',
      paragraphs: [
        'We do not currently use analytics or advertising cookies. If we add them in future, for example to measure a marketing campaign, we will update this policy before doing so and ask for your consent where it is required.',
      ],
    },
    {
      id: 'managing-cookies',
      title: 'How to control cookies',
      paragraphs: [
        'You can block or delete cookies and local storage in your browser settings. Most browsers also let you block third-party cookies only. If you block cookies from Google, the embedded map may not load, but the rest of this website will keep working.',
      ],
    },
    {
      id: 'changes',
      title: 'Changes to this policy',
      paragraphs: ['We may update this policy from time to time. The date at the top of this page shows when it was last updated.'],
    },
    {
      id: 'contact',
      title: 'Contact us',
      paragraphs: ['For questions about this policy, contact us at:'],
      list: contactLines,
    },
  ],
}
