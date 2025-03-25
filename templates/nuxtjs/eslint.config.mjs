import antfu from '@antfu/eslint-config'
import withNuxt from './.nuxt/eslint.config.mjs'

export default withNuxt(
  antfu({
    type: 'app',
    typescript: true,
    unocss: true,
    vue: {
      vueVersion: 3,
    },
    jsonc: true,
    yaml: true,
    formatters: true,
  }),
)
