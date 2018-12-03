# MindSafe Application 

Mindsafe is an all-in-one application with four main functions: safety of the user using geofencing technology, in addition to other safety features utilizing location services, mental training in the form of Episodic and Semantic exercises, an Alzheimer’s specific notification system which is aimed at combating the effects of sundowning, and daily analytical progress updates to caregivers and loved ones. Mindsafe’s main purpose is to provide peace of mind. This application helps users that suffer first hand from Alzheimer’s to better manage their lives and track their disease, while allowing their caregivers and loved ones to follow their daily progress. Mindsafe has a simplistic user interface design and features, which provides ease of use for the elderly, and users with varying levels of educational backgrounds.

## Getting Started

These instructions will provide you a copy of the project functioning on your local machine for development and testing purposes. 

### Prerequisites
 * Xcode 10.0 / Swift 4.0 and above
 * iOS >= 9.0
 * macOS >= 10.13.0
 * CocoaPods (Fix for library compiling errors)


### Installing

The MindSafe application requires Xcode version 10 and above. Xcode versions can be obtained through Apple website or Mac App Store.

To copy the project to local machine, go to the terminal and redirect to the desired directory, then copy this command in the terminal and execute

```
git clone -b Mihai https://github.com/mihailapuste/mindsafe
```

Another method would be to download the Zip through github and extract the files to desired location

## Starting the Application

The application workspace can be found in the mindsafe folder which was cloned in the previous step. Opening mindsafe.xcworkspace will open up Xcode where the run button can be pressed to execute the app.


## Firebase Database 
The application interacts with Realtime Database from Firebase.
To view this interaction, enter mindsafe14@gmail.com and mgroup14 as the user and password for Firebase. To observe data insertion in real time, use the application memory activities and complete until score given.


## Running the tests

To run automated test, on the project file tab in Xcode select the "Show the test navigator" tab and click on the arrows beside the Testing folders. This will compile the project and automate the testing process through the Xcode simulator.


## Troubleshooting
Unable to compile because of pod libraries?
Follow the steps below

1. Open the terminal and type:
```
sudo gem install cocoapods-clean
```
This will install Gem into Ruby residing in System library.

2. Then open the mindsafe directory which was cloned in the previous steps

3. Then delete and clean all the pod libraries by typing in terminal:
```
pod deintegrate
```
Then
```
pod clean
```
4. Install pod libraries into the project by typing in terminal:

```
pod install
```

## Features

Core features:
* Semantic Memory Exercise
* Episodic Memory Exercise
* Application User Reminders and Notification
* Geofence Tracker
* Progress Viewer

## Authors

List of members who contributed to this project
* Mihai Lapuste
* Oleg Strbac
* Bob Liu
* Milos Ratkovic
* Elvira Huang
* Puru Chaudhary



