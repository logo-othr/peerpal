console.log("Executing friends.js")

const pushNotifications = require("./push_notifications");
const statistic = require("./statistic");
const firebaseFunctions = require("./firebase_functions");
const outputs = require("./outputs");
const contracts = require("./contracts");
const admin = require('firebase-admin');
const db = admin.firestore();

/**
 * Observes the friendRequestNotification collection in the database.
 * Triggers when a change is detected and handles friend request notifications.
 * This includes logging information, updating statistics, storing the request,
 * and sending push notifications.
 * 
 * friendRequestNotifications document:
 * 
 * <random-id: String>
 * {
 *    timestamp: String
 *    fromId: String
 *    toId: String
 * }
 * 
 */
async function friendRequestNotificationObserver() {

  outputs.startObserverInformation(contracts.FRIEND_REQUEST_NOTIFICATION_OBSERVER);

  db.collection(contracts.FRIEND_REQUEST_NOTIFICATIONS_COLLECTION)
    .onSnapshot(querySnapshot => {
      querySnapshot.docChanges().forEach(change => {

        var friendRequestDoc = change.doc;
        var friendRequestData = friendRequestDoc.data();

        if (change.type === contracts.DOCUMENT_TYPE) {
          outputs.userDocumentInformation(contracts.FRIEND_REQUEST_NOTIFICATIONS_DOCUMENT, friendRequestDoc.id, friendRequestData);
          statistic.moveDocumentInStatisticCollection(contracts.STATISTIC_FRIEND_REQUEST_COLLECTION, friendRequestData)
          firebaseFunctions.setDocumentWithSpecificId(contracts.FRIEND_REQUESTS_COLLECTION, friendRequestDoc.id, friendRequestData);
          firebaseFunctions.deleteDocument(contracts.FRIEND_REQUEST_NOTIFICATIONS_COLLECTION, friendRequestDoc.id);
          pushNotifications.pushNotificationHandler(contracts.FRIEND_REQUEST_USECASE, change);
        }
      });
    });
}

/**
 * Observes the friendRequestResponse collection in the database.
 * Triggers when a change is detected and processes the friend request responses.
 * This involves logging, updating statistics, validating responses, and taking
 * appropriate actions based on the response.
 * 
 * friendRequestResponse Document:
 * 
 * <random-id: String>
 * {
 *    timestamp: String
 *    fromId: String
 *    toId: String
 *    response: Boolean
 * }
 * 
 */
async function friendRequestResponseObserver() {

  outputs.startObserverInformation(contracts.FRIEND_REQUEST_RESPONSE_OBSERVER);

  db.collection(contracts.FRIEND_REQUEST_RESPONSE_COLLECTION)
    .onSnapshot(querySnapshot => {
      querySnapshot.docChanges().forEach(change => {

        var friendRequestResponseDoc = change.doc;
        var friendRequestResponseData = friendRequestResponseDoc.data();

        if (change.type === contracts.DOCUMENT_TYPE) {
          outputs.userDocumentInformation(contracts.FRIEND_REQUEST_RESPONSE_DOCUMENT, friendRequestResponseDoc.id, friendRequestResponseData);
          statistic.moveDocumentInStatisticCollection(contracts.STATISTIC_FRIEND_REQUEST_RESPONSE_COLLECTION, friendRequestResponseData)
          firebaseFunctions.deleteDocument(contracts.FRIEND_REQUEST_RESPONSE_COLLECTION, friendRequestResponseDoc.id);
          var isAccepted = validateFriendRequestResponse(friendRequestResponseData.response);

          if (isAccepted) {
            checkUserAuthority(isAccepted, friendRequestResponseData);
          }
          else {
            checkUserAuthority(isAccepted, friendRequestResponseData);
          }
        }
      });
    });
}

/**
 * Observes the canceledFriendRequests collection in the database.
 * Triggers when a change is detected and handles the cancellation of friend requests.
 * This includes logging information, updating statistics, and removing the friend request.
 * 
 * canceledFriendRequests Document:
 * 
 * <random-id: String>
 * {
 *    timestamp: String
 *    fromId: String
 *    toId: String
 * }
 * 
 */
async function canceledFriendRequestsObserver() {

  outputs.startObserverInformation(contracts.CANCELED_FRIEND_REQUESTS_OBSERVER);

  db.collection(contracts.CANCELED_FRIEND_REQUESTS_COLLECTION)
    .onSnapshot(querySnapshot => {
      querySnapshot.docChanges().forEach(change => {

        var canceledFriendRequestDoc = change.doc;
        var canceledFriendRequestData = canceledFriendRequestDoc.data();

        if (change.type === contracts.DOCUMENT_TYPE) {
          outputs.userDocumentInformation(contracts.CANCELED_FRIEND_REQUESTS_DOCUMENT, canceledFriendRequestDoc.id, canceledFriendRequestData);
          statistic.moveDocumentInStatisticCollection(contracts.STATISTIC_CANCELED_FRIEND_REQUESTS_COLLECTION, canceledFriendRequestData)
          firebaseFunctions.deleteDocument(contracts.CANCELED_FRIEND_REQUESTS_COLLECTION, canceledFriendRequestDoc.id);
          getFriendRequestDocument(canceledFriendRequestData);
        }
      });
    });
}

