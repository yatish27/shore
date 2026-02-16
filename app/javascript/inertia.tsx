import { createInertiaApp } from "@inertiajs/react";
import { createRoot } from "react-dom/client";

import Home from "@/pages/Home";
import PostsIndex from "@/pages/Posts/Index";
import PostsShow from "@/pages/Posts/Show";
import PostsNew from "@/pages/Posts/New";

const pages: Record<string, React.ComponentType<never>> = {
  Home,
  "Posts/Index": PostsIndex,
  "Posts/Show": PostsShow,
  "Posts/New": PostsNew,
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
