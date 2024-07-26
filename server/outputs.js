console.log("Executing outputs.js")

/**
 * Logs information about a new user document detected by the server.
 *  
 * @param {String} documentName 
 * @param {String} documentId 
 * @param {Object} documentData 
 * 
 */
function userDocumentInformation(documentName, documentId, documentData) {
    console.log(`Server dedected a new ${documentName} with id ${documentId} and data: `, documentData);
}

/**
 * Logs database error information for debugging purposes.
 *  
 * @param {String} databaseCommand 
 * @param {String} collectionName 
 * @param {String} arrayName 
 * @param {error} error 
 * 
 */
function databaseErrorInformationForDocument(databaseCommand, collectionName, arrayName, error) {
    if (databaseCommand == 'removing') {
        console.log(`Error ${databaseCommand} data from array in ${arrayName}:`, error);
    }
    if (databaseCommand == 'adding') {
        console.log(`Error ${databaseCommand} data to array in ${arrayName}:`, error);
    }
    if (databaseCommand == 'sending') {
        console.log('Error sending message:', error);
    }
    if (databaseCommand == 'getting') {
        console.log(`Error ${databaseCommand} document from ${collectionName} collection:`, error);
    }
    else {
        console.log(`Error ${databaseCommand} document in ${collectionName} collection:`, error);
    }
}

/**
 * Logs database success information for debugging purposes.
 *  
 * @param {String} databaseCommand 
 * @param {String} collectionName 
 * @param {String} arrayName 
 * @param {response} response 
 * 
 */
function databaseSuccessInformationForDocument(databaseCommand, collectionName, arrayName, response) {
    if (databaseCommand == 'removed') {
        console.log(`Successfully ${databaseCommand} data from array in ${arrayName}:`, response);
    }
    if (databaseCommand == 'added') {
        console.log(`Successfully ${databaseCommand} data to array in ${arrayName}:`, response);
    }
    if (databaseCommand == 'sent') {
        console.log('Successfully sent message:', response);
    } else {
        console.log(`Successfully ${databaseCommand} document in ${collectionName} collection:`, response);
    }
}

/**
 * Logs success information for a collection database operation.
 *  
 * @param {String} databaseCommand 
 * @param {String} collectionPath 
 * @param {response} response 
 * 
 */
function databaseSuccessInformationForCollection(databaseCommand, collectionPath, response) {
    if (databaseCommand == 'delete' && collectionPath != null) {
        console.log(`${databaseCommand} collection: `, collectionPath);
    }
    else {
        console.log(`Successfully ${databaseCommand} collection:`, response)
    }
}

/**
 * Logs error information for a collection database operation.
 *  
 * @param {String} databaseCommand 
 * @param {error} error 
 * 
 */
function databaseErrorInformationForCollection(databaseCommand, error) {
    console.log(`Error ${databaseCommand} collection:`, error);
}

/**
 * Logs information about a forged chat document. 
 */
function forgedChatDocumentInformation() {
    console.log('No chat exists with this user. FORGED DOCUMENT!');
}

/**
 * Logs information when no chat exists. 
 */
function noChatExistsInformation() {
    console.log('No chat exist');
}

/**
 * Logs information when no matching activity is found. 
 */
function noMatchingActivityInformation() {
    console.log('No matching activity');
}

/**
 * Logs information when no username exists. 
 */
function noUserNameExistsInformation() {
    console.log('No userName exist')
}

/**
 * Logs information about an invalid activity creation attempt.
 */
function invalidCreatedActivity(){
    console.log('An invalid activity was created!');
}


/**
 * Logs information about an invalid activity update attempt.
 */
function invalidUpdatedActivity(){
    console.log('An invalid updateActivityDocument was created!');
}

/**
 * Logs information when a required field is empty.
 * 
 * @param {String} fieldName - The name of the empty field.
 * 
 */
function emptyField(fieldName){
    console.log(`${fieldName} field is null`);
}
/**
* Logs information when a specific use case is not found.
 * 
 * @param {String} useCase 
 * 
 */
function noUseCaseExistsInformation(useCase) {
    console.log(`No case found for specific ${useCase}`);
}

/**
 * Logs information when no device token exists for a user.
 */
function noDeviceTokenExistsInformation() {
    console.log('No deviceToken exist for user')
}

/**
 * Logs the start of a method observer.
 * 
 * @param {String} methodName 
 * 
 */
function startObserverInformation(methodName) {
    console.log(`|-------------| Start methode ${methodName}`);
}

/**
 * Logs the device token information for a user.
 * 
 * @param {String} deviceToken 
 * @param {String} privateUserData 
 * 
 */
function deviceTokenFromUserInformation(deviceToken, userId) {
    if (deviceToken == null) {
        console.log(`deviceToken from UserId: ${userId} is null`);
    }
    else {
        console.log(`deviceToken: ${deviceToken} from userId:`, userId);
    }
}

module.exports = {
    invalidCreatedActivity,
    emptyField,
    invalidUpdatedActivity,
    deviceTokenFromUserInformation,
    userDocumentInformation,
    startObserverInformation,
    databaseErrorInformationForDocument,
    databaseSuccessInformationForDocument,
    databaseSuccessInformationForCollection,
    databaseErrorInformationForCollection,
    databaseErrorInformationForDocument,
    forgedChatDocumentInformation,
    noChatExistsInformation,
    noMatchingActivityInformation,
    noUserNameExistsInformation,
    noDeviceTokenExistsInformation,
    noUseCaseExistsInformation
};