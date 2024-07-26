const admin = require('firebase-admin');
const db = admin.firestore();
const outputs = require("./outputs");
const contracts = require("./contracts");

/**
 * Sets a document with a specific ID in the specified Firestore collection.
 * If the operation is successful, it logs success information; otherwise, it logs an error.
 * 
 * @param {String} collectionName 
 * @param {String} documentId 
 * @param {Object} documentData 
 * 
 */
function setDocumentWithSpecificId(collectionName, documentId, documentData) {
    db.collection(collectionName).doc(documentId).set(documentData)
        .then(response => { outputs.databaseSuccessInformationForDocument(contracts.SET, collectionName, arrayName = contracts.DEFAULT_STRING, response) })
        .catch(error => { outputs.databaseErrorInformationForDocument(contracts.SETTING, collectionName, arrayName = contracts.DEFAULT_STRING, error) });
}

/**
 * Sets a document with a random ID in the specified Firestore collection.
 * Logs success information if the operation is successful; otherwise, logs an error.
 * 
 * @param {String} collectionName 
 * @param {Object} documentData 
 * 
 */
function setDocumentWithRandomId(collectionName, documentData) {
    db.collection(collectionName).doc().set(documentData)
        .then(response => { outputs.databaseSuccessInformationForDocument(contracts.SET, collectionName, arrayName = contracts.DEFAULT_STRING, response) })
        .catch(error => { outputs.databaseErrorInformationForDocument(contracts.SETTING, collectionName, arrayName = contracts.DEFAULT_STRING, error) });
}

/**
 * Updates a document with a specific ID in the specified Firestore collection.
 * Logs success information upon successful update; otherwise, logs an error.
 * 
 * @param {String} collectionName 
 * @param {String} documentId 
 * @param {Object} documentData 
 * 
 */
function updateDocumentWithSpecificId(collectionName, documentId, documentData) {
    db.collection(collectionName).doc(documentId).update(documentData
    )
        .then(response => { outputs.databaseSuccessInformationForDocument(contracts.UPDATED, collectionName, arrayName = contracts.DEFAULT_STRING, response) })
        .catch(error => { outputs.databaseErrorInformationForDocument(contracts.UPDATING, collectionName, arrayName = contracts.DEFAULT_STRING, error) });
}

/**
 * Updates a document with a random ID in the specified Firestore collection.
 * Logs success information upon successful update; otherwise, logs an error.
 * 
 * @param {String} collectionName 
 * @param {Object} documentData 
 * 
 */
function updateDocumentWithRandomId(collectionName, documentData) {
    db.collection(collectionName).doc().update(documentData
    )
        .then(response => { outputs.databaseSuccessInformationForDocument(contracts.UPDATED, collectionName, arrayName = contracts.DEFAULT_STRING, response) })
        .catch(error => { outputs.databaseErrorInformationForDocument(contracts.UPDATING, collectionName, arrayName = contracts.DEFAULT_STRING, error) });
}

/**
 * Deletes a document with a specific ID from the specified Firestore collection.
 * Logs success information upon successful deletion; otherwise, logs an error.
 * 
 * @param {String} collectionName 
 * @param {String} documentId 
 * 
 */
function deleteDocument(collectionName, documentId) {
    db.collection(collectionName).doc(documentId).delete()
        .then(response => { outputs.databaseSuccessInformationForDocument(contracts.DELETED, collectionName, arrayName = contracts.DEFAULT_STRING, response) })
        .catch(error => { outputs.databaseErrorInformationForDocument(contracts.DELETING, collectionName, arrayName = contracts.DEFAULT_STRING, error) });
}

/**
 * Deletes friend documents in a collection where the userId and friendId match specific fields.
 * This method ensures bi-directional friend relationships are removed.
 * Logs success information upon successful deletion; otherwise, logs an error.
 *  
 * @param {String} collectionName 
 * @param {String} userId 
 * @param {String} friendId 
 */
function deleteFriendDocument(collectionName, userId, friendId) {
    db.collection(collectionName).where(contracts.FROM_ID, contracts.EQUAL, userId).where(contracts.TO_ID, contracts.EQUAL, friendId).delete()
        .then(response => { outputs.databaseSuccessInformationForDocument(contracts.DELETED, collectionName, arrayName = contracts.DEFAULT_STRING, response) })
        .catch(error => { outputs.databaseErrorInformationForDocument(contracts.DELETING, collectionName, arrayName = contracts.DEFAULT_STRING, error) });

    db.collection(collectionName).where(contracts.FROM_ID, contracts.EQUAL, friendId).where(contracts.TO_ID, contracts.EQUAL, userId).delete()
        .then(response => { outputs.databaseSuccessInformationForDocument(contracts.DELETED, collectionName, arrayName = contracts.DEFAULT_STRING, response) })
        .catch(error => { outputs.databaseErrorInformationForDocument(contracts.DELETING, collectionName, arrayName = contracts.DEFAULT_STRING, error) });
}

/**
 * Removes data from an array field in a Firestore document.
 * Logs success information upon successful removal; otherwise, logs an error.
 *  
 * @param {String} documentPath 
 * @param {String} arrayName 
 * @param {Object} dataToRemove 
 * 
 */
function removeDataFromArray(documentPath, arrayName, dataToRemove) {
    documentPath
        .update({

            [arrayName]: admin.firestore.FieldValue.arrayRemove(dataToRemove)

        }).then(response => { outputs.databaseSuccessInformationForDocument(contracts.REMOVED, collectionName = contracts.DEFAULT_STRING, arrayName, response) })
        .catch(error => { outputs.databaseErrorInformationForDocument(contracts.REMOVING, collectionName = contracts.DEFAULT_STRING, arrayName, error) });
}

/**
 * Adds data to an array field in a Firestore document.
 * Logs success information upon successful addition; otherwise, logs an error.
 *  
 * @param {String} documentPath 
 * @param {String} arrayName 
 * @param {Object} dataToAdd 
 * 
 */
function addDataToArray(documentPath, arrayName, dataToAdd) {
    documentPath
        .update({

            [arrayName]: admin.firestore.FieldValue.arrayUnion(dataToAdd)

        }).then(response => { outputs.databaseSuccessInformationForDocument(contracts.ADDED, collectionName = contracts.DEFAULT_STRING, arrayName, response) })
        .catch(error => { outputs.databaseErrorInformationForDocument(contracts.ADDING, collectionName = contracts.DEFAULT_STRING, arrayName, error) });
}

module.exports = {
    deleteDocument,
    deleteFriendDocument,
    removeDataFromArray,
    addDataToArray,
    setDocumentWithSpecificId,
    setDocumentWithRandomId,
    updateDocumentWithSpecificId,
    updateDocumentWithRandomId,
};