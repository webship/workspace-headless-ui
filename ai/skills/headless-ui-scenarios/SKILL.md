---
name: headless-ui-scenarios
description: Write and fix webship-js scenarios for a Headless UI app with the Headless UI step pack (`@webship-js/headless-ui-steps`) in the Webship Workspace — the pack's phrases for dialogs, side panels, drop-down menus, popovers, select lists and search lists, fields, switches, radio groups, panels and tabs, how the steps name things (a dialog by its title, a menu and a popover by their button, a field and a list by its label), the waits built into them, the traps found on Headless UI's own playgrounds, and three example features that pass. Use when writing a feature for a Headless UI app, choosing the phrase for a dialog, a menu or a list, or reading why a Headless UI scenario failed.
---

# headless-ui-scenarios

Scenarios for Headless UI apps in a Webship Workspace (`~/workspace`), a container-based workspace (DDEV by default),
with webship-js and [`@webship-js/headless-ui-steps`](https://github.com/webship/headless-ui-steps). An app of the
Headless UI builder (`cmd-headless-ui-project.sh`) gets the pack with `bash cmd-tools-testing.sh <app>`; the suite runs
in the app's container (`bash cmd-tools-testing.sh <app> --run`).

Headless UI's components are unstyled: what a person reads is their ARIA (a dialog's title, a menu's button, a list's
label) and their state, which Headless UI writes on them (`data-headlessui-state`: open, active, selected, checked,
disabled), and their transitions are the app's own classes. The steps find each component by its name and wait for what
it says: its role, its state, the end of its transitions. They never wait a fixed time. The same steps read the React
line (2.x) and the Vue line (1.7).

## The phrases

Check them against the installed pack before you use them
(`grep -hE "^(Given|When|Then)\(" node_modules/@webship-js/headless-ui-steps/tests/step-definitions/*.steps.js`).

**Dialogs, side panels, drop-down menus, popovers**: a dialog by its title, a menu and a popover by their button.

```gherkin
When I open the "Deactivate account" dialog with the "Toggle!" button
Then the "Deactivate account" dialog should show "Are you sure you want to deactivate your account?"
When I press "Cancel" in the "Deactivate account" dialog
When I press Escape in the "Deactivate account" dialog
When I click outside the "Deactivate account" dialog
Then no dialog should be shown
When I open the "Options" drop-down menu
Then "New feature (soon)" should be disabled in the "Options" drop-down menu
When I choose "License" from the "Options" drop-down menu
When I open the "Normal" popover
Then the "Normal" popover should show "Normal - First"
When I wait for the transitions to finish
```

**Select lists, search lists, fields**: a list and a field by its label.

```gherkin
When I choose "Devon Webb" in the "Assigned to" select list
Then the "Assigned to" select list should show "Devon Webb"
Then the "Assigned to" select list should not offer "Nobody at all"
When I type "wa" in the "Assigned to" search list and choose "Wade Cooper"
Then the "Assigned to" search list should show "Wade Cooper"
Then 3 fields should be shown as invalid
Then the "Full name" field should show the message "Enter your full name."
```

**Switches, radio groups, panels, tabs**: a switch by its label, a radio group by its legend.

```gherkin
When I turn on the "Enable notifications" switch
Then the "Enable notifications" switch should be turned on
When I choose "Private to Project Members" in the "Privacy setting" radio group
Then "Private to Project Members" should be chosen in the "Privacy setting" radio group
When I expand the "Trigger" panel
Then the "Trigger" panel should show "Content"
When I switch to the "Billing" tab
Then the "Company" tab should be disabled
```

webship-js's own steps still go to an address (`Given I go to "/ours/form-fields"`), read the page (`Then I should
see "Headless UI demo"`), fill in fields (`When I fill in "Full name" with "…"`), choose in a native select list
(`When I select "Jordan" from "Country"`) and press buttons (`When I press "Send"`).

## The traps

- **The page behind an open dialog is out of reach.** Headless UI makes the app's root `inert` and `aria-hidden` while
  a dialog is open: what is behind it has no role for a screen reader or for a role query. The pack's steps look inside
  the dialog; close it before a step of webship-js reads the page. A menu, a list and a popover leave the page alone.
- **A select list is named by its label and its value.** Headless UI names a list's button by its label and the option
  it shows ("Assigned to Wade Cooper"): the pack finds it by its label alone, a colon after it aside. A webship-js step
  that matches the whole name does not.
- **A search list's label names more than its input.** Type in it with the pack's step (`When I type "wa" in the
  "Assigned to" search list`), which finds its input by role; webship-js's `I fill in` can find more than one control.
- **A popover's and a panel's content has no role**, and so no name: the pack finds it through the button that opens it
  (its `aria-controls`). Open it with the pack's step before reading it.
- **A dialog's own element can have no box** (its panel and backdrop are fixed to the window), and a dialog with no
  `DialogTitle` has no name: the pack reads it as shown when a child of it is, and names it by its heading.
- **A menu item can answer with an alert** (`window.alert`): accept it first, with webship-js's own
  `Given I will accept the next dialog`, or the page waits on it.
- **A disabled tab can say so after its name** ("Company(disabled)"): the pack finds a tab by its name, else by the
  start of its text.
- **An app's own console error is reported**, and fails the scenario where the suite asks for that (its
  `javascript.mode` set to `fail`, or the scenario tagged `@js-fail`). One a component logs (React's warning about an
  input going from uncontrolled to controlled, in a radio group that starts with no choice) is the app's: tag that
  scenario `@js-warn`, say why in a comment, and fix the app if it is yours.
- **A value picked at random on each load** (an example's first choice made with `Math.random()`) is never asserted:
  the scenario reads only what it chose.
- **No fixed waits.** The steps wait on the components' own signals; a Then step waits for what it expects.

## The examples

Three features that pass, each against the app it names:

- [`examples/components.feature`](examples/components.feature): the demo template
  (`bash cmd-headless-ui-project.sh huiapp --install`): a dialog opened, answered and closed, a drop-down menu with the
  keyboard on it, and a popover.
- [`examples/lists.feature`](examples/lists.feature): the same app: a select list, a search list, a switch, a panel and
  tabs.
- [`examples/starter.feature`](examples/starter.feature): the demo's starter alone
  (`bash cmd-headless-ui-project.sh huimin --template minimal --install`), its one page: a form whose fields are marked
  invalid, then filled.

## The book

For any automated functional testing in this work (a Gherkin feature, a step definition, choosing a
step, a test run and its failures), read the book *Automated Functional Testing Recipes* first.

- **Where.** Use the first that exists: `.claude/automated-functional-testing-recipes/` in the project,
  `~/.claude/automated-functional-testing-recipes/` (installed by webship/webship-js-ai-agent,
  webship/webship-js-skills or webship/ai-agents), or
  https://github.com/webship/webship-js-ai-agent/tree/2.0.x/automated-functional-testing-recipes
- **How.** Its `README.md` first, then the chapter that matches the task (one file per chapter,
  named by its subject), not the single complete file.
- **Which wins.** The installed webship-js package and the step pack are the source of truth for
  step phrasing. When they differ from the book, follow them and say so.
- **For Headless UI.** Start with `ch08-modal-dialog-testing.md` (dialogs and side panels, opened, answered and
  closed), `ch07-waiting-dynamic-content.md` (why a wait names its signal, never a time),
  `ch06-form-testing-recipes.md` (fields, select lists, switches and radio groups) and
  `ch15-accessibility-testing.md` (names a person reads).
