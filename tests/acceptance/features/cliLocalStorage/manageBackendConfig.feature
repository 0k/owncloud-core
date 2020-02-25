@cli @skipOnLDAP @local_storage
Feature: manage backend configuration for a mount using occ command
  As an admin
  I want to configure a local storage mount
  So that I can manage backend configuration for the mount

  Background:
    Given the administrator has created the local storage mount "local_storage2"
    And the administrator has created the local storage mount "local_storage3"
    And the administrator has uploaded file with content "this is a file in local storage2" to "/local_storage2/file-in-local-storage.txt"
    And the administrator has uploaded file with content "this is a file in local storage3" to "/local_storage3/new-file"

  Scenario: manage backend configuration for the applicable users for a local storage mount
    When the administrator configures for the key "ApplicableUsers" with value "all" for the local storage mount "local_storage2"
    And the administrator configures for the key "ApplicableGroups" with value "all" for the local storage mount "local_storage2"
    When the administrator configures for the key "ApplicableUsers" with value "null" for the local storage mount "local_storage3"
    And the administrator configures for the key "ApplicableGroups" with value "null" for the local storage mount "local_storage3"
    And the administrator lists the local storage using the occ command
    Then the following should be included in the configuration of local storage "/local_storage2":
      | configuration           |
      | ApplicableUsers: "all"  |
      | ApplicableGroups: "all" |
    And the following should be included in the configuration of local storage "/local_storage3":
      | configuration            |
      | ApplicableUsers: "null"  |
      | ApplicableGroups: "null" |
