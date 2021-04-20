const functions = require('firebase-functions'); 
const admin = require('firebase-admin');
const algoliasearch = require('algoliasearch');
const ALGOLIA_APP_ID = functions.config().algolia.app;
const ALGOLIA_ADMIN_KEY = functions.config().algolia.key;
const client = algoliasearch(ALGOLIA_APP_ID, ALGOLIA_ADMIN_KEY);
const index = client.initIndex('users');

admin.initializeApp(functions.config().firestore);

exports.onUsersCreated = functions.firestore.document('users/{userId}').onCreate((snap, context) => {
  // Get the note document
  const user = snap.data();

  // Add an 'objectID' field which Algolia requires
  user.objectID = snap.id;

  // Write to the algolia index
  const index = client.initIndex('users');
  console.log("create");
  return index.saveObject(user);
});

exports.onUserUpdated = functions.firestore.document('users/{userId}').onUpdate((snap, context) => {
  // Get the note document
  const user = snap.after.data();

  // Add an 'objectID' field which Algolia requires
  user.objectID = snap.after.id;

  // Write to the algolia index
  const index = client.initIndex('users');
  console.log("update");
  return index.saveObject(user);
});

exports.onUserDeleted = functions.firestore.document('users/{userId}').onDelete((snap, context) => {
  // Get the note document
  const user = snap.data();

  // Add an 'objectID' field which Algolia requires
  const id = snap.id;

  // Write to the algolia index
  const index = client.initIndex('users');
  console.log("delete");
  return index.deleteObject(id);
});



