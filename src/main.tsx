import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import { BrowserRouter } from 'react-router'
import './styles/tokens.css'
import './styles/global.css'
import App from './App.tsx'
import { preloadRoute } from './routes'

const start = () => {
  for (const node of document.querySelectorAll('[data-prerender]')) node.remove()

  createRoot(document.getElementById('root')!).render(
    <StrictMode>
      <BrowserRouter>
        <App />
      </BrowserRouter>
    </StrictMode>,
  )
}

preloadRoute(window.location.pathname).then(start, start)
