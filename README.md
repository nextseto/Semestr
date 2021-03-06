# Semestr

![platforms](https://img.shields.io/badge/platform-ios-lightgrey.svg?style=flat)
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/nextseto/Semestr/master/LICENSE)

**Semestr** keeps track of classes, events, and meetings for students and professors over various semesters in multiple disciplines on their iOS devices running iOS 8+.

## Features
- Can add and delete courses for a named semester
- Can toggle to see specific courses in the week
- Can pull PAWS data and add course information into the application

## Innovative Aspects
This application innovatively uses Core Data to store and manage the data for the user's Course and Semester entries. This application will let users conveniently see their schedules on their phones instead of using a picture of their schedule.

## Install
##### Build Requirements:
- A Macintosh running macOS 10.13 (High Sierra)
- Xcode 9.2+
- A valid iCloud Account
- If testing on device, the device must be running iOS 8+ 

##### How to Install on a iOS device:

1. Download or pull from the repo link above.
2. Open folder called “Semester” and double click on the file called: “Semestr.xcodeproj” with Xcode installed.
3. Press the “Run” button; which is in the upper left corner of Xcode’s window.
4. If asked, enter iCloud credentials, and wait for Xcode to launch the application in the Simulator or on the iOS Device

## Limitations / Known Bugs:
1. Adding, Editing, and deleting individual courses may be buggy. Solution: Add and Delete semesters, not individual courses.
2. All course information can only be added with PAWS due to the bug above.
3. Xcode produces UI suggestion warnings about ‘Main.storyboard’. This should be ignored because things that are not implemented in the storyboard was implemented in the source code.

## Wiki

[Wiki is located here](https://github.com/nextseto/Semestr/wiki)

## License

All source code in **Semestr** is released under the MIT license. See LICENSE for details.