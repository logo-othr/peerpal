console.log("Executing publicUserData.js")

const admin = require('firebase-admin');
const db = admin.firestore();

const pushNotifications = require("./push_notifications");
const firebaseFunctions = require("./firebase_functions");
const outputs = require("./outputs");
const contracts = require("./contracts");


/**
 * Observes changes in the updateName collection in the database.
 * When a document of type 'modified' is detected, it retrieves the updated user data,
 * updates relevant local caches for push notifications, and deletes the processed document
 * from the updateName collection to maintain data integrity.
 * This function ensures real-time synchronization of user name updates across the application.
 */
async function updateNameObserver() {

    outputs.startObserverInformation(contracts.UPDATE_NAME_OBSERVER);

    db.collection(contracts.UPDATE_NAME_AT_SERVER_COLLECTION)
        .onSnapshot(querySnapshot => {
            querySnapshot.docChanges().forEach(change => {

                if (change.type === contracts.DOCUMENT_TYPE) {

                    var updateNameDoc = change.doc;
                    var updateNameData = updateNameDoc.data();

                    outputs.userDocumentInformation(contracts.UPDATE_NAME_AT_SERVER_DOCUMENT, updateNameDoc.id, updateNameData);
                    firebaseFunctions.deleteDocument(contracts.UPDATE_NAME_AT_SERVER_COLLECTION, updateNameDoc.id);

                    db.collection(contracts.PUBLIC_USER_DATA_COLLECTION).doc(updateNameData.userId).get()
                        .then(doc => {

                            var publicUserDataDoc = doc;
                            var publicUserDataDocData = publicUserDataDoc.data();
                            var userName = publicUserDataDocData.name;

                            pushNotifications.updateUserNameInLocalMap(updateNameData.userId, userName);

                        })
                        .catch(error => { outputs.databaseErrorInformationForDocument(contracts.READING, contracts.PUBLIC_USER_DATA_COLLECTION, arrayName = contracts.DEFAULT_STRING, error) })
                }
            });
        });
}

module.exports = {
    updateNameObserver,
};