# Inside Skoop
### An iOS app that allows students to easily find courses to take based on their search criteria as well as leave reviews for future students to see
Developed by Abhi Velaga

### Dependencies:
- Xcode Version 11.4.1 (11E503a)
- Swift 5
- Firebase (installable by running `pod install` in root of project directory)
- iPhone 11 Pro Max simulator
- Build for iOS 13.4

### Instructions for Dr.Bulko:
- Run this with an iPhone 11 Pro Max simulator
- You can sign up with an arbitrary email and password on the settings page in order to have authentication for posting
- You're welcome to post reviews to test the functionality, I'm not going to be using this database for anything else

### Features:
Feature | Description
:---: | :---:
Login | Allows user to create account and login with Firebase
UI | Colors, custom buttons, dark mode, error/success alerts, dynamic content, and navigation 
Settings | Screen to sign up as new user, login, logout and toggle dark mode. All settings save on the device
Search | Custom UI to add search criteria for courses
New reviews | Allows users to write new reviews for a particular class
Drafts | Allows users to save drafts of new reviews on the device to finish later. A draft can be saved for each for unique course
Networking | Makes GET and POST requests with REST API protocol

### Fun fact:
- I'm hosting the backend on a raspberry pi that's sitting at my desk right now :D

![img](https://i.imgur.com/RxmHgYS.jpg)
