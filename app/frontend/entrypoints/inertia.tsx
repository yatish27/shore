import { createInertiaApp } from "@inertiajs/react";
import { createRoot } from "react-dom/client";

import Home from "@/pages/home/index";
import PostsIndex from "@/pages/posts/index";
import PostsShow from "@/pages/posts/show";
import PostsNew from "@/pages/posts/new";

const pages: Record<string, React.ComponentType<never>> = {
  "home/index": Home,
  "posts/index": PostsIndex,
  "posts/show": PostsShow,
  "posts/new": PostsNew,
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
