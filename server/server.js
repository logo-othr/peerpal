const crypto = require('crypto');
const admin = require('firebase-admin');
const {
  v4: uuidv4,
} = require('uuid');

const serviceAccount = require("./firebase-admin-sdk.json"); // PP-Test-DB

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});




const db = admin.firestore();

handleChatRequestResponse(db);
handleChatNotification(db);
handleFriendRequestNotification(db);
handleFriendRequestResponse(db);
handleCanceledFriendRequests(db);



// DB Collections
var PRIVATE_USER_DATA_COLLECTION = "privateUserData";
var FRIEND_REQUEST_RESPONSE_COLLECTION = "friendRequestResponse";
var SENT_FRIEND_REQUESTS_COLLECTION = "sentFriendRequests";

var chatIds = new Map();
var deviceTokens = new Map();
var publicUserData = new Map();

async function handleChatNotification(db) {

  console.log('|//////////////////////////////////////////////////////////|');
  console.log('|-------------| Start handleChatNotification |-------------|');
  console.log('|//////////////////////////////////////////////////////////|');

  db.collection(`chatNotifications`)
    .onSnapshot(querySnapshot => {
      querySnapshot.docChanges().forEach(change => {
        if (change.type === 'added') {

          console.log('|------handleChatNotification()------|');
          console.log(change.doc.id, '=>', change.doc.data());

          if (!chatIds.has(change.doc.data().chatId)) {

            //chatId existiert noch nicht
            // oder Server ist apgestürzt und ChatId existiert schon

            if (change.doc.data().chatId == null) {

              //The searchForChatIdInMap()-Method will be deleted in the future.
              //Why this method exists at the moment.
              //UseCase: 
              //The user sends a message before the chat is loaded.
              //A new chat would now be created even though the chat already exists. 
              //However, this method checks if the chat already exists.
              var chatId = searchForChatIdInMap(change);

              if (chatId == null) {

                newChatId = uuidv4();
                createNewChat(db, newChatId, change);

              }
              else {
                updateChat(db, chatId, change);

                if (chatIds.has(chatId)) {
                  if (chatIds.get(chatId).includes(true)) {
                    var userName = getNameFromUser(db, change);

                    //Notification payload
                    const payload = {
                      notification: {
                        title: `Neue Nachricht von ${userName}`,
                        body: change.doc.data().message,
                      },
                      data: {
                        id: change.doc.data().fromId,
                        click_action: 'FLUTTER_NOTIFICATION_CLICK'
                      }
                    }

                    sendPushNotification(change, db, payload);
                  }
                }
              }
            }
            if (change.doc.data().chatId != null) {

              var chatId = change.doc.data().chatId;
              db.collection(`chats`).where('chatId', '==', chatId).get()
                .then((documentQuerySnapshot) => {
                  if (documentQuerySnapshot.empty) {
                    console.log('handleChatNotification() No matching documents');

                    db.collection(`chatNotifications`).doc(change.doc.id).delete()
                    .then(response => { console.log('Successfully delete chatNotification:', response) })
                    .catch(error => { console.log('Error deleting chatNotification:', error) });

                    return;
                  }
                  documentQuerySnapshot.forEach(doc => {

                    chatIds.set(doc.id, [change.doc.data().fromId, change.doc.data().toId, doc.data().chatRequestAccepted]);
                    updateChat(db, doc.id, change);
                    var userName = getNameFromUser(db, change);

                    //Notification payload
                    const payload = {
                      notification: {
                        title: `Neue Nachricht von ${userName}`,
                        body: change.doc.data().message,
                      },
                      data: {
                        id: change.doc.data().fromId,
                        click_action: 'FLUTTER_NOTIFICATION_CLICK'
                      }
                    }
                    sendPushNotification(change, db, payload);

                    db.collection(`chatNotifications`).doc(change.doc.id).delete()
                    .then(response => { console.log('Successfully delete chatNotification:', response) })
                    .catch(error => { console.log('Error deleting chatNotification:', error) });
                    
                  });
                }).catch(error => {console.log('handleChatNotification() error message:', error);});
            }
          }
          else {
            var chatId = change.doc.data().chatId;
            updateChat(db, chatId, change);

            if (chatIds.has(chatId)) {
              if (chatIds.get(chatId).includes(true)) {
                var userName = getNameFromUser(db, change);

                //Notification payload
                const payload = {
                  notification: {
                    title: `Neue Nachricht von ${userName}`,
                    body: change.doc.data().message,
                  },
                  data: {
                    id: change.doc.data().fromId,
                    click_action: 'FLUTTER_NOTIFICATION_CLICK'
                  }
                }

                sendPushNotification(change, db, payload);
              }
            }
          }
        }
      });
    });
}

