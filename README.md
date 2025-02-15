![Codecov](https://img.shields.io/codecov/c/github/scaleway/scaleway-ui)
![GitHub closed issues](https://img.shields.io/github/issues-closed/scaleway/scaleway-ui)
![dependencies](https://david-dm.org/scaleway/scaleway-ui.svg)
![GitHub release (latest by date)](https://img.shields.io/github/v/release/scaleway/scaleway-ui)

![](.storybook/assets/logo-dark.svg#gh-dark-mode-only)
![](.storybook/assets/logo-light.svg#gh-light-mode-only)

# Scaleway UI library.

---

⚠️ This library is still WIP. We are actively working on it. Our goal is to have an easy to use UI system. This includes an exhaustive documentation, improved DX, confidence in testing and a lot of refactoring to have consistency across our components.

⚠️ We are going to break a lot of things towards V1. This library is not yet production ready.

📝 You can still participate in its development and [start contributing](/CONTRIBUTING.md) to it.

## Quick Start

```sh
$ pnpm add @scaleway/ui @emotion/react @emotion/styled
```

```js
import { theme, normalize, Button } from '@scaleway/ui'
import { Global, css, ThemeProvider } from '@emotion/react'

const App = () => (
  <ThemeProvider theme={theme}>
    <Global styles={css`${normalize()}`}>
    <Button variant="primary" onClick={() => console.log('clicked')}>
      Click Me
    </Button>
  </ThemeProvider>
)
```

N.B. To allow typescript theme typings with `@emotion/styled` components,
you'll have to define the `@emotion/react` module `Theme` interface in your project.

Example, in a `global.d.ts` file:

- Declaration to use the default Scaleway theme

```ts
declare module '@emotion/react' {
  import type { SCWUITheme } from '@scaleway/ui'
  // https://emotion.sh/docs/typescript#define-a-theme
  // eslint-disable-next-line @typescript-eslint/no-empty-interface
  export interface Theme extends SCWUITheme {}
}
```

- Declaration to use your custom theme

```ts
import type { MyTheme } from './src/theme'

declare module '@emotion/react' {
  // https://emotion.sh/docs/typescript#define-a-theme
  // eslint-disable-next-line @typescript-eslint/no-empty-interface
  export interface Theme extends MyTheme {}
}
```

## Development

Before any command, install dependencies running following command:

```sh
$ pnpm install
```

### Storybook

You can easily start Storybook by running:

```sh
$ pnpm run start
```

Storybook documentation will then be available on [http://localhost:6006](http://localhost:6006)

### Test

#### Unit

```sh
$ pnpm run test:unit # Will run all tests
$ pnpm run test:unit:update # Will update all snapshots
$ pnpm run test:unit:watch # Will watch tests and only rerun the one who are modified
$ pnpm run test:unit:coverage # Will generate a coverage report
$ pnpm run testunit::coverage --coverageReporters lcov && open coverage/lcov-report/index.html # Will generate an open an html code coverage report
```

#### Accessibility

```sh
$ pnpm run test:a11y # Will run all accessibility tests
$ pnpm run test:a11y src/components/Alert # Will run accessibility test of Alert component only
```

#### Lint

```sh
$ pnpm run lint
$ pnpm run lint:fix
```

#### Visual

```sh
$ pnpm run test:visual # Build the storybook and launch visual tests
$ pnpm run test:visual:update # Build the storybook, launch visual tests and update screenshots
$ pnpm run test:visual:nobuild # Launch visual tests without (re)building the storybook
```

### Build

```sh
$ pnpm run build
$ pnpm run build:profile # Will open a visual representation of the modules inside the compile package
```

### Use a locally built package

You might want to test your local changes against a React application.

> [`yalc`](https://github.com/whitecolor/yalc) is a tool aiming to simplify working with local npm packages by providing a different workflow than `npm/pnpm link`, hence avoiding most of their issues with module resolving.

```bash
$ pnpm install --global yalc # Make sure to have the yalc binary
```

```bash
$ cd scaleway-ui
$ pnpm run build && yalc publish
$ # Now it's ready to install in your project
$ cd ../project-something
$ yalc add @scaleway/ui
$ cd ../scaleway-ui
$ # If you do some changes into your package
$ pnpm run build && yalc publish --push --sig # --push will automatically update the package on projects where it have been added, --sig updates the signature hash to trigger webpack update
```

> :warning: since [1.0.0.pre.51 (2021-04-23)](https://github.com/wclr/yalc/blob/master/CHANGELOG.md#100pre51-2021-04-23), `yalc publish` needs the `--sig` option to trigger webpack module actual update.

> :warning: `yalc` create a `yalc.lock` and updates the `package.json` in the target project. **Make sure to not commit these changes**

---

### Versioning

We enforce the [conventionnal commits](https://www.conventionalcommits.org) convention in order to infer package bump versions and generate changelog.

Only the `feat`, `fix` and `perf` types will generate a new package on the `main` branch

### Documentation

Checkout our [documentation website](https://main.ui.scaleway.com/).

### Thanks

<a href="https://www.chromatic.com/"><img src="https://user-images.githubusercontent.com/321738/84662277-e3db4f80-af1b-11ea-88f5-91d67a5e59f6.png" width="153" height="30" alt="Chromatic" /></a>

Thanks to [Chromatic](https://www.chromatic.com/) for providing the visual testing platform that helps us review UI changes and catch visual regressions.
