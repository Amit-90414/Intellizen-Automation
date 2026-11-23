import { site, siteUrl, social } from './site'

export const organizationId = `${siteUrl}/#organization`
export const businessId = `${siteUrl}/#business`
export const websiteId = `${siteUrl}/#website`

export const organization = {
  '@type': 'Organization',
  '@id': organizationId,
  name: site.name,
  url: siteUrl,
  logo: `${siteUrl}/assets/brand/logo-color.png`,
  email: site.emails,
  telephone: site.phones.map((phone) => phone.tel),
  taxID: site.gstin,
  sameAs: social.map((profile) => profile.href),
}

export const localBusiness = {
  '@type': 'LocalBusiness',
  '@id': businessId,
  name: site.name,
  url: siteUrl,
  image: `${siteUrl}/assets/products/industrial-robotics/render-1.jpg`,
  logo: `${siteUrl}/assets/brand/logo-color.png`,
  email: site.emails[0],
  telephone: site.phones[0].tel,
  taxID: site.gstin,
  address: {
    '@type': 'PostalAddress',
    streetAddress: 'Plot No 250, Village Kuranwala, Hansa Industrial Park',
    addressLocality: 'Derabassi',
    addressRegion: 'Punjab',
    postalCode: '140501',
    addressCountry: 'IN',
  },
  hasMap: site.mapsUrl,
  sameAs: social.map((profile) => profile.href),
  parentOrganization: { '@id': organizationId },
}

export const website = {
  '@type': 'WebSite',
  '@id': websiteId,
  url: siteUrl,
  name: site.name,
  inLanguage: 'en-IN',
  publisher: { '@id': organizationId },
}

export const breadcrumbs = (items: { name: string; path: string }[]) => ({
  '@type': 'BreadcrumbList',
  itemListElement: items.map((item, i) => ({ '@type': 'ListItem', position: i + 1, name: item.name, item: siteUrl + item.path })),
})

export const faqPage = (items: { q: string; a: string }[]) => ({
  '@type': 'FAQPage',
  mainEntity: items.map((item) => ({ '@type': 'Question', name: item.q, acceptedAnswer: { '@type': 'Answer', text: item.a } })),
})

export const graph = (...nodes: object[]) => ({ '@context': 'https://schema.org', '@graph': nodes })

export const home = { name: 'Home', path: '/' }
