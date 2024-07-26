console.log("Executing activities.js")

const admin = require('firebase-admin');
const db = admin.firestore();
const statistic = require("./statistic");
const pushNotifications = require("./push_notifications");
const firebaseFunctions = require("./firebase_functions");
const outputs = require("./outputs");
const contracts = require("./contracts");

/**
 * Observes the activities collection in the database.
 * It triggers when a change is detected and processes new activities.
 * Converts array items to strings to comply with security rules.
 * 
 * Note:
 * The convertArrayItemsToString() method is needed because the security rules cannot check if a list contains only strings.
 * To prevent in-app problems when someone attacks the app and writes integers or other types in the list,
 * we need to convert the list items to strings.
 *
 * activities document:
 * 
 * <id: String>
 *  {
 *    id: String;
 *    timestamp: String;
 *    name: String;
 *    code: String;
 *    description: String;
 *    creatorId: String;
 *    creatorName: String;
 *    date: Integer;
 *    location: Location;
 *    attendeeIds: List<String>;
 *    invitationIds: List<String>;
 *    public: Boolean;
 *    isAlreadyEvaluatedFromServer: Boolean;
 *   }
 * 
 */
async function activityNotificactionObserver() {

    outputs.startObserverInformation(contracts.ACTIVITY_NOTIFICATION_OBSERVER);

    db.collection('newActivity')
        .onSnapshot(querySnapshot => {
            querySnapshot.docChanges().forEach(change => {
                if (change.type === contracts.DOCUMENT_TYPE) {

                    var newActivityDoc = change.doc;
                    var newActivityData = newActivityDoc.data();

                    outputs.userDocumentInformation(contracts.NEW_ACTIVITY_NOTIFICATION_DOCUMENT, newActivityDoc.id, newActivityData);

                    var invitationIds = json2array(newActivityData, 'invitationIds');
                    var attendeeIds = json2array(newActivityData, 'attendeeIds');

                    var invitationArrayHasValidDataTypes = checkArrayItemTypes(invitationIds);
                    var attendeeArrayHasValidDataTypes = checkArrayItemTypes(attendeeIds);

                    if (invitationArrayHasValidDataTypes === false || attendeeArrayHasValidDataTypes === false) {
                        firebaseFunctions.deleteDocument('newActivity', newActivityDoc.id);
                        outputs.invalidCreatedActivity();
                    }
                    else {
                        firebaseFunctions.deleteDocument('newActivity', newActivityDoc.id);
                        firebaseFunctions.setDocumentWithSpecificId(contracts.ACTIVITIES_COLLECTION, newActivityDoc.id, newActivityData);
                        statistic.moveDocumentInStatisticCollection(contracts.STATISTIC_CREATED_ACTIVITIES_COLLECTION, newActivityData)
                        pushNotifications.getNotificationUseCase(contracts.ACTIVITY_INVITATION_USECASE, change, newActivityData.creatorName, newActivityData.invitationIds);
                    }
                }
            });
        });
}

/**
 * Converts a specified array in a JSON object to a regular array.
 *
 * @param {Object} jsonData - The JSON object containing the array.
 * @param {String} arrayName - The name of the array to be converted.
 * @returns {Array} The converted array.
 */
function json2array(jsonData, arrayName) {
    var array = [];
    var keys = Object.keys(jsonData);
    keys.forEach(function (key) {
        if (key === arrayName) {
            for (var i in jsonData[arrayName]) {
                array.push(jsonData[arrayName][i]);
            }
        }
    });
    return array;
}

/**
 * Observes the 'updateActivity' collection in the database. Triggers when a change is detected.
 * Validates and updates existing activities in the database.
 *  
 * updateActivity document:
 * 
 * <id: String>
 *  {
 *    id: String;
 *    timestamp: String;
 *    name: String;
 *    code: String;
 *    description: String;
 *    creatorId: String;
 *    creatorName: String;
 *    date: Integer;
 *    location: Location;
 *    attendeeIds: List<String>;
 *    invitationIds: List<String>;
 *    public: Boolean;
 *    isAlreadyEvaluatedFromServer: Boolean;
 *   }
 * 
 */
