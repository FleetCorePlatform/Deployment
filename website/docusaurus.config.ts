import {themes as prismThemes} from 'prism-react-renderer';
import type {Config} from '@docusaurus/types';
import type * as Preset from '@docusaurus/preset-classic';


const config: Config = {
  title: 'FleetCore Platform',
  tagline: 'Centralized Documentation for the FleetCore Ecosystem',
  favicon: 'img/fleetcore_logo.svg',
  future: {
    v4: true,
  },
  url: 'https://FleetCorePlatform.github.io',
  baseUrl: '/',
  organizationName: 'FleetCorePlatform',
  projectName: 'Deployment',
  onBrokenLinks: 'throw',
  onBrokenAnchors: 'warn',
  markdown: {
    mermaid: true,
  },
  themes: ['@docusaurus/theme-mermaid'],
  i18n: {
    defaultLocale: 'en',
    locales: ['en'],
  },
  presets: [
    [
      'classic',
      {
        docs: {
          sidebarPath: './sidebars.ts',
          editUrl:
            'https://github.com/facebook/docusaurus/tree/main/packages/create-docusaurus/templates/shared/',
        },
        blog: {
          showReadingTime: true,
          feedOptions: {
            type: ['rss', 'atom'],
            xslt: true,
          },
          editUrl:
            'https://github.com/facebook/docusaurus/tree/main/packages/create-docusaurus/templates/shared/',
          onInlineTags: 'warn',
          onInlineAuthors: 'warn',
          onUntruncatedBlogPosts: 'warn',
        },
        theme: {
          customCss: './src/css/custom.css',
        },
      } satisfies Preset.Options,
    ],
  ],

  themeConfig: {
    // image: 'img/docusaurus-social-card.jpg',
    // colorMode: {
    //   respectPrefersColorScheme: true,
    // },
    navbar: {
      title: 'FleetCore Platform',
      logo: {
        alt: 'FleetCore Logo',
        src: 'img/fleetcore_logo.svg',
      },
      items: [
        {
          type: 'docSidebar',
          sidebarId: 'tutorialSidebar',
          position: 'left',
          label: 'Documentation',
        },
        {
          href: 'https://fleetcoreplatform.github.io/FleetCoreLib',
          label: 'API Reference',
          position: 'left',
        },
        {
          href: 'https://github.com/FleetCorePlatform',
          label: 'GitHub',
          position: 'right',
        },
      ],
    },
    footer: {
      style: 'dark',
      links: [
        {
          title: 'Docs',
          items: [
            {
              label: 'Overview',
              to: '/docs/intro',
            },
            {
              label: 'Infrastructure',
              to: '/docs/infrastructure',
            },
          ],
        },
        {
          title: 'Community',
          items: [
            {
              label: 'Discussions',
              href: 'https://github.com/orgs/FleetCorePlatform/discussions',
            },
          ],
        },
        {
          title: 'More',
          items: [
            {
              label: 'GitHub',
              href: 'https://github.com/FleetCorePlatform/Deployment',
            },
          ],
        },
      ],
      copyright: `Copyright © ${new Date().getFullYear()} FleetCore Platform.`,
    },
    prism: {
      theme: prismThemes.github,
      darkTheme: prismThemes.dracula,
    },
  } satisfies Preset.ThemeConfig,
};

export default config;
