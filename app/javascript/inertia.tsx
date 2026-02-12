import { createInertiaApp } from "@inertiajs/react";
import { createRoot } from "react-dom/client";

import Home from "@/pages/Home";

const pages: Record<string, React.ComponentType<never>> = {
  Home,
};

createInertiaApp({
  resolve: (name) => {
    const page = pages[name];
    if (!page) {
      throw new Error(`Page not found: ${name}`);
    }
    return page;
  },
  setup({ el, App, props }) {
    createRoot(el).render(<App {...props} />);
  },
});
