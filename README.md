# GitHubSearcher
A Simple iOS Application Demonstrating Usage of GitHub API

## Table of Contents:
1. Features
2. Possible Improments
3. Important Notes

## 1. Features:
* This application uses the GitHub REST API V3 to access information of users and public repos on the GitHub.
* There are two screen built in this application:
   1. Searcher Screen: On this screen, you can type in the searchbar and search for users on GitHub based on their username. Type on one of the cell in the result will bring you to the User Detail Screen.
   2. User Detail Screen: This screen shows the detailed info about the specific user you choose.
* On the backend, this application uses URLSession to deal with all the network tasks and promptly caches the avatar images and updates the UI.

## 2. Possible Improments:
* Implement in-app authentication to authenticate the user to use the GitHub API.

## 3. Important Notes:
* This application requires a GitHub access token to access GitHub data, or you will only have a limited quota. Please follow the following steps to add a token to this application:
  1. [Follow this Guide to create a personal access token](https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line)
  2. Open GitHubSearcher/Constants
  3. Inside Environment, on line 11 `static let apiToken = "token {GitHub Token}"`, replace `{GitHub Token}` with your actual GitHub token
  4. Compile and run the application.
* The console will print out some error messages during runtime. This is due to canceling running `URLSessionDataTask` s. Moving onward, these printout can be intercepted by implementing the `URLSessionTaskDelegate` and implementing the method `urlSession(_:task:didCompleteWithError:)`.