async function updateActivityObserver() {

    outputs.startObserverInformation(contracts.UPDATE_ACTIVITY_OBSERVER);

    db.collection(contracts.UPDATE_ACTIVITY_COLLECTION)
        .onSnapshot(querySnapshot => {
            querySnapshot.docChanges().forEach(change => {
                if (change.type === contracts.DOCUMENT_TYPE) {

                    var updateActivityDoc = change.doc;
                    var updateActivityData = updateActivityDoc.data();

                    outputs.userDocumentInformation(contracts.UPDATE_ACTIVITY_COLLECTION, updateActivityDoc.id, updateActivityData);
                    firebaseFunctions.deleteDocument(contracts.UPDATE_ACTIVITY_COLLECTION, updateActivityDoc.id);

                    getExistingActivityFromDatabase(updateActivityData, change);
                }
            });
        });
}

/**
 * Observes the 'joinActivity' collection in the database. Triggers when a change is detected.
 * Adds users to activity attendees list and updates statistics.
 * 
 * joinActivity document:
 * 
 * <random-id: String>
 *  {
 *    activityId: String;
 *    joiningId: String;
 *    timestamp: String;
 *   }
 * 
 */
async function joinActivityObserver() {
    outputs.startObserverInformation(contracts.JOIN_ACTIVITY_OBSERVER);

    db.collection(contracts.JOIN_ACTIVITY_COLLECTION)
        .onSnapshot(querySnapshot => {
            querySnapshot.docChanges().forEach(change => {
                if (change.type === contracts.DOCUMENT_TYPE) {

                    var joinActivityDoc = change.doc;
                    var joinActivityData = joinActivityDoc.data();

                    outputs.userDocumentInformation(contracts.JOIN_ACTIVITY_COLLECTION, joinActivityDoc.id, joinActivityData);
                    statistic.moveDocumentInStatisticCollection(contracts.STATISTIC_JOIN_ACTIVITY_COLLECTION, joinActivityData)
                    firebaseFunctions.deleteDocument(contracts.JOIN_ACTIVITY_COLLECTION, joinActivityDoc.id);
                    joinExistingActivity(joinActivityData)
                }
            });
        });
}

/**
 * Observes the 'leaveActivity' collection in the database. Triggers when a change is detected.
 * Removes users from activity attendees list and updates statistics.
 *
 * leaveActivity document:
 * 
 * <random-id: String>
 *  {
 *    activityId: String;
 *    leavingId: String;
 *    timestamp: String;
 *   }
 * 
 */
async function leaveActivityObserver() {
    outputs.startObserverInformation(contracts.LEAVE_ACTIVITY_OBSERVER);

    db.collection(contracts.LEAVE_ACTIVITY_COLLECTION)
        .onSnapshot(querySnapshot => {
            querySnapshot.docChanges().forEach(change => {
                if (change.type === contracts.DOCUMENT_TYPE) {

                    var leaveActivityDoc = change.doc;
                    var leaveActivityData = leaveActivityDoc.data();

                    outputs.userDocumentInformation(contracts.LEAVE_ACTIVITY_COLLECTION, leaveActivityDoc.id, leaveActivityData);
                    statistic.moveDocumentInStatisticCollection(contracts.STATISTIC_LEAVE_ACTIVITY_COLLECTION, leaveActivityData)
                    firebaseFunctions.deleteDocument(contracts.LEAVE_ACTIVITY_COLLECTION, leaveActivityDoc.id);
                    firebaseFunctions.removeDataFromArray(db.collection(contracts.ACTIVITIES_COLLECTION).doc(leaveActivityData.activityId), contracts.ATTENDEE_IDS, leaveActivityData.leavingId);
                }
            });
        });
}

/**
 * Observes the 'deleteActivity' collection in the database. Triggers when a change is detected.
 * Deletes the specified activity and updates statistics.
 *
 * deleteActivity document:
 * 
 * <random-id: String>
 *  {
 *    activityId: String;
 *    userId: String;
 *    timestamp: String;
 *   }
 * 
 */
