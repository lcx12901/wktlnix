// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  modules: ['@nuxt/eslint', '@unocss/nuxt'],
  devtools: { enabled: true },
  css: ['@/assets/style/global.scss'],
  compatibilityDate: '2024-11-01',
  eslint: {
    config: {
      standalone: false,
      stylistic: true,
    },
  },
})
