console.log("Executing push_notification.js")

const admin = require('firebase-admin');
const db = admin.firestore();
const contracts = require("./contracts");
const outputs = require("./outputs");
// https://momentjs.com/docs/#/displaying/format/
const moment = require('moment');

var deviceTokens = new Map();
var publicUserData = new Map();


/**
 * Handles incoming document changes and triggers push notifications based on the specified use case.
 * Retrieves the sender's username from a local cache or the database if not found in the cache.
 * Delegates the notification creation to specific use case handlers to ensure the correct notification is sent.
 * 
 * @param {String} useCase 
 * @param {Object} change 
 * 
 */
function pushNotificationHandler(useCase, change) {
    var document = change.doc;
    var documentData = document.data();

    if (publicUserData.has(documentData.fromId)) {
        if (publicUserData.get(documentData.fromId) == null || publicUserData.get(documentData.fromId) == undefined) {
            outputs.noUserNameExistsInformation();
        } else {
            var userName = publicUserData.get(documentData.fromId);
            if (userName != contracts.DEFAULT_STRING && userName != null && userName != undefined) {
                getNotificationUseCase(useCase, change, userName);
            }
            else {
                outputs.noUserNameExistsInformation();
            }
        }
    }
    else {
        db.collection(contracts.PUBLIC_USER_DATA_COLLECTION).doc(documentData.fromId).get()
            .then(doc => {

                var publicUserDataDoc = doc;
                var publicUserDataDocData = publicUserDataDoc.data();
                var userName = publicUserDataDocData.name;

                publicUserData.set(publicUserDataDoc.id, publicUserDataDocData.name);

                if (userName != contracts.DEFAULT_STRING && userName != null && userName != undefined) {
                    getNotificationUseCase(useCase, change, userName);
                }
                else {
                    outputs.noUserNameExistsInformation();
                }
            })
            .catch(error => { outputs.databaseErrorInformationForDocument(contracts.READING, contracts.PUBLIC_USER_DATA_COLLECTION, arrayName = contracts.DEFAULT_STRING, error) })
    }
}

/**
 * Determines the appropriate notification payload based on the provided use case and sends the notification.
 * Handles various notification types such as chat messages, chat requests, friend requests, activity invitations, and activity reminders.
 * Utilizes helper functions to construct and send the notification payload to the intended recipients.
 * 
 * @param {String} useCase 
 * @param {Object} change 
 * @param {String} userName 
 * @param {List<String>} invitationIds 
 * @param {List<String>} attendeeIds 
 * 
 */
function getNotificationUseCase(useCase, change, userName, invitationIds = [], attendeeIds = []) {

    var document = change.doc;
    var documentData = document.data();

    switch (useCase) {
        case contracts.CHAT_MESSAGE_USECASE:
            var userId = documentData.fromId
            var title = contracts.getChatNotificationTitle(userName);
            var body = documentData.message;

            var notificationPayload = payload(title, body, userId, contracts.TYPE_CHAT);
            getDataForPushNotification(change, payload)
            break;
        case contracts.CHAT_REQUEST_USECASE:
            var userId = documentData.fromId
            var title = contracts.CHAT_REQUEST_TITLE;
            var body = contracts.getChatRequestBody(userName);

            var notificationPayload = payload(title, body, userId, contracts.TYPE_CHAT_REQUEST);
            getDataForPushNotification(change, payload)
            break;
        case contracts.FRIEND_REQUEST_USECASE:
            var userId = documentData.fromId
            var title = contracts.FRIEND_REQUEST_NOTIFICATION_TITLE;
            var body = contracts.getFriendRequestBody(userName);

            var notificationPayload = payload(title, body, userId, contracts.TYPE_FRIEND_REQUEST);
            getDataForPushNotification(change, notificationPayload)
            break;
        case contracts.ACTIVITY_INVITATION_USECASE:
            var activityId = documentData.id;
            var title = contracts.ACTIVITY_INVITE_TITLE;
            var body = contracts.getActivityInviteBody(userName);

            var notificationPayload = payload(title, body, activityId, contracts.TYPE_ACTIVITY_INVITATION);
            sendPushNotificationsForActivityInvitation(notificationPayload, invitationIds);
            break;
        case contracts.ACTIVITY_REMINDER_USERCASE:
            var activityId = documentData.id;
            var activityName = documentData.name.replace(/\u00ad/g,'');
            var activityDate = moment(documentData.date).format("DD.MM.YYYY, HH:mm");
            console.log(activityDate);
            var title = contracts.ACTIVITY_REMINDER_TITLE;
            var body = contracts.getActivityReminderBody(activityName, activityDate);

            var notificationPayload = payload(title, body, activityId, contracts.TYPE_ACTIVITY_REMINDER);
            sendActivityReminderPushNotifications(notificationPayload, attendeeIds);
            break;
        default:
            outputs.noUseCaseExistsInformation(useCase);
    }

    /**
     * Constructs the payload for the push notification.
     * 
     * @param {String} title 
     * @param {String} body 
     * @param {String} id 
     * @returns payload
     * 
     */
    function payload(title, body, id = contracts.NO_ID_SPECIFIED, type = contracts.NO_TYPE_SPECIFIED) {
        return payload = {
            notification: {
                title: title,
                body: body,
            },
            data: {
                type: type,
                id: id,
                click_action: contracts.FLUTTER_NOTIFICATION_CLICK
            }
        }
    }
}

