# PNExtensionSample
This is a sample of push notifications extensions for iOS 10 that enables:
*creating custom notifications
*comunicate the app and the extension using a shared container
*wake up the app in background mode to run location updates, download information, etc.

*UrbanAirship has been used to generate the pull notifications.

##Notification center
*Using the notification service extension, the push notifications are intercepted before they are delivered to the used, giving the opportunity to change its appearance and content.

##Parameters for push notifications
* alert
* badge
* sound
* content-available: new feature that enables silent push notifications
* mutable-content: content may be modified by the extension

##Communication between the extension and the app
*UserDefaults enables to save parameters that will be accessible for both the app and the extension. In this example, the user chooses whether to accept custom notifications or not. This setting will be stored here so that the extension could decide to intercep the notification from the server or show the original one. 

##Wake up the app
*In order to make us of this feature, content-available parameter must be active. When a new notification is received the app will wake up entering the function application:didReceiveRemoteNotification:fetchCompletionHandler:. 

#App states
* active: The push notification is shown and the method is called
* background: The push notification is shown and the method is called
* suspended: App state changes to Background. The push notification is shown and the method is called
* not running:  The push notification is shown but neither the app will wake up  or the method will be called.