async function handleChatRequestResponse(db) {

  console.log('|///////////////////////////////////////////////////////////////////|');
  console.log('|-------------------| handleChatRequestResponse |-------------------|');
  console.log('|///////////////////////////////////////////////////////////////////|');

  db.collection(`chatRequestResponse`)
    .onSnapshot(querySnapshot => {
      querySnapshot.docChanges().forEach(change => {
        if (change.type === 'added') {

          console.log('|------handleChatRequestResponse()------|');
          console.log(change.doc.id, '=>', change.doc.data());

          if (change.doc.data().response) {
            db.collection('chats').where('uids', 'array-contains', change.doc.data().fromId).where('startedBy', '==', change.doc.data().toId).get()
              .then((documentQuerySnapshot) => {

                if (documentQuerySnapshot.empty) {
                  console.log('handleChatRequestResponse() No matching documents');

                  db.collection(`chatRequestResponse`).doc(change.doc.id).delete()
                    .then(response => { console.log('Successfully delete chatRequestResponse:', response) })
                    .catch(error => { console.log('Error deleting chatRequestResponse:', error) });

                  return;
                }
                db.collection(`chatRequestResponse`).doc(change.doc.id).delete()
                  .then(response => { console.log('Successfully delete chatRequestResponse:', response) })
                  .catch(error => { console.log('Error deleting chatRequestResponse:', error) });


                documentQuerySnapshot.forEach(doc => {

                  db.collection(`chats`).doc(doc.id).update({
                    'chatRequestAccepted': true,
                  }).then(response => { console.log('Successfully update chatRequestAccepted:', response) })
                    .catch(error => { console.log('Error updating chatRequestAccepted:', error) });


                  var chatId = doc.id
                  if (chatIds.has(chatId)) {
                    var chatProptertiesArray = chatIds.get(chatId)
                    const index = chatProptertiesArray.indexOf(false);
                    //Löscht den Eintrag des chatProptertiesArray an Stelle "index" und updated das Array an "index" 
                    if (index > -1) {
                      chatProptertiesArray.splice(index, 1);
                      chatProptertiesArray.push(true);
                      chatIds.set(chatId, chatProptertiesArray);
                    }
                  }
                });
              }).catch(error => {
                console.log('handleChatRequestResponse() error message:', error);
              });
          }
          else {
            deleteMessageRequest(change.doc.data().fromId, change.doc.data().toId);

            db.collection(`chatRequestResponse`).doc(change.doc.id).delete()
              .then(response => { console.log('Successfully delete chatRequestResponse:', response) })
              .catch(error => { console.log('Error deleting chatRequestResponse:', error) });
          }
        }
      });
    })
}

function deleteMessageRequest(fromId, toId) {
  var killrequest_query = db.collection('chats').where('startedBy', '==', toId).where('uids', 'array-contains', fromId);

  killrequest_query.get().then(function (querySnapshot) {
    querySnapshot.forEach(function (doc) {
      console.log("delete collection: ", db.collection('chats').doc(doc.id).collection('messages').path);

      deleteCollection(db.collection('chats').doc(doc.id).collection('messages').path)

      console.log("delete document: ", doc.ref.path);

      doc.ref.delete()
        .then(response => { console.log('Successfully delete document:', response) })
        .catch(error => { console.log('Error deleting document:', error) });

      deleteChatIdInLocalMap(doc.id);
    });
  }).catch(error => { console.log('Error getting killrequest_query:', error) });
}

function deleteChatIdInLocalMap(chatId) {
  //Delete the chatId from the local map chatIds.
  chatIds.delete(chatId)
}

function deleteCollection(path) {
  db.collection(path).listDocuments().then(val => {
    val.map((val) => {
      val.delete()
    })
  }).then(response => { console.log('Successfully delete Collection:', response) })
    .catch(error => { console.log('Error deleting Collection:', error) });
}

