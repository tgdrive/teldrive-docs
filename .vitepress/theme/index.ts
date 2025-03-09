import DefaultTheme from 'vitepress/theme'
import './custom.css'
import { h, defineAsyncComponent } from 'vue'
import type { Theme } from 'vitepress'
import { useData } from 'vitepress'

// Lazy-load the SecretGenerator component
const SecretGenerator = defineAsyncComponent(() => 
  import('./components/SecretGenerator.vue')
)

// Add Google Fonts for better typography
const injectGoogleFonts = () => {
  if (typeof document !== 'undefined') {
    const link = document.createElement('link')
    link.rel = 'stylesheet'
    link.href = 'https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap'
    document.head.appendChild(link)
  }
}

// Layout enhancement with possible logo animation
const enhanceAppWithFeatures = ({ app }: { app: any }) => {
  if (typeof window !== 'undefined') {
    injectGoogleFonts()
    
    // Register components
    app.component('SecretGenerator', SecretGenerator)
    
    // Could add additional client-side enhancements here
    // Example: smooth scroll behavior
    document.documentElement.style.scrollBehavior = 'smooth'
    
    // Example: add class for transition enabling
    setTimeout(() => {
      document.body.classList.add('transitions-enabled')
    }, 100)
  }
}

// Extend the default theme
const theme: Theme = {
  extends: DefaultTheme,
  Layout: () => {
    const { isDark } = useData()
    
    return h(DefaultTheme.Layout, null, {
      // Optional slot customizations could go here
      // 'home-features-after': () => h('div', { class: 'custom-layout' }, '...')
    })
  },
  enhanceApp: enhanceAppWithFeatures
}

export default theme
