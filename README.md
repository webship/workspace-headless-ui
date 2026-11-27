<p align="center"><img src="https://raw.githubusercontent.com/webship/workspace-headless-ui/1.0.x/assets/logo.svg" alt="Headless UI logo" width="96"></p>

# @webship.co/workspace-headless-ui

Headless UI for the [Webship Workspace](https://github.com/webship/workspace) dashboard: a builder that makes an app
with Headless UI (the Headless UI step pack's demo, or its starter alone), or takes one from its repository, builds it
and serves its production build from a container of its own, the
[Headless UI step pack](https://github.com/webship/headless-ui-steps) wired into the testing setup of that app, and its
AI items — two agents, a skill, a command and two prompts for building and testing Headless UI apps — each listed in
the workspace folder of its kind.

Headless UI is Tailwind Labs' library of unstyled, accessible components for React and Vue, styled with Tailwind CSS;
an app is a React or Vue app built with Vite. The app brings its own language in its own container. Node.js runs in the
app's container, at the version of the workspace rule (24); the app is made there, built there, and its production
build (`dist/`) is served by Vite's own preview server. Nothing of Node.js, npm or Vite runs on the machine. The app is
the demo of the Headless UI step pack (Headless UI's own React playground examples in a Vite app), its starter alone, or
a Vite app of your own from its repository.

The workspace is container-based (DDEV by default): an app is a row like any other, so the row menus the core draws
(start, stop, launch, backup, clone, remove, tests) work on it; what does not apply to an app without a database is
listed under [What is different from a platform](#what-is-different-from-a-platform). The builder builds on DDEV by
default, and with `--runtime` on Docker Compose, Podman or a Kubernetes cluster: see [Runtimes](#runtimes).

## Use it

```bash
cd ~/workspace
bash core/scripts/plugins.sh --require headless-ui --with-needs     # npm install into the dashboard
bash core/scripts/plugins.sh --activate headless-ui --with-needs    # plugins.headless-ui in settings.yml
bash core/scripts/plugins.sh --install headless-ui                  # the builder, functions, args, AI items
bash core/scripts/plugins.sh --configure headless-ui                # nothing to configure: it has no settings file
```

The same four steps are buttons on the dashboard's **Settings → Plugins** page. `--install` is idempotent.
`--uninstall` removes what it placed; an AI item you edited stays.

Everything the plugin carries lands in the folder it belongs to, when that folder is an active workspace folder:

| What | Lands in |
| --- | --- |
| `cmd-headless-ui-project.sh` | every active sites folder: `dev/`, `test/`, `sandboxes/`, `demos/` |
| The agents `headless-ui-app-builder`, `headless-ui-tester` | `ai-agents/` |
| The skill `headless-ui-scenarios` | `ai-skills/` |
| The command `/headless-ui-test` | `ai-commands/` |
| The prompts `headless-ui-build-and-test`, `headless-ui-scenarios-for-an-app` | `ai-prompts/` |

There they are listed like any other item of the folder, and installed into Claude Code from there.

## What it needs

A workspace starts empty, so the manifest says what else this plugin needs (`needs`):

- one sites folder, for the builder: `dev`, `test`, `sandboxes`, `demos` (`dev` is the one added when none is there). The folder also carries `cmd-tools-testing.sh` and the Users tools this plugin's hooks answer to.
- `ai-agents`, `ai-skills`, `ai-commands` and `ai-prompts`: the AI folders its agents, its skill, its command and its prompts are placed in.

`--require` says so, `--activate` and `--install` stop until the workspace has them, and `--with-needs` adds what is
missing first:

```bash
bash core/scripts/plugins.sh --activate headless-ui --with-needs   # dev and the four AI folders are required, activated and installed first
bash core/scripts/plugins.sh --install headless-ui
```

Everything the builder runs for an app runs in the app's own container, through the container tool the workspace
already needs; the plugin asks for no command of its own on the machine. Making an app downloads the step pack and the
app's packages from the npm registry, and for the demo Headless UI's playground examples from its repository on GitHub,
in the container.

## What the package holds

| Path | What it is |
| --- | --- |
| `commands/cmd-headless-ui-project.sh` | The builder, in the Build list as **Headless UI (Vite app)**, installed into every sites folder |
| `scripts/functions/fun-headless-ui.sh` | The bash functions behind it, sourced by bootstrap once installed; the names the core's tools look for, the plugin's name with its dash as an underscore (`set_headless_ui_users`, `add_headless_ui_users`, `cancel_headless_ui_users`, `testing_configure_headless_ui`) |
| `scripts/args/arg-headless-ui.sh` | Its argparse; the Build form draws the builder's flags from it |
| `testing/site.feature` | The first feature the demo template gets when testing is set up |
| `ai/agents/headless-ui-app-builder.md` | The agent that builds and fixes apps: the build in the container, names a person reads |
| `ai/agents/headless-ui-tester.md` | The agent that writes and runs scenarios with the step pack |
| `ai/skills/headless-ui-scenarios/` | The skill: the step pack's phrases, the traps found on Headless UI's playgrounds, three example features |
| `ai/commands/headless-ui-test.md` | The slash command `/headless-ui-test <app>`: set up when missing, match every step, run, report |
| `ai/prompts/headless-ui-build-and-test.md`, `headless-ui-scenarios-for-an-app.md` | Two prompts: whole launch commands for a new session |
| `src/index.ts` | `register(api)`: what the assistant is told about Headless UI here |
| `features/headless-ui.feature`, `features/headless-ui-runtimes.feature` | Scenarios for the dashboard's own browser suite |

The `workspacePlugin` block in `package.json` is the manifest the installer reads.

## What is different from a platform

| | WordPress (a platform) | Headless UI |
| --- | --- | --- |
| What is built | A WordPress site | A React or Vue app with Headless UI: the step pack's demo, its starter alone, or a Vite app from its repository, its production build served |
| Project | `--project-type=wordpress` | `--project-type=generic --webserver-type=generic`, no database: Vite's own preview server serves the build |
| The language | PHP, in the container tool's image | Node.js 24 in the app's container: DDEV's web container (`--nodejs-version`) on DDEV; on Docker Compose, Podman and Kubernetes the core's language stack (`rt_stack node 24`, Node.js's own image, and `rt_serve`) |
| Recognised by | The project type | On DDEV a file the builder writes, `.ddev/config.headless-ui.yaml` (it also records where the app came from); on another runtime its claim, `platform: headless-ui` in the `x-webship` block of `compose.yaml` |
| Accounts | WP-CLI | None of the workspace's: `--add-users` is taken and adds nothing |
| Testing | The WordPress pack | The Headless UI pack, which finds dialogs, menus, popovers, lists, switches, radio groups, panels, tabs and fields by the names a person reads, and waits for each component's own state and the end of its transitions |

## The commands

Run it from a sites folder. `--help` is safe.

### Build and serve an app

```bash
cd ~/workspace/dev
bash cmd-headless-ui-project.sh huiapp --install                      # a new app: the step pack's demo
bash cmd-headless-ui-project.sh huimin --install --template minimal   # the demo's starter alone: one page
bash cmd-headless-ui-project.sh huiown --install --source https://github.com/<you>/<app>.git --ref main
bash cmd-headless-ui-project.sh huiapp --install --runtime docker     # on Docker Compose instead of DDEV
bash cmd-headless-ui-project.sh huiapp --install --runtime kubernetes # on the workspace's Kubernetes cluster
```

| Flag | What it does |
| --- | --- |
| `--install` | Serve the built app and check that it answers at its address (`https://<name>.ddev.site` on DDEV) |
| `--runtime ddev\|docker\|podman\|kubernetes` | The container runtime to build on (default: DDEV, or `container.runtime` of `settings.yml`); see [Runtimes](#runtimes) |
| `--template demo\|minimal` | The template a new app is made from (default: `demo`, the step pack's demo; `minimal`, its starter alone) |
| `--source <git url>` | A repository of a Headless UI app built with Vite, instead of a new one |
| `--ref <branch or tag>` | A branch or a tag of that repository (default: its default branch) |
| `--path <folder>` | The folder of the app in that repository, for a repository of several apps: only that folder is checked out |
| `--vite-build` | Build an app of your own with Vite alone (`vite build`) instead of its own build script, for a script that needs more of its repository than the app's folder |
| `--add-users` | Taken so that every builder accepts the same flags; the app has no accounts of the workspace's |
| `--launch` | Open the app in a browser when it is ready |

The builder deletes a project of the same name first, then makes a container with Node.js, makes the app in it (or
copies it from its repository), installs its packages, builds it, and with `--install` checks that its server answers
at the app's address.

**The demo template** is the demo of the step pack, taken from its npm package at the release the builder pins
(`@webship-js/headless-ui-steps` 2.0.0) and assembled by the pack's own script (`demo-src/assemble.sh`), as the pack's
CI assembles it: Headless UI 2.2.10's own React playground examples (menus, select lists, search lists, dialogs,
popovers, panels, tabs, switches, radio groups and transitions), copied in unchanged from `playgrounds/react/` of
[github.com/tailwindlabs/headlessui](https://github.com/tailwindlabs/headlessui), each at the path the playground gives
it (`/menu/menu`, `/dialog/dialog`), with an index of them all at `/` and the pack's own page of form fields
(`/ours/form-fields`: a Field with Label, Description and an Input marked invalid, a Select, a Textarea). It is
installed from the demo's own lock and built by Vite (`vite build`). The demo the builder makes is the one that
release's features were proven on. Headless UI's code, its playground's examples among it, is MIT, by Tailwind Labs; it
is fetched in the container at each build. The styles are the playground's own, built with Tailwind CSS 4; nothing
comes from a CDN.

**The minimal template** is the demo's starter alone (`assemble.sh --minimal`): the same Vite React app with Headless UI
2.2.10 and Tailwind CSS 4, with no example, whose one page is the page of form fields. It is installed from the same
lock, so two builds install the same.

**An app of your own** must be a Headless UI app built with Vite, whose packages are its own:

- **Its package manager** is read from its lock file: npm (`package-lock.json`, or none), pnpm or yarn, the last two
  through Node.js's corepack. One installed with Bun is refused, with a message.
- **A folder of a repository of several apps** (`--path`) with no lock file of its own is installed with npm as npm 6
  did (`--legacy-peer-deps`): its repository resolved its packages as a whole, and npm's own resolution would add the
  newest release each peer range allows beside the app's.
- **Its packages in `node_modules`:** Vite builds and serves the app from there. An install that leaves none (Yarn's
  Plug'n'Play) is refused, with a message: set `nodeLinker: node-modules` in its `.yarnrc.yml`.
- **Its build:** its own build script (`npm run build`, or pnpm's or yarn's), which may do more than Vite (code
  generation, its environment), or Vite alone with `--vite-build`, for a script that needs more of its repository than
  the app's folder; either must leave Vite's production build in `dist/` (`dist/index.html`). A build that leaves none
  (another `outDir`) stops with a message; a build script that fails says so, and names `--vite-build`.
- **Refused, with a message:** an app that is not a Headless UI app (neither `@headlessui/react` nor `@headlessui/vue`
  is in its `package.json`), one not built with Vite, and one that takes packages of a workspace of its repository
  (`"workspace:"` in its `package.json`).

The project's folder holds the app's source in `app/` and its production build in `app/dist/`. After a change to the
app, build it again in the container the way the builder did (`npx vite build` for the demo, the starter and
`--vite-build`; `npm run build` for an app of your own) and restart the project, so its server serves the new build:

```bash
cd ~/workspace/dev/huiapp
ddev exec -d /var/www/html/app "npx vite build"
ddev restart
```

**The address.** Vite's preview server answers only the host names it allows: `localhost` and every IP address. On
DDEV the builder adds the project's own host name (`<name>.ddev.site`) to the daemon's command through Vite's
`__VITE_ADDITIONAL_SERVER_ALLOWED_HOSTS`, and `--install` checks that the address is answered rather than refused
(Vite's 403 "Blocked request"). The addresses of Docker Compose, Podman and Kubernetes are IP addresses, which Vite
answers by itself.

### Test an app

```bash
bash cmd-tools-testing.sh huiapp                                  # webship-js, the step pack, a first feature
bash cmd-tools-testing.sh huiapp --run --path tests/features/site.feature
```

The testing setup adds `@webship-js/headless-ui-steps` to the project, lists its step definitions in `cucumber.js`,
and, for the demo template, writes `tests/features/site.feature`. An app of your own gets no first feature: it has its
own names. It changes nothing in a project that is not an app of this builder.

The steps find each component the way a person reads it (a dialog by its title, a menu and a popover by their button,
a field and a list by its label) and wait for what the component says: its ARIA, its state, the end of its
transitions; never a fixed time.

```gherkin
Feature: Deactivate an account
  Scenario: The dialog asks first, and Cancel leaves the account as it was
    Given I go to "/dialog/dialog"
    When I open the "Deactivate account" dialog with the "Toggle!" button
    Then the "Deactivate account" dialog should show "Are you sure you want to deactivate your account?"
    When I press "Cancel" in the "Deactivate account" dialog
    Then no dialog should be shown
```

### Runtimes

The commands are the same on every runtime: the builder speaks DDEV's verbs, and on another runtime the core's layer
(Webship Workspace 1.0.32 or later, webship/workspace#694 and #841) gives each verb its meaning there: the language
stack builds the web image from Node.js's own image at version 24 and starts the app's server in it. The app has no
database, so on Kubernetes it needs core 1.0.35 or newer (webship/workspace#884).

| Runtime | The address of the app | Proven with this builder |
| --- | --- | --- |
| DDEV (the default) | `https://<name>.ddev.site` | Not run yet: the templates take `@webship-js/headless-ui-steps` 2.0.0 from npm |
| Docker Compose (`--runtime docker`) | `http://127.0.0.1:<port>`, a free port kept in `compose.yaml` | Not run yet |
| Podman (`--runtime podman`) | `http://127.0.0.1:<port>` | Not run yet |
| Kubernetes (`--runtime kubernetes`) | `http://<node address>:<NodePort>` | Not run yet |

A project of the builder is known by DDEV's file on DDEV and by its claim on another runtime, so the testing setup,
the Users tools (which say there are no accounts) and the dashboard's row work the same on each. Lando and Docksal are
runtimes of the workspace too, not proven with this builder yet: it says so and stops, before anything is made.

### Users

The app has no accounts of the workspace's. `cmd-tools-add-users.sh <name> headless_ui` and
`cmd-tools-cancel-users.sh <name> headless_ui` say so and change nothing.

## The AI items

| Item | Kind | What it is for |
| --- | --- | --- |
| `headless-ui-app-builder` | agent | Builds and fixes Headless UI apps in their container: the build, names a person reads |
| `headless-ui-tester` | agent | Writes and runs scenarios with the step pack: looks at the pages in the browser first, never sleeps, never names a framework or platform in a step |
| `headless-ui-scenarios` | skill | The step pack's phrases, the traps found on Headless UI's playgrounds, three example features that pass on the demo template and on the starter alone |
| `/headless-ui-test <app>` | command | Sets the pack up when missing, matches every step, runs, reports |
| `headless-ui-build-and-test` | prompt | Builds an app and proves it with its first feature |
| `headless-ui-scenarios-for-an-app` | prompt | Writes and runs the scenarios of one page of an app of the workspace |

Every item says the workspace is container-based (DDEV by default), and the agents and the skill send the reader to
the book *Automated Functional Testing Recipes* first.

## Develop it

```bash
npm install
npm test        # builds, then the unit tests: the manifest, the scripts, the AI items, the needs
npm run lint    # the TypeScript compiler, no output
```

CI runs the same on Node.js 24 and 26, checks that every shell script parses, and runs the plugin's webship-js
features against a dashboard with the plugin installed (the reusable workflow
`webship/workspace/.github/workflows/plugin-browser-suite.yml`). Before the features it builds the app the manifest
names (`featuresSite`: `cmd-headless-ui-project.sh ci-headless-ui --install --runtime docker`), so the scenarios of
`features/headless-ui-runtimes.feature` tagged `@needs-runtime-docker` drive a real app on Docker Compose; the Podman
and Kubernetes ones run where such an app is.
`tests/fixtures/step-definitions.txt` holds the step definitions of the step pack at the version the testing hook pins
and of webship-js, read from their packages: every phrase an AI item shows must match one of them. Refresh it with
`node tests/fixtures/refresh-step-definitions.js` from a project whose testing stack is set up.

## License

ISC (see `LICENSE`).

## Logo

The logo is Simple Icons' Headless UI icon (`icons/headlessui.svg` of simple-icons 16.37.0, CC0-1.0), in the colour
the set lists for the brand (`#66E3FF`); its path is unmodified. It names the library the plugin builds apps with.
Headless UI and its mark are Tailwind Labs'. It is not covered by this package's licence.
