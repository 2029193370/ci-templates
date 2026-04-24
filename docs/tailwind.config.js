/**
 * Tailwind v3 config for the landing page.
 *
 * Built by the GitHub Pages workflow (.github/workflows/pages.yml) using
 * the Tailwind standalone CLI, whose release asset is SHA-256 verified before
 * execution. This replaces the runtime `cdn.tailwindcss.com` script the page
 * used to load, which was inappropriate for a repo that pitches supply-chain
 * hygiene to its users.
 */
module.exports = {
  content: ['./*.html'],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter', 'ui-sans-serif', 'system-ui'],
        mono: ['"JetBrains Mono"', 'ui-monospace', 'monospace'],
      },
      colors: {
        brand: {
          50:  '#eef2ff',
          500: '#4f46e5',
          600: '#4338ca',
          700: '#3730a3',
        },
        ink: {
          950: '#0b1020',
          900: '#0f172a',
          800: '#1e293b',
          700: '#334155',
        },
      },
      animation: {
        'fade-up': 'fadeUp .8s ease-out both',
        'blob':    'blob 14s infinite',
      },
      keyframes: {
        fadeUp: {
          '0%':   { opacity: 0, transform: 'translateY(16px)' },
          '100%': { opacity: 1, transform: 'translateY(0)' },
        },
        blob: {
          '0%,100%': { transform: 'translate(0,0) scale(1)' },
          '33%':     { transform: 'translate(30px,-50px) scale(1.1)' },
          '66%':     { transform: 'translate(-20px,20px) scale(.9)' },
        },
      },
    },
  },
};
