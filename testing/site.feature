Feature: The demo's components answer
  As the owner of the app
  I want its dialogs, menus, lists and fields to open, answer and close
  So that a build that came out broken is caught before anything else is tested

  # Placed by the workspace's testing setup for the demo template, as a starting point: it is yours to change. The
  # steps find each component the way a person reads it, and wait for its own state and the end of its transitions.

  @critical
  Scenario: A dialog opened with its button, answered with one of its own
    Given I go to "/dialog/dialog"
    When I open the "Deactivate account" dialog with the "Toggle!" button
    Then the "Deactivate account" dialog should show "Are you sure you want to deactivate your account?"
    When I press "Cancel" in the "Deactivate account" dialog
    Then no dialog should be shown

  @critical
  Scenario: A select list: an option chosen, then the next one at once
    Given I go to "/listbox/listbox-with-pure-tailwind"
    When I choose "Devon Webb" in the "Assigned to" select list
    Then the "Assigned to" select list should show "Devon Webb"
    When I choose "Tom Cook" in the "Assigned to" select list
    Then the "Assigned to" select list should show "Tom Cook"

  Scenario: A drop-down menu opened, read and closed
    Given I go to "/menu/menu-with-transition"
    When I open the "Options" drop-down menu
    Then the "Options" drop-down menu should show "Account settings"
    When I press Escape in the "Options" drop-down menu
    Then no drop-down menu should be shown

  Scenario: The form's fields, sent empty
    Given I go to "/ours/form-fields"
    When I press "Send"
    Then the "Full name" field should show the message "Enter your full name."
    And the "Delivery notes" field should be shown as invalid
