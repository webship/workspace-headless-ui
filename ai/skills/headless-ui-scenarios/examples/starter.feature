Feature: The starter alone
  The demo's starter: a Vite React app with Headless UI and Tailwind CSS 4, whose one page is a form of fields (Field,
  Label, Description, Input, Select and Textarea): sent empty, the required ones are marked invalid and say why;
  filled, none is.

  # The minimal template: bash cmd-headless-ui-project.sh huimin --template minimal --install

  Scenario: The index lists the one page
    Given I go to "/"
    Then I should see "Headless UI demo"
    And I should see "form fields"

  Scenario: A form sent empty marks its fields, then filled marks none
    Given I go to "/ours/form-fields"
    Then no fields should be shown as invalid
    When I press "Send"
    Then 3 fields should be shown as invalid
    And the "Full name" field should show the message "Enter your full name."
    And the "Country" field should show the message "Choose the country we ship to."
    When I fill in "Full name" with "Ada Lovelace"
    And I select "Jordan" from "Country"
    And I fill in "Delivery notes" with "Ring twice, third floor."
    And I press "Send"
    Then no fields should be shown as invalid
    And I should see "Your details were sent."
