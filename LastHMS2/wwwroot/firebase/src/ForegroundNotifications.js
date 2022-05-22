import "https://www.gstatic.com/firebasejs/9.1.1/firebase-app-compat.js";
import "https://www.gstatic.com/firebasejs/9.1.1/firebase-messaging-compat.js";

console.log("initializing firebase");
firebase.initializeApp({
    apiKey: "AIzaSyBkRNXnaENjbBJm2MNkgT8MUCu9SKsiCq4",

    authDomain: "flutter-asp-notifications.firebaseapp.com",

    projectId: "flutter-asp-notifications",

    storageBucket: "flutter-asp-notifications.appspot.com",

    messagingSenderId: "813339707057",

    appId: "1:813339707057:web:2b1310a0e5c4d2b25e8490",

    measurementId: "G-P3KYB99Q56"

});

const messaging = firebase.messaging();
console.log("getting token");
messaging.getToken({ vapidKey: 'BP6oVB_GV1VhAVqdmaaVmsm-uEiTouyxqVbWAPID0oykbLltjt6Yr_MvP5nRqb6RDsRok7FkMdPauLKpV0OVtBM' }).then((currentToken) => {
    if (currentToken) {
        console.log("tokent = " + currentToken);
        messaging.onMessage((payload) => {
            console.log('Message received. ', payload);
            document.getElementById("notifications").insertAdjacentHTML("afterend",
                "<div>" + payload.notification.title + "</div><br/><div>" + payload.notification.body + "</div>");

            const notificationTitle = payload.notification.title;
            const notificationOptions = {
                body: payload.notification.body,
            };

            self.registration.showNotification(notificationTitle,
                notificationOptions);
        });


    } else {
        // Show permission request UI
        console.log('No registration token available. Request permission to generate one.');
        // ...
    }
}).catch((err) => {
    console.log('An error occurred while retrieving token. ', err);
    // ...
});
messaging.onMessage((payload) => {
    console.log('Message received. ', payload);
    document.getElementById("notifications").insertAdjacentHTML("afterend",
        "<div>" + payload.notification.title + "</div><br/><div>" + payload.notification.body + "</div>");

    const notificationTitle = payload.notification.title;
    const notificationOptions = {
        body: payload.notification.body,
    };

    self.registration.showNotification(notificationTitle,
        notificationOptions);
});