import { createInertiaApp } from "@inertiajs/react"
import { createRoot } from "react-dom/client"

createInertiaApp({
  resolve: (name) => {
    const pages = import.meta.glob("../pages/**/*.tsx", { eager: true })
    const page = pages[`../pages/${name}.tsx`]
    if (!page) {
      throw new Error(
        `Missing Inertia page component: '${name}.tsx'. ` +
          `Resolved pages: ${Object.keys(pages).join(", ")}`,
      )
    }
    return page
  },
  setup({ el, App, props }) {
    createRoot(el).render(<App {...props} />)
  },
})