async function handleCanceledFriendRequests(db) {

  console.log('|///////////////////////////////////////////////////////////////////|');
  console.log('|--------------| Start handleCanceledFriendRequests |---------------|');
  console.log('|///////////////////////////////////////////////////////////////////|');

  db.collection(`canceledFriendRequests`)
    .onSnapshot(querySnapshot => {
      querySnapshot.docChanges().forEach(change => {
        if (change.type === 'added') {

          console.log('|------canceledFriendRequests()------|');
          console.log(change.doc.id, '=>', change.doc.data());

          db.collection(`/privateUserData/${change.doc.data().fromId}/sentFriendRequests`).doc(change.doc.data().toId).delete()
            .then(response => { console.log('Successfully delete sentFriendRequest:', response) })
            .catch(error => { console.log('Error deleting sentFriendRequest:', error) });

          db.collection(`/privateUserData/${change.doc.data().toId}/friendRequests`).doc(change.doc.data().fromId).delete()
            .then(response => { console.log('Successfully delete friendRequest:', response) })
            .catch(error => { console.log('Error deleting friendRequest:', error) });

          db.collection(`canceledFriendRequests`).doc(change.doc.id).delete()
            .then(response => { console.log('Successfully delete canceledFriendRequest:', response) })
            .catch(error => { console.log('Error deleting canceledFriendRequest:', error) });
        }
      });
    });
}

async function handleFriendRequestNotification(db) {

  console.log('|///////////////////////////////////////////////////////////////////|');
  console.log('|-------------| Start handleFriendRequestNotification |-------------|');
  console.log('|///////////////////////////////////////////////////////////////////|');

  db.collection(`friendRequestNotifications`)
    .onSnapshot(querySnapshot => {
      querySnapshot.docChanges().forEach(change => {
        if (change.type === 'added') {

          console.log('|------handleFriendRequestNotification()------|');
          console.log(change.doc.id, '=>', change.doc.data());

          db.collection(`/privateUserData/${change.doc.data().toId}/friendRequests`).doc(change.doc.data().fromId).set({})
            .then(response => { console.log('Successfully set friendRequests:', response) })
            .catch(error => { console.log('Error setting friendRequests:', error) });


          db.collection(`/privateUserData/${change.doc.data().fromId}/sentFriendRequests`).doc(change.doc.data().toId).set({})
            .then(response => { console.log('Successfully set sentFriendRequest:', response) })
            .catch(error => { console.log('Error setting sentFriendRequest:', error) });

          db.collection(`friendRequestNotifications`).doc(change.doc.id).delete()
            .then(response => { console.log('Successfully delete friendRequestNotification:', response) })
            .catch(error => { console.log('Error deleting friendRequestNotification:', error) });

          var userName = getNameFromUser(db, change);

          //Notification payload
          const payload = {
            notification: {
              title: 'Freundschaftsanfrage',
              body: `Neue Freundschaftsanfrage von ${userName}`,
            },
            data: {
              id: change.doc.data().fromId,
              click_action: 'FLUTTER_NOTIFICATION_CLICK'
            }
          }

          sendPushNotification(change, db, payload);
        }
      });
    });
}


async function handleFriendRequestResponse(db) {

  console.log('|///////////////////////////////////////////////////////////////////|');
  console.log('|---------------| Start handleFriendRequestResponse |---------------|');
  console.log('|///////////////////////////////////////////////////////////////////|');

  db.collection(`friendRequestResponse`)
    .onSnapshot(querySnapshot => {
      querySnapshot.docChanges().forEach(change => {
        if (change.type === 'added') {

          var data = change.doc.data();
          console.log('|------handleFriendRequestResponse()------|');
          console.log(change.doc.id, '=>', data);
          var friendRequestOwnerId = data.fromId;
          var friendRequestAnswerer = data.toId;
          var friendRequestId = change.doc.id;

          if (data.response) {
            db.collection(`${PRIVATE_USER_DATA_COLLECTION}/${friendRequestAnswerer}/${SENT_FRIEND_REQUESTS_COLLECTION}`).doc(friendRequestOwnerId)
              .get()
              .then(documentQuerySnapshot => {
                acceptFriendRequest(friendRequestOwnerId, friendRequestAnswerer, friendRequestId, documentQuerySnapshot.id);
              })
              .catch(error => {
                console.log('handleFriendRequestResponse() error message:', error);
              })
          }
          else {
            console.log("friendRequestOwnerId:", friendRequestOwnerId);
            console.log("friendRequestAnswerer:", friendRequestAnswerer);
            console.log("friendRequestId:", friendRequestId);
            denyFriendRequest(friendRequestOwnerId, friendRequestAnswerer, friendRequestId);
          }
        }
      });
    });
}

function denyFriendRequest(denyFriendRequestSenderId, friendRequestSenderId, requestId) {
  db.collection(`/${PRIVATE_USER_DATA_COLLECTION}/${denyFriendRequestSenderId}/friendRequests`).doc(friendRequestSenderId).delete()
    .then(response => { console.log('Successfully delete friendRequestSenderId:', response) })
    .catch(error => { console.log('Error deleting friendRequestSenderId:', error) });

  db.collection(`/${PRIVATE_USER_DATA_COLLECTION}/${friendRequestSenderId}/sentFriendRequests`).doc(denyFriendRequestSenderId).delete()
    .then(response => { console.log('Successfully delete denyFriendRequestSenderId:', response) })
    .catch(error => { console.log('Error deleting denyFriendRequestSenderId:', error) });

  db.collection(FRIEND_REQUEST_RESPONSE_COLLECTION).doc(requestId).delete()
    .then(response => { console.log('Successfully delete requestId:', response) })
    .catch(error => { console.log('Error deleting requestId:', error) });
}

