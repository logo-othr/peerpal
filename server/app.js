const admin = require('firebase-admin');
const serviceAccount = require("./firebase_admin_sdk.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

/**
 * This clss initializes Firebase Admin SDK using a service account and sets up various notification observers by importing
 * and invoking observer functions from the chat, friends, activities, deviceToken, and publicUserData modules. 
 * Each module handles specific functionalities, such as managing chat notifications, friend requests, activity updates, device tokens, and user data updates.
 */

//import .js files
const chat = require("./chat");
const friends = require("./friends");
const activities = require("./activities");
const deviceToken = require("./device_token");
const publicUserData = require("./publicUserData");

//chat
chat.chatRequestResponseObserver();
chat.chatNotificationObserver();

//friends
friends.friendRequestNotificationObserver();
friends.friendRequestResponseObserver();
friends.canceledFriendRequestsObserver();
//friends.deleteFriendObserver();

//activites
activities.activityNotificactionObserver();
activities.updateActivityObserver();
activities.joinActivityObserver();
activities.leaveActivityObserver();
activities.deleteActivityObserver();

//deviceToken
deviceToken.deleteDeviceTokenObserver();
deviceToken.updateDeviceTokenObserver();

//publicUserData
publicUserData.updateNameObserver();