async function deleteActivityObserver() {
    outputs.startObserverInformation(contracts.DELETE_ACTIVITY_OBSERVER);

    db.collection(contracts.DELETE_ACTIVITY_COLLECTION)
        .onSnapshot(querySnapshot => {
            querySnapshot.docChanges().forEach(change => {
                if (change.type === contracts.DOCUMENT_TYPE) {

                    var deleteActivityDoc = change.doc;
                    var deleteActivityData = deleteActivityDoc.data();

                    outputs.userDocumentInformation(contracts.DELETE_ACTIVITY_COLLECTION, deleteActivityDoc.id, deleteActivityData);
                    statistic.moveDocumentInStatisticCollection(contracts.STATISTIC_DELETE_ACTIVITY_COLLECTION, change.doc.data())
                    firebaseFunctions.deleteDocument(contracts.ACTIVITIES_COLLECTION, change.doc.data().activityId);
                    firebaseFunctions.deleteDocument(contracts.DELETE_ACTIVITY_COLLECTION, change.doc.id);
                }
            });
        });
}

/**
 * Searches for the activity to be updated in the database.
 * Processes reminders and invitations for the found activity.
 *
 * @param {Object} updateActivityData 
 * @param {Array<Strings>} invitationIds 
 * @param {Object} change 
 * 
 */
function getExistingActivityFromDatabase(updateActivityData, change) {
    db.collection(contracts.ACTIVITIES_COLLECTION).where(contracts.ID, contracts.EQUAL, updateActivityData.id).where(contracts.CREATOR_ID, contracts.EQUAL, updateActivityData.creatorId).get()
        .then((documentQuerySnapshot) => {
            if (documentQuerySnapshot.empty) {
                outputs.noMatchingActivityInformation();
                return;
            }
            documentQuerySnapshot.forEach(doc => {

                var activitiesDoc = doc;
                var activitiesData = activitiesDoc.data();

                sendActivityReminder(activitiesData, updateActivityData, change);
                collectNewUserToInvite(activitiesData, activitiesDoc, updateActivityData, change);
            });
        })
        .then(response => { outputs.databaseSuccessInformationForDocument(contracts.READ, contracts.ACTIVITIES_COLLECTION, arrayName = contracts.DEFAULT_STRING, response) })
        .catch(error => { outputs.databaseErrorInformationForDocument(contracts.READING, contracts.ACTIVITIES_COLLECTION, arrayName = contracts.DEFAULT_STRING, error) });
}

/**
 * Compares existing invitation IDs with incoming invitation IDs array.
 * Sends new push notifications for newly invited users.
 * 
 * @param {Object} activitiesData 
 * @param {Object} activitiesDoc 
 * @param {Object} updateActivityData 
 * @param {Object} change 
 * @param {Array<String>} invitationIds 
 * 
 */
function collectNewUserToInvite(activitiesData, activitiesDoc, updateActivityData, change) {
    var newUsersToInvite = [];
    var updatedInvitationIdsArray = [];

    var invitationIds = json2array(updateActivityData, 'invitationIds');

    if (invitationIds != null) {
        var invitationArrayHasValidDataTypes = checkArrayItemTypes(invitationIds);

        if (invitationArrayHasValidDataTypes) {
            var existingActivityInvitationIds = json2array(activitiesData, 'invitationIds');
            var existingActivityAttendeeIds = json2array(activitiesData, 'attendeeIds');

            invitationIds.forEach(userId => {
                if (!existingActivityInvitationIds.includes(userId)) {
                    if (!existingActivityAttendeeIds.includes(userId) || existingActivityAttendeeIds == null) {
                        newUsersToInvite.push(userId);
                        updatedInvitationIdsArray.push(userId);
                    }
                }
            });
            if (newUsersToInvite != null && newUsersToInvite.length > 0) {
                sendPushNotification(change, updateActivityData, newUsersToInvite);
            }

            updatedInvitationIdsArray = updatedInvitationIdsArray.concat(existingActivityInvitationIds);
            updateDataInDatabase(activitiesDoc, updatedInvitationIdsArray, updateActivityData);
        }
        else {
            outputs.invalidUpdatedActivity();
        }
    }
}

/**
 * Sends a push notification for new users to invite.
 *
 * @param {Object} change 
 * @param {Object} updateActivityData 
 * @param {Array<String>} newUsersToInvite 
 * 
 */
function sendPushNotification(change, updateActivityData, newUsersToInvite) {
    pushNotifications.getNotificationUseCase(contracts.ACTIVITY_INVITATION_USECASE, change, updateActivityData.creatorName, newUsersToInvite);
}