/**
 * Retrieves and deletes the friend request document matching the canceled friend request data.
 * It ensures the related friend request document is removed from the database.
 *  
 * @param {Object} canceledFriendRequestData 
 * 
 */
function getFriendRequestDocument(canceledFriendRequestData) {
  db.collection(contracts.FRIEND_REQUESTS_COLLECTION).where(contracts.FROM_ID, contracts.EQUAL, canceledFriendRequestData.fromId).where(contracts.TO_ID, contracts.EQUAL, canceledFriendRequestData.toId)
    .get()
    .then(documentQuerySnapshot => {
      documentQuerySnapshot.forEach(doc => {

        var friendRequestDoc = doc;
        deleteFriendRequestDocument(friendRequestDoc);
      })
    })
    .catch(error => {
      outputs.databaseErrorInformationForDocument(contracts.GETTING, contracts.CANCELED_FRIEND_REQUESTS_DOCUMENT, arrayName = contracts.DEFAULT_STRING, error)
    })
}

/**
 * Verifies that the friend request being accepted is indeed from the other user, not the current user, 
 * since Firebase security rules cannot enforce this due to document structure limitations.
 * If the request is valid, it either writes a new friend document or deletes the friend request document based on the response.
 * 
 * @param {Boolean} isAccepted 
 * @param {Object} friendRequestResponseData 
 * 
 * friendRequestResponse Document:
 * 
 * <random-id: String>
 * {
 *    timestamp: String
 *    fromId: String
 *    toId: String
 *    response: Boolean
 * }
 * 
 */
function checkUserAuthority(isAccepted, friendRequestResponseData) {
  db.collection(contracts.FRIEND_REQUESTS_COLLECTION).where(contracts.FROM_ID, contracts.EQUAL, friendRequestResponseData.toId).where(contracts.TO_ID, contracts.EQUAL, friendRequestResponseData.fromId)
    .get()
    .then(documentQuerySnapshot => {
      documentQuerySnapshot.forEach(doc => {

        var friendRequestDoc = doc;
        var friendRequestData = friendRequestDoc.data();

        if (isAccepted) {
          writeFriendsDocument(friendRequestData, friendRequestResponseData);
          deleteFriendRequestDocument(friendRequestDoc);
        }
        else {
          deleteFriendRequestDocument(friendRequestDoc);
        }
      })
    })
    .catch(error => {
      outputs.databaseErrorInformationForDocument(contracts.GETTING, contracts.FRIEND_REQUEST_RESPONSE_DOCUMENT, arrayName = contracts.DEFAULT_STRING, error)
    })
}

/**
 * Adds entries to the friends collection for both users when a friend request is accepted,
 * ensuring each user has a corresponding friend document. 
 *
 * @param {Object} friendRequestData 
 * 
 */
function writeFriendsDocument(friendRequestData, friendRequestResponseData) {
  firebaseFunctions.setDocumentWithRandomId(contracts.FRIENDS_COLLECTION,
    {
      [contracts.TO_ID]: friendRequestData.toId,
      [contracts.FROM_ID]: friendRequestData.fromId,
      [contracts.TIMESTAMP]: friendRequestResponseData.timestamp
    });
  firebaseFunctions.setDocumentWithRandomId(contracts.FRIENDS_COLLECTION,
    {
      [contracts.TO_ID]: friendRequestData.fromId,
      [contracts.FROM_ID]: friendRequestData.toId,
      [contracts.TIMESTAMP]: friendRequestResponseData.timestamp
    });
};

/**
 * Deletes a friend request document from the database.
 * This function removes the friend request document identified by the given id.
 * 
 * @param {Object} friendRequestDoc 
 * 
 */
function deleteFriendRequestDocument(friendRequestDoc) {
  firebaseFunctions.deleteDocument(contracts.FRIEND_REQUESTS_COLLECTION, friendRequestDoc.id);
}

/**
 * Validates the friend request response to check if it is accepted or rejected.
 * 
 * @param {Boolean} friendRequestResponse 
 * @returns Boolean
 * 
 */
function validateFriendRequestResponse(friendRequestResponse) {
  if (friendRequestResponse) {
    return true;
  } else {
    return false;
  }
}



module.exports = {
  friendRequestNotificationObserver,
  friendRequestResponseObserver,
  canceledFriendRequestsObserver,
};