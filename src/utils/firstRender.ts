let first = true

export const isFirstRender = () => first

export const endFirstRender = () => {
  first = false
}
