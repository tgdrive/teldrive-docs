import { defineConfig } from 'vitepress'

export default defineConfig({
  lang: "en-US",
  title: "Teldrive",
  description: "Teldrive is a powerful utility that enables you to organize your Telegram files and much more",
  lastUpdated: true,
  ignoreDeadLinks: true,
  cleanUrls: true,
  sitemap: {
    hostname: 'https://teldrive-docs.pages.dev'
  },
  themeConfig: {
    logo: '/images/logo.png',
    siteTitle: 'Teldrive',
    socialLinks: [
      { icon: 'github', link: 'https://github.com/tgdrive/teldrive' },
      { icon: 'discord', link: 'https://discord.gg/8QAeCvTK7G' },
    ],
    editLink: {
      pattern: 'https://github.com/tgdrive/teldrive-docs/edit/main/:path',
      text: 'Edit this page on GitHub',
    },
    footer: {
      message: 'Released under the MIT License.',
    },
    nav: [
      { text: 'Home', link: '/' },
    ],

    sidebar: [
      {
        text: 'Getting Started',
        collapsed: false,
        items: [
          { text: 'Prerequisites', link: '/docs/getting-started/prerequisites.md' },
          { text: 'Installation', link: '/docs/getting-started/installation.md' },
          { text: 'Usage', link: '/docs/getting-started/usage.md' },
          { text: 'Advanced Usage', link: '/docs/getting-started/advanced.md' },
        ]
      },
      {
        text: 'Guides',
        collapsed: false,
        items: [
          { text: 'Deploy with Caddy and Cloudflare', link: '/docs/guides/caddy-cloudflare.md' },
          { text: 'Deploy with Nginx', link: '/docs/guides/nginx-setup.md' },
          { text: 'Deploy with Traefik', link: '/docs/guides/traefik-setup.md' },
          { text: 'Database Backup', link: '/docs/guides/db-backup.md' },
          { text: 'Setup with Rclone', link: '/docs/guides/rclone.md' },
          { text: 'Use with Media Servers', link: '/docs/guides/jellyfin.md' },
        ]
      },
      {
        text: 'CLI Options',
        collapsed: false,
        items: [
          { text: 'run', link: '/docs/cli/run.md' },
          { text: 'check', link: '/docs/cli/check.md' },
        ]
      },
      {
        text: "API Reference",
        link: "/docs/api",
        rel:"noopener noreferrer",
        target:"_blank"
      },
    ],
    
  },
  head: [
    [
      'meta',
      {
        property: 'og:image',
        content: '/images/logo.png',
      },
    ],
    ['meta', { property: 'og:type', content: 'website' }],
    ['meta', { property: 'twitter:domain', content: 'teldrive-docs.pages.dev' }],
    [
      'meta',
      {
        property: 'twitter:image',
        content: '/images/logo.png',
      },
    ],
    [
      'meta',
      { property: 'twitter:card', content: 'summary_large_image' },
    ],
    ['link', { rel: 'shortcut icon', href: '/favicon.ico' }],
  ],
  vite:{
    
  }
})
