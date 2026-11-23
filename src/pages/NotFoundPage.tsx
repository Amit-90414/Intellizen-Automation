import { useLocation } from 'react-router'
import { PageHero } from '../components/blocks/PageHero/PageHero'
import { MiniCube } from '../components/three-d/MiniCube/MiniCube'
import { Button } from '../components/ui/Button/Button'
import { Seo } from '../components/ui/Seo/Seo'
import { copy, site } from '../data/site'
import styles from './NotFoundPage.module.css'

export default function NotFoundPage() {
  const { pathname } = useLocation()
  const { notFound } = copy

  return (
    <>
      <Seo title={`${notFound.title} | ${site.name}`} description={notFound.sub} path={pathname} noindex />
      <PageHero
        size="small"
        title={notFound.title}
        subtitle={notFound.sub}
        before={<MiniCube size={56} className={styles.cube} />}
        actions={
          <>
            <Button to="/">{notFound.home}</Button>
            <Button to="/products" variant="ghost">
              {notFound.products}
            </Button>
          </>
        }
      />
    </>
  )
}
