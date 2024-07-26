console.log("Executing device_token.js")

const admin = require('firebase-admin');
const db = admin.firestore();

const pushNotifications = require("./push_notifications");
const firebaseFunctions = require("./firebase_functions");
const outputs = require("./outputs");
const contracts = require("./contracts");

/**
 * Observes the deleteDeviceTokenFromServer collection in the database.
 * Triggers when a change is detected, removing the device token from the server and updating relevant user data.
 * This function ensures that obsolete device tokens are promptly removed from the system, maintaining data integrity and security.
 *
 * deleteDeviceTokenFromServer document:
 * 
 * <random-id: String>
 * {
 *    userId: String
 * }
 * 
 */
async function deleteDeviceTokenObserver() {

  outputs.startObserverInformation(contracts.DELETE_DEVICE_TOKEN_OBSERVER);

  db.collection(contracts.DELETE_DEVICE_TOKEN_FROM_SERVER_COLLECTION)
    .onSnapshot(querySnapshot => {
      querySnapshot.docChanges().forEach(change => {

        var deleteDeviceTokenDoc = change.doc;
        var deleteDeviceTokenData = deleteDeviceTokenDoc.data();

        if (change.type === contracts.DOCUMENT_TYPE) {

          outputs.userDocumentInformation(contracts.DELETE_DEVICE_TOKEN_DOCUMENT, deleteDeviceTokenDoc.id, deleteDeviceTokenData);

          firebaseFunctions.deleteDocument(contracts.DELETE_DEVICE_TOKEN_FROM_SERVER_COLLECTION, deleteDeviceTokenDoc.id)
          pushNotifications.deleteDeviceTokenInLocalMap(deleteDeviceTokenData.userId);
          firebaseFunctions.updateDocumentWithSpecificId(contracts.PRIVATE_USER_DATA_COLLECTION, deleteDeviceTokenData.userId, { [contracts.DEVICE_TOKEN]: null });
        }
      });
    });
}

/**
 * Observes the updateDeviceTokenAtServer collection in the database.
 * Triggers when a change is detected, updating the device token in the server and synchronizing with user data.
 * This function facilitates the seamless update of device tokens, ensuring that push notifications are sent to the correct and current devices.
 *
 * updateDeviceTokenAtServer document:
 * 
 * <random-id: String>
 * {
 *    userId: String,
 *    pushToken: String
 * }
 */
async function updateDeviceTokenObserver() {

  outputs.startObserverInformation(contracts.UPDATE_DEVICE_TOKEN_OBSERVER);
  
  db.collection(contracts.UPDATE_DEVICE_TOKEN_AT_SEREVER_COLLECTION)
    .onSnapshot(querySnapshot => {
      querySnapshot.docChanges().forEach(change => {

        var updateDeviceTokenDoc = change.doc;
        var updateDeviceTokenData = updateDeviceTokenDoc.data();

        if (change.type === contracts.DOCUMENT_TYPE) {
          outputs.userDocumentInformation(contracts.UPDATE_DEVICE_TOKEN_AT_SEREVER_COLLECTION, updateDeviceTokenDoc.id, updateDeviceTokenData);
          firebaseFunctions.deleteDocument(contracts.UPDATE_DEVICE_TOKEN_AT_SEREVER_COLLECTION, updateDeviceTokenDoc.id)
          pushNotifications.updateDeviceTokenInLocalMap(updateDeviceTokenData.userId, updateDeviceTokenData.pushToken);
          firebaseFunctions.updateDocumentWithSpecificId(contracts.PRIVATE_USER_DATA_COLLECTION, updateDeviceTokenData.userId, { [contracts.DEVICE_TOKEN]: updateDeviceTokenData.pushToken });
        }
      });
    });
}

module.exports = {
  deleteDeviceTokenObserver,
  updateDeviceTokenObserver,
};