/**
 * Updates the database with the new invitation IDs array.
 * Ensures that the activity document is updated with the latest data.
 *
 * @param {Object} activitiesDoc 
 * @param {Array<String>} updatedInvitationIdsArray 
 * @param {Object} updateActivityData 
 * 
 */
function updateDataInDatabase(activitiesDoc, updatedInvitationIdsArray, updateActivityData) {
    firebaseFunctions.updateDocumentWithSpecificId(contracts.ACTIVITIES_COLLECTION, activitiesDoc.id,
        {
            [contracts.INVITATION_IDS]: updatedInvitationIdsArray,
            [contracts.CREATOR_NAME]: updateActivityData.creatorName,
            [contracts.DATE]: updateActivityData.date,
            [contracts.DESCRIPTION]: updateActivityData.description,
            [contracts.LOCATION]: updateActivityData.location,
            [contracts.PUBLIC]: updateActivityData.public,
        }
    );
    statistic.moveUpdateActivityDocumentInStatisticCollection(contracts.STATISTIC_UPDATE_ACTIVITY_COLLECTION, updateActivityData, updatedInvitationIdsArray);
}

/**
 * Sends an activity reminder if the date has changed.
 *
 * @param {Object} activitiesData 
 * @param {Object} updateActivityData 
 * @param {Object} change
 *  
 */
function sendActivityReminder(activitiesData, updateActivityData, change) {
    if (activitiesData.date != updateActivityData.date) {
        pushNotifications.getNotificationUseCase(contracts.ACTIVITY_REMINDER_USERCASE, change, contracts.DEFAULT_STRING, [], activitiesData.attendeeIds);
    }
}

/**
 * Checks if all items in the array are of type string.
 * Ensures data consistency and type safety.
 *
 * @param {Array<String>} array 
 * @returns Boolean
 * 
 */
function checkArrayItemTypes(array) {

    if (array === null || typeof array === 'undefined' || array.length === 0) {
        return true;
    }
    else {
        for (var i = 0; i < array.length; i++) {
            if (typeof array[i] !== 'string') {
                console.log(array[i]);
                console.log(typeof array[i]);
                console.log("false!!");
                return false;
            }
        }
        return true;
    }
}

/**
 * Adds the joining ID to the existing activity attendee IDs array in the database.
 * If the user was invited before, removes the joining ID from the activity invitation IDs array.
 * 
 * Note:
 * This get() function is needed because we have to delete the joining ID from the invitation IDs if the user was invited before.
 * If the user isn't deleted from the invitation IDs, the app streams will stream the document in both 
 * the "Invited Activities Stream" and the "Joined Activities Stream".
 * 
 * @param {Object} joinActivityData 
 * 
 */
function joinExistingActivity(joinActivityData) {
    db.collection(contracts.ACTIVITIES_COLLECTION).where(contracts.ID, contracts.EQUAL, joinActivityData.activityId).get().then(function (querySnapshot) {
        if (querySnapshot.empty) {
            outputs.noMatchingActivityInformation();
            return;
        }
        querySnapshot.forEach(function (doc) {

            var activitiesDoc = doc;
            var activitiesData = activitiesDoc.data();

            firebaseFunctions.addDataToArray(activitiesDoc.ref, contracts.ATTENDEE_IDS, joinActivityData.joiningId)
            if (activitiesData.invitationIds.includes(joinActivityData.joiningId)) {
                firebaseFunctions.removeDataFromArray(activitiesDoc.ref, contracts.INVITATION_IDS, joinActivityData.joiningId);
            }
        });
    })
        .then(response => { outputs.databaseSuccessInformationForDocument(contracts.READ_AND_UPDATE, contracts.ACTIVITIES_COLLECTION, arrayName = contracts.DEFAULT_STRING, response) })
        .catch(error => { outputs.databaseErrorInformationForDocument(contracts.READING_AND_UPDATING, contracts.ACTIVITIES_COLLECTION, arrayName = contracts.DEFAULT_STRING, error) });
}

module.exports = {
    activityNotificactionObserver,
    updateActivityObserver,
    joinActivityObserver,
    leaveActivityObserver,
    deleteActivityObserver,
};