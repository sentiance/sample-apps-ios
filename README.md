# Sample iOS Application

This is a sample application to demonstrate how to integrate the Sentiance iOS SDK.

## What's in this?

In this sample application we cover 

1. SDK Integration - without user linking
1. SDK Integration - with [user linking](https://docs.sentiance.com/important-topics/user-linking-2.0)
1. SentianceHelper.swift file - helper methods for quick and easy SDK integration

## Where to Start?

There are two places you need to look at 

1. `SentianceHelper.init` in the `AppDelegate.swift`
1. `SentianceHelper.createUser` in the `Controllers/HomeViewController.swift`

### SentianceHelper.init

This ensures that your application can continue detections while it is in the background.

### SentianceHelper.createUser

You should call `SentianceHelper.createUser` when you are ready for the SDK to start detections. Usually you would want to call this method on user login / user registration or at the particular flow in your application where you want to start detections.

### SentianceHelper.swift file

For a quick and easy start to the SDK integration we have created a helper file with the basic functionality. Just copy the `Helpers/SentianceHelper.swift` file and place it in your codebase.

## Sample App Dependency

As you can see the `createUser` method requires SDK credentials, and we recommend that you _don't_ store the credentials in the application codebase. Therefore we created a **sample api server** < insert link here > which returns the SDK credentials. 

This **sample api server** also demonstrates the **user linking** workflow as well.

_Ensure the sample api server is running before launching the sample app._

----

If you have any queries please write to support@sentiance.com or create a Github issue and we shall help you out!