function acceptFriendRequest(acceptFriendRequestSenderId, friendRequestSenderId, friendRequestId, documentId) {
  console.log(documentId, '==', acceptFriendRequestSenderId);
  if (documentId == acceptFriendRequestSenderId) {
    // ToDo: use transaction?
    db.collection(`/privateUserData/${friendRequestSenderId}/friends`).doc(acceptFriendRequestSenderId).set({ 'friendId': acceptFriendRequestSenderId })
      .then(response => { console.log('Successfully set friendId:', response) })
      .catch(error => { console.log('Error setting friendId:', error) });

    db.collection(`/privateUserData/${acceptFriendRequestSenderId}/friends`).doc(friendRequestSenderId).set({ 'friendId': friendRequestSenderId })
      .then(response => { console.log('Successfully set friendId:', response) })
      .catch(error => { console.log('Error setting friendId:', error) });

    db.collection(`/privateUserData/${acceptFriendRequestSenderId}/friendRequests`).doc(friendRequestSenderId).delete()
      .then(response => { console.log('Successfully delete friendRequestSenderId:', response) })
      .catch(error => { console.log('Error deleting friendRequestSenderId:', error) });

    db.collection(`/privateUserData/${friendRequestSenderId}/${SENT_FRIEND_REQUESTS_COLLECTION}`).doc(acceptFriendRequestSenderId).delete()
      .then(response => { console.log('Successfully delete acceptFriendRequestSenderId:', response) })
      .catch(error => { console.log('Error deleting acceptFriendRequestSenderId:', error) });

    db.collection(FRIEND_REQUEST_RESPONSE_COLLECTION).doc(friendRequestId).delete()
      .then(response => { console.log('Successfully delete friendRequestId:', response) })
      .catch(error => { console.log('Error deleting friendRequestId:', error) });
  }

}

function searchForChatIdInMap(change) {

  var chatId = change.doc.data().chatId;
  var breakForEach = false;

  console.log('|------searchForChatIdInMap()------|')
  chatIds.forEach((ids, existingChatId) => {

    console.log(ids, existingChatId)

    if (breakForEach) {
      return;
    }
    if (ids.includes(change.doc.data().fromId) && ids.includes(change.doc.data().toId)) {
      console.log('Chat exist', '=>', existingChatId);
      chatId = existingChatId;
      breakForEach = true;
    }
  });
  return chatId;
}


function createNewChat(db, newChatId, change) {

  db.collection(`/privateUserData/${change.doc.data().fromId}/friends`).where('friendId', '==', change.doc.data().toId).get()
    .then((documentQuerySnapshot) => {
      if (documentQuerySnapshot.empty) {
        console.log('chatRequestAccepted = false');
        console.log('createNewChat() No friend exist');
        var chatRequestAccepted = false;
        chatIds.set(newChatId, [change.doc.data().fromId, change.doc.data().toId, chatRequestAccepted]);
        var userName = getNameFromUser(db, change);

        //Notification payload
        const payload = {
          notification: {
            title: `Nachrichtenanfrage`,
            body: `Neue Nachrichtenanfrage von ${userName}`
          },
          data: {
            id: change.doc.data().fromId,
            click_action: 'FLUTTER_NOTIFICATION_CLICK'
          }
        }

        sendPushNotification(change, db, payload);

        createChatCollectionInDatabase(db, newChatId, change, chatRequestAccepted);
        return;
      }
      documentQuerySnapshot.forEach(doc => {
        console.log('chatRequestAccepted = true');
        var chatRequestAccepted = true;
        chatIds.set(newChatId, [change.doc.data().fromId, change.doc.data().toId, chatRequestAccepted]);

        var userName = getNameFromUser(db, change);

        //Notification payload
        const payload = {
          notification: {
            title: `Neue Nachricht von ${userName}`,
            body: change.doc.data().message,
          },
          data: {
            id: change.doc.data().fromId,
            click_action: 'FLUTTER_NOTIFICATION_CLICK'
          }
        }

        sendPushNotification(change, db, payload);

        createChatCollectionInDatabase(db, newChatId, change, chatRequestAccepted);

      });
    }).catch(error => {console.log('createNewChat() error message:', error);})

}


