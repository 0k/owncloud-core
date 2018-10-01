@webUI @insulated
Feature: Add, delete and edit comments in files and folders

  As a user
  I would like to add, delete and edit comments in any file/folder
  So that I can provide more information about the file/folder

  Background:
    Given these users have been created:
      | username |
      | user1    |
      | user2    |
    And the user has browsed to the login page
    And the user has logged in with username "user1" and password "%alt1%" using the webUI
    And the user has browsed to the files page

  Scenario: user adds and deletes comment for a file/folder
    When the user browses directly to display the "comments" details of file "lorem.txt" in folder "/"
    And the user comments with content "lorem ipsum" using the webUI
    Then the comment "lorem ipsum" should be listed in the comments tab in details dialog
    When the user deletes the comment "lorem ipsum" using the webUI
    Then the comment "lorem ipsum" should not be listed in the comments tab in details dialog

  Scenario: Add comment on a shared file and check it is shown in other user's UI
    When the user renames the file "lorem.txt" to "new-lorem.txt" using the webUI
    And the user browses directly to display the "comments" details of file "new-lorem.txt" in folder "/"
    And the user comments with content "lorem ipsum" using the webUI
    And the user shares the file "new-lorem.txt" with the user "User Two" using the webUI
    And the user re-logs in with username "user2" and password "%alt2%" using the webUI
    And the user browses directly to display the "comments" details of file "new-lorem.txt" in folder "/"
    Then the comment "lorem ipsum" should be listed in the comments tab in details dialog