/**
 * Retrieves the device token for the recipient and sends the push notification.
 * Checks the local cache for the device token; if not found, retrieves it from the database.
 * Sends the push notification to the device if the token is available, otherwise logs the appropriate error.
 * 
 * @param {Object} change 
 * @param {payload} payload 
 * 
 */
function getDataForPushNotification(change, payload) {

    var document = change.doc;
    var documentData = document.data();

    if (deviceTokens.has(documentData.toId)) {
        if (deviceTokens.get(documentData.toId) == null || deviceTokens.get(documentData.toId) == undefined) {
            outputs.noDeviceTokenExistsInformation();
        } else {
            var deviceToken = deviceTokens.get(documentData.toId);
            outputs.deviceTokenFromUserInformation(deviceToken, documentData.toId);
            sendPushNotificationToDevice(deviceToken, payload);
        }
    }
    else {
        db.collection(contracts.PRIVATE_USER_DATA_COLLECTION).doc(documentData.toId).get()
            .then(doc => {
                var privateUserDataDoc = doc;
                var privateUserData = privateUserDataDoc.data();

                var deviceToken = privateUserData.pushToken;
                deviceTokens.set(privateUserDataDoc.id, deviceToken);
                if (deviceToken == null || deviceToken == undefined) {
                    outputs.noDeviceTokenExistsInformation();
                }
                else {
                    outputs.deviceTokenFromUserInformation(deviceToken, privateUserData.id)
                    sendPushNotificationToDevice(deviceToken, payload);
                }
            })
            .catch(error => {
                outputs.databaseErrorInformationForDocument(contracts.READING, contracts.PRIVATE_USER_DATA_COLLECTION, arrayName = contracts.DEFAULT_STRING, error)
            })
    }
}

/**
 * Sends activity reminder push notifications to a list of attendees.
 * Checks the local cache for each attendee's device token; if not found, retrieves it from the database.
 * Sends the notification to the device if the token is available, otherwise logs the appropriate error.
 * 
 * @param {payload} notificationPayload 
 * @param {List<String>} attendeeIds 
 * @returns 
 * 
 */
function sendActivityReminderPushNotifications(notificationPayload, attendeeIds) {
    if (attendeeIds == null) {
        outputs.emptyField(contracts.ATTENDEE_IDS);
    }
    else {
        attendeeIds.forEach(userId => {
            if (deviceTokens.has(userId)) {
                if (deviceTokens.get(userId) == null || deviceTokens.get(userId) == undefined) {
                    outputs.noDeviceTokenExistsInformation();
                } else {
                    var deviceToken = deviceTokens.get(userId);
                    sendPushNotificationToDevice(deviceToken, notificationPayload);
                }
            }
            else {
                db.collection(contracts.PRIVATE_USER_DATA_COLLECTION).doc(userId).get()
                    .then(doc => {
                        var privateUserDataDoc = doc;
                        var privateUserData = privateUserDataDoc.data();

                        var deviceToken = privateUserData.pushToken;
                        deviceTokens.set(privateUserDataDoc.id, deviceToken);
                        if (deviceToken == null || deviceToken == undefined) {
                            outputs.noDeviceTokenExistsInformation();
                        }
                        else {
                            outputs.deviceTokenFromUserInformation(deviceToken, privateUserData);
                            sendPushNotificationToDevice(deviceToken, notificationPayload);
                        }
                    })
                    .catch(error => {
                        outputs.databaseErrorInformationForDocument(contracts.READING, contracts.PRIVATE_USER_DATA_COLLECTION, arrayName = contracts.DEFAULT_STRING, error)
                    })
            }
        });
    }
}

