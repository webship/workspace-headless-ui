Feature: The demo's lists, switches, panels and tabs
  Headless UI's own React playground examples in the demo: a select list and a search list named by their label, a
  switch turned on and off, a panel expanded, and tabs switched, each read from the state Headless UI writes on it.

  # The demo template: bash cmd-headless-ui-project.sh huiapp --install

  Scenario: A select list: what it offers, an option chosen, then another
    Given I go to "/listbox/listbox-with-pure-tailwind"
    Then the "Assigned to" select list should offer "Devon Webb"
    When I choose "Devon Webb" in the "Assigned to" select list
    Then the "Assigned to" select list should show "Devon Webb"
    When I choose "Tom Cook" in the "Assigned to" select list
    Then the "Assigned to" select list should show "Tom Cook"

  Scenario: A search list: typed in, what it offers, a choice
    Given I go to "/combobox/combobox-with-pure-tailwind"
    When I type "wa" in the "Assigned to" search list
    Then the "Assigned to" search list should offer "Wade Cooper"
    And the "Assigned to" search list should not offer "Tom Cook"
    When I type "wa" in the "Assigned to" search list and choose "Wade Cooper"
    Then the "Assigned to" search list should show "Wade Cooper"

  Scenario: A switch turned on and off
    Given I go to "/switch/switch-with-pure-tailwind"
    Then the "Enable notifications" switch should be turned off
    When I turn on the "Enable notifications" switch
    Then the "Enable notifications" switch should be turned on
    When I turn off the "Enable notifications" switch
    Then the "Enable notifications" switch should be turned off

  Scenario: A panel expanded, and tabs switched
    Given I go to "/disclosure/disclosure"
    When I expand the "Trigger" panel
    Then the "Trigger" panel should be expanded
    And the "Trigger" panel should show "Content"
    Given I go to "/tabs/tabs-with-pure-tailwind"
    Then the "Team Members" tab should be active
    And the "Company" tab should be disabled
    When I switch to the "Billing" tab
    Then the "Billing" tab should be active
    And the "Billing" tab should show "Tab content for billing"