function createChatCollectionInDatabase(db, newChatId, change, chatRequestAccepted) {

  db.collection(`chats`).doc(newChatId).set({
    uids: [
      change.doc.data().fromId,
      change.doc.data().toId,
    ],
    lastMessage: {
      'userId': change.doc.data().fromId,
      'timestamp': change.doc.data().timestamp,
      'message': change.doc.data().message,
      'type': change.doc.data().type,
    },
    'lastUpdated': change.doc.data().timestamp,
    'startedBy': change.doc.data().fromId,
    'chatId': newChatId,
    'chatRequestAccepted': chatRequestAccepted,
  }).then(response => {console.log('Successfully wrote new Chatdocument:', response)})
    .catch(error => {console.log('Error writting new Chatdocument:', error)});

  db.collection(`/chats/${newChatId}/messages`).doc(change.doc.id).set(
    {
      'userId': change.doc.data().fromId,
      'timestamp': change.doc.data().timestamp,
      'message': change.doc.data().message,
      'type': change.doc.data().type,
    }
  ).then(response => {console.log('Successfully wrote message:', response)})
    .catch(error => {console.log('Error writting message:', error)});

  db.collection(`chatNotifications`).doc(change.doc.id).delete()
    .then(response => {console.log('Successfully delete chatNotification:', response)})
    .catch(error => {console.log('Error deleting chatNotification:', error)});
}


function updateChat(db, chatId, change) {

  db.collection(`chats`).doc(chatId).update({
    lastMessage: {
      'userId': change.doc.data().fromId,
      'timestamp': change.doc.data().timestamp,
      'message': change.doc.data().message,
      'type': change.doc.data().type,
    },
    'lastUpdated': change.doc.data().timestamp,
  }).then(response => {console.log('Successfully update Chat:', response)})
  .catch(error => {console.log('Error updating Chat:', error)});

  db.collection(`/chats/${chatId}/messages`).doc(change.doc.id).set(
    {
      'userId': change.doc.data().fromId,
      'timestamp': change.doc.data().timestamp,
      'message': change.doc.data().message,
      'type': change.doc.data().type,
    }
  ).then(response => { console.log('Successfully wrote message:', response) })
    .catch(error => { console.log('Error writting message:', error) });

  db.collection(`chatNotifications`).doc(change.doc.id).delete()
    .then(response => { console.log('Successfully delete chatNotification:', response) })
    .catch(error => { console.log('Error deleting chatNotification:', error) });

}


function getNameFromUser(db, change) {

  if (publicUserData.has(change.doc.data().fromId)) {
    if (publicUserData.get(change.doc.data().fromId).empty && publicUserData.get(change.doc.data().fromId) == null) {
      console.log('getNameFromUser() No userName exist')
      return;
    }
    var userName = publicUserData.get(change.doc.data().fromId);
    console.log(`publicUserName: ${userName}`);
    return userName;
  }
  else {
    db.collection('publicUserData').doc(change.doc.data().fromId).get()
      .then(documentQuerySnapshot => {
        var userName = documentQuerySnapshot.data().name;
        console.log(`publicUser: ${userName}`);
        publicUserData.set(documentQuerySnapshot.id, documentQuerySnapshot.data().name);
        return userName;

      })
      .catch(error => { console.log('getNameFromUser() error message:', error); })
  }

}

function sendPushNotification(change, db, payload) {
  if (deviceTokens.has(change.doc.data().toId)) {
    if (deviceTokens.get(change.doc.data().toId).empty || deviceTokens.get(change.doc.data().toId) == null) {
      console.log('sendPushNotification() No deviceToken exist for User')
      return;
    }
    var deviceToken = deviceTokens.get(change.doc.data().toId);
    console.log(`deviceToken: ${deviceToken}`);
    admin.messaging().sendToDevice(deviceToken, payload)
      .then(response => { console.log('Successfully sent message:', response) })
      .catch(error => { console.log('Error sending message:', error) })
  }
  else {
    db
      .collection('privateUserData').doc(change.doc.data().toId).get()
      .then(documentQuerySnapshot => {

        var deviceToken = documentQuerySnapshot.data().pushToken;

        deviceTokens.set(documentQuerySnapshot.id, deviceToken);
        console.log(`deviceToken: ${deviceToken}`);

        admin.messaging().sendToDevice(deviceToken, payload)
          .then(response => {
            console.log('Successfully sent message:', response)
          }).catch(error => { console.log('Error sending message:', error) })
      })
      .catch(error => {
        console.log('sendPushNotification() error message:', error);
      })
  }
}