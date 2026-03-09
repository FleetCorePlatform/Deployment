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
  baseUrl: '/Deployment/',
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
    colorMode: {
      respectPrefersColorScheme: true,
    },
    navbar: {
      title: 'FleetCore Platform',
      logo: {
        alt: 'FleetCore Logo',
        src: 'img/fleetcore_logo.svg',
      },
      items: [
        {
          type: 'docSidebar',
          sidebarId: 'sidebar',
          position: 'left',
          label: 'Documentation',
        },
        {
          href: 'https://github.com/FleetCorePlatform',
          label: 'GitHub',
          position: 'right',
        },
      ],
    },
    footer: {
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
            {
              label: 'Roadmap',
              href: 'https://github.com/orgs/FleetCorePlatform/projects/1',
            },
          ],
        },
        {
          title: 'Projects',
          items: [
            {
              label: 'Desktop Client',
              href: 'https://github.com/FleetCorePlatform/FleetCoreDesktop',
            },
            {
              label: 'Backend',
              href: 'https://github.com/FleetCorePlatform/FleetCoreServer',
            },
            {
              label: 'Drone Agent',
              href: 'https://github.com/FleetCorePlatform/OnboardAgent',
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
