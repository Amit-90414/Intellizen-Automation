import { lazy, type ComponentType } from 'react'

type Module<P> = { default: ComponentType<P> }

export function lazyPage<P extends object>(load: () => Promise<Module<P>>) {
  let Loaded: ComponentType<P> | null = null

  const preload = () =>
    load().then((module) => {
      Loaded = module.default
      return module
    })

  const Lazy = lazy(preload)

  function Page(props: P) {
    return Loaded ? <Loaded {...props} /> : <Lazy {...props} />
  }

  Page.preload = preload
  return Page
}
