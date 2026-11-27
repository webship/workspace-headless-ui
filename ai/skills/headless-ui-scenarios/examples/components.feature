Feature: The demo's dialogs, menus and popovers
  Headless UI's own React playground examples in the demo: a dialog named by its title, a drop-down menu and a popover
  named by the button that opens them, each opened, read and closed the way a person does it.

  # The demo template: bash cmd-headless-ui-project.sh huiapp --install

  Scenario: A dialog opened with its button, read, answered with one of its own
    Given I go to "/dialog/dialog"
    When I open the "Deactivate account" dialog with the "Toggle!" button
    Then the "Deactivate account" dialog should be shown
    And the "Deactivate account" dialog should show "Are you sure you want to deactivate your account?"
    When I press "Cancel" in the "Deactivate account" dialog
    Then no dialog should be shown

  Scenario: A dialog closed with Escape, then with a click outside it
    Given I go to "/dialog/dialog"
    When I open the "Deactivate account" dialog with the "Toggle!" button
    And I press Escape in the "Deactivate account" dialog
    Then no dialog should be shown
    When I open the "Deactivate account" dialog with the "Toggle!" button
    And I click outside the "Deactivate account" dialog
    Then no dialog should be shown

  Scenario: A drop-down menu: its items read, the keyboard on one, one chosen
    Given I go to "/menu/menu-with-transition"
    When I open the "Options" drop-down menu
    Then the "Options" drop-down menu should show "Account settings"
    And "New feature (soon)" should be disabled in the "Options" drop-down menu
    When I press the key "ArrowDown"
    Then "Account settings" should be active in the "Options" drop-down menu
    When I choose "License" from the "Options" drop-down menu
    Then no drop-down menu should be shown

  # The plain menu answers each item with window.alert: webship-js's own step accepts it first.
  Scenario: A menu item that answers with an alert
    Given I go to "/menu/menu"
    And I will accept the next dialog
    When I choose "Support" from the "Options" drop-down menu
    Then the "Options" drop-down menu should not be shown

  Scenario: A popover named by its button
    Given I go to "/popover/popover"
    When I open the "Normal" popover
    Then the "Normal" popover should show "Normal - First"
    When I press Escape in the "Normal" popover
    Then no popover should be shown