/**
 * Sends push notifications for activity invitations to a list of invited users.
 * Checks the local cache for each user's device token; if not found, retrieves it from the database.
 * Sends the notification to the device if the token is available, otherwise logs the appropriate error.
 * 
 * @param {payload} notificationPayload 
 * @param {List<String>} invitationIds 
 * @returns 
 * 
 */
function sendPushNotificationsForActivityInvitation(notificationPayload, invitationIds) {
    if (invitationIds == null) {
        outputs.emptyField(contracts.INVITATION_IDS);
    }
    else {
        invitationIds.forEach(userId => {
            if (deviceTokens.has(userId)) {
                if (deviceTokens.get(userId) == null || deviceTokens.get(userId) == undefined) {
                    outputs.noDeviceTokenExistsInformation();
                } else {
                    var deviceToken = deviceTokens.get(userId);
                    sendPushNotificationToDevice(deviceToken, notificationPayload);
                }
            }
            else {
                db.collection(contracts.PRIVATE_USER_DATA_COLLECTION).doc(userId).get()
                    .then(doc => {
                        var privateUserDataDoc = doc;
                        var privateUserData = privateUserDataDoc.data();

                        var deviceToken = privateUserData.pushToken;
                        deviceTokens.set(privateUserDataDoc.id, deviceToken);
                        if (deviceToken == null || deviceToken == undefined) {
                            outputs.noDeviceTokenExistsInformation();
                        }
                        else {
                            outputs.deviceTokenFromUserInformation(deviceToken, privateUserData);
                            sendPushNotificationToDevice(deviceToken, notificationPayload);
                        }
                    })
                    .catch(error => {
                        outputs.databaseErrorInformationForDocument(contracts.READING, contracts.PRIVATE_USER_DATA_COLLECTION, arrayName = contracts.DEFAULT_STRING, error)
                    })
            }

        });
    }
}

/**
 * Deletes the device token for a user from the local cache.
 * 
 * @param {String} userId
 *  
 */
function deleteDeviceTokenInLocalMap(userId) {
    deviceTokens.delete(userId);
}

/**
 * Updates the device token for a user in the local cache.
 * 
 * @param {String} userId 
 * @param {String} deviceToken
 *  
 */
function updateDeviceTokenInLocalMap(userId, deviceToken) {
    deviceTokens.set(userId, deviceToken);
}

/**
 * Updates the userName for a user in the local cache.
 * 
 * @param {String} userId 
 * @param {String} userName 
 * 
 */
function updateUserNameInLocalMap(userId, userName) {
    publicUserData.set(userId, userName);
    console.log(publicUserData);
}

/**
 * Sends a push notification to a device.
 * 
 * @param {String} deviceToken 
 * @param {payload} payload 
 * 
 */
function sendPushNotificationToDevice(deviceToken, payload) {
    if (deviceToken != null) {
        admin.messaging().sendToDevice(deviceToken, payload)
            .then(response => {
                outputs.databaseSuccessInformationForDocument(contracts.SENT, collectionName = contracts.DEFAULT_STRING, arrayName = contracts.DEFAULT_STRING, response)
            }).catch(error => { outputs.databaseErrorInformationForDocument(contracts.SENDING, collectionName = contracts.DEFAULT_STRING, arrayName = contracts.DEFAULT_STRING, error) })
    }
    else{
        outputs.noDeviceTokenExistsInformation();
    }
}

module.exports = {
    pushNotificationHandler,
    getNotificationUseCase,
    deleteDeviceTokenInLocalMap,
    updateDeviceTokenInLocalMap,
    updateUserNameInLocalMap
};