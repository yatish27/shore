import { defineConfig } from "vite";
import { resolve } from "path";
import ViteRails from "vite-plugin-rails";

export default defineConfig({
  plugins: [
    ViteRails({
      envVars: { RAILS_ENV: "development" },
      envOptions: { defineOn: "import.meta.env" },
      fullReload: {
        additionalPaths: ["config/routes.rb", "app/views/**/*"],
        delay: 300,
      },
    }),
  ],
  build: { sourcemap: false },
  resolve: {
    alias: {
      "@assets": resolve(__dirname, "app/frontend"),
    },
  },
});
