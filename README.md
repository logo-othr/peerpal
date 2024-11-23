# PeerPAL

(english version below)

## PeerPAL –  Digitale Vernetzung bei Aphasie zur Steigerung der Lebensqualität
Förderkennzeichen: FKZ 13FH077SA8 (OTH Regensburg) und FKZ 13FH077SB8 (KH Mainz).

### Einleitung
**Beschreibung**  
PeerPAL ist Verbundprojekt der Ostbayerischen Technischen Hochschule (OTH) Regensburg und der Katholischen Hochschule (KH) Mainz. Das Akronym PeerPAL steht dabei für Peer-to-Peer-Unterstützung bei Aphasie zur Steigerung der Lebensqualität. Eine Aphasie ist eine erworbene Sprachstörung, in den meisten Fällen ausgelöst durch einen Schlaganfall. Peers sind Gleichgesinnte, in diesem Fall Menschen, die ebenfalls eine Aphasie haben.

### Ziele des Projekts
PeerPAL verfolgt die folgenden wesentlichen Ziele:

- Entwicklung eines barrierefreien digitalen sozialen Netzwerkes für Menschen mit einer Aphasie
- "Peer"-Austausch und Unterstützung untereinander
- Anbahnung gemeinsamer Aktivitäten und analoger Treffen
- Steigerung der Lebensqualität und sozialen Teilhabe von Menschen mit Aphasie
- Gewinn von Erkenntnissen zur Nutzung digitaler Netzwerke unter der Bedingung, dass eine sprachliche Beeinträchtigung vorliegt

### Kurzbeschreibung der Funktionalität
Die PeerPAL-App dient Menschen mit Aphasie, sich gegenseitig über die App kennenzulernen, miteinander zu interagieren und – wenn gewünscht – sich analog zu treffen. Die App ist in fünf Bereiche unterteilt: Aktivitäten, Entdecken (andere Nutzende suchen und finden), Freunde, Chat und Einstellungen.

Das Besondere der App ist, dass sie gemeinsam mit Menschen mit Aphasie entwickelt wurde. So wurden die Bedürfnisse und Wünsche der Zielgruppe bestmöglich in den Entwicklungsprozess integriert. Auf diese Weise bietet die App beispielsweise die Möglichkeit, einfache Textbausteine im Chat zu verwenden, um trotz sprachlicher Beeinträchtigung eine Interaktion mit einer anderen Person starten und aufrechterhalten zu können. Zudem wurde für jeden Bereich der App ein Hilfevideo erstellt, das von den Nutzenden abgespielt werden kann, wenn Hilfe gewünscht oder erforderlich ist. In den Videos wird die jeweilige Funktion kleinschrittig und in leichter Sprache erklärt.

Über die für andere Messenger-Dienste übliche Chat-Funktion hinaus gibt es in der PeerPAL-App zudem einen Bereich, in dem Aktivitäten geplant werden können. So können sich die nutzenden Menschen mit Aphasie beispielsweise zum Kaffeetrinken oder für einen Museumsbesuch verabreden. Insgesamt steht eine Auswahl von 19 Aktivitäten zur Verfügung. Alle Aktivitäten sind dabei mit Icons dargestellt, sodass Personen mit Aphasie trotz sprachlicher Beeinträchtigung eine Aktivität planen können. Anschließend steht es ihnen frei, ob sie nur bestimmte Personen (aus ihrer Freundesliste) zu dieser Aktivität einladen wollen oder ob sie die Aktivität öffentlich posten, sodass theoretisch alle Nutzenden teilnehmen können.

Genauere Informationen zur App und zur Studie sind im publizierten Studienprotokoll unter [https://www.frontiersin.org/journals/communication/articles/10.3389/fcomm.2023.1187233/full](https://www.frontiersin.org/journals/communication/articles/10.3389/fcomm.2023.1187233/full) zu finden.

### Voraussetzungen

- Dart & Flutter
- Entsprechend leistungsfähiger Rechner/Laptop
- Umgebung für einen NodeJS-Server
- Firebase Firestore Database, Firebase Authentication, Firestore Storage, Firebase Notifications
- Smartphone (Android/iOS)


## Installation

Um den Quellcode auf Ihrem System zu kompilieren, werden Dart und Flutter benötigt. Flutter kann unter Verwendung der offiziellen Anleitung installiert werden.

Das Projekt kann wie folgt abgerufen und gestartet werden:

$ git clone https://github.com/logo-othr/peerpal.git

$ cd peerpal

$ flutter pub get

$ flutter run



Die *.g.dart Dateien können mit diesem Befehl neu generiert werden. 

$ flutter pub run build_runner build --delete-conflicting-outputs

## Server und Datenbank

- NodeJS Server zur Kommunikation mit der Datenbank und Versenden von Notifikationen
- Firebase Firestore Datenbank als Backend

## Weiterentwicklung

Folgende Punkte wurden von der Zielgruppe gewünscht, wurden aber bis zum Projektabschluss nicht umgesetzt:

- Liste am Ende der Readme

## Datenschutz

Folgende Daten können in der App angegeben werden:

- E-Mail-Adresse
- Telefonnummer
- Benutzername
- Alter (in Jahren)
- Profilbild
- Kontakte in der App
- Nachrichten mit anderen Nutzenden in der App
- Geplante Aktivitäten
- Teilnahmestatus vom Nutzenden zu Aktivitäten

Weiterhin wird Firebase als Datenbank, zur Authentifizierung und Autorisierung, als Speicher und für Benachrichtigungen eingesetzt. Informationen zum Datenschutz von Google Firebase können aus der Datenschutzerklärung von Firebase entnommen werden.

## Sponsoren, Mitwirkende und Danksagung

Das Verbundprojekt wurde vom Bundesministerium für Bildung und Forschung (BMBF) im Rahmen der Förderrichtlinie „Verbesserung der Lebensqualität in Stadt und Land durch soziale Innovationen“ (FH-Sozial 2018) gefördert. Der ursprünglich beantragte und genehmigte Förderzeitraum von 3 Jahren (Dezember 2020 bis November 2023) wurde kostenneutral um ein weiteres Jahr verlängert (bis 30. November 2024).
Förderkennzeichen: FKZ 13FH077SA8 (OTH Regensburg) und FKZ 13FH077SB8 (KH Mainz).

Diese Personen waren an der Erstellung des Projektes beteiligt und haben ihr Einverständnis für die Nennung gegeben. Rechtlicher Hinweis: §13 Urheberrechtsgesetz (https://dejure.org/gesetze/UrhG/13.html)

### Projektleitung

- Prof.in Dr. Norina Lauer
- Prof.in Dr. Sabine Corsten

### Wissenschaftliche Mitarbeitende:

Christina Kurfeß

Maria Knieriemen

Almut Plath

Maren Nickel


### Technische Mitarbeitende:

Daniel Kreiter

### Studentische Hilfskräfte und Bacheloranden:

Franziska Gärtner

Sarah Gomez

Anna Holzammer

Larisa Malanchev

Isabell Starke

Viktoria Thedens

Lena Werner

Andreas Rothballer



Es gab weitere Mitwirkende, die aber namentlich nicht genannt werden möchten.

Vielen herzlichen Dank für Eure Unterstützung des Projekts!

## Mitwirken

Dieses Projekt wurde erfolgreich abgeschlossen und wird von uns in genau dieser Form nicht weiter aktiv entwickelt. Wir schätzen jedoch das Interesse der Open Source Community. Wir freuen uns, wenn Sie einen Fork erstellen und eigene Anpassungen vornehmen. Wir freuen uns darauf zu sehen, welche neuen Ideen und Verbesserungen aus der Community entstehen.

## Lizenz

Die Lizenzdatei ist im Repository zu finden.

## Genutzte Dart und Flutter Packages

- [cupertino_icons (MIT)](https://pub.dev/packages/cupertino_icons/license)
- [flow_builder (MIT)](https://pub.dev/packages/flow_builder/license)
- [flutter_bloc (MIT)](https://pub.dev/packages/flutter_bloc/license)
- [equatable (MIT)](https://pub.dev/packages/equatable/license)
- [meta (BSD-3-Clause)](https://pub.dev/packages/meta/license)
- [formz (MIT)](https://pub.dev/packages/formz/license)
- [cloud_firestore (BSD-3-Clause)](https://pub.dev/packages/cloud_firestore/license)
- [firebase_storage (BSD-3-Clause)](https://pub.dev/packages/firebase_storage/license)
- [firebase_messaging (BSD-3-Clause)](https://pub.dev/packages/firebase_messaging/license)
- [firebase_auth (BSD-3-Clause)](https://pub.dev/packages/firebase_auth/license)
- [firebase_core (BSD-3-Clause)](https://pub.dev/packages/firebase_core/license)
- [email_validator (MIT)](https://pub.dev/packages/email_validator/license)
- [zxcvbn (MIT)](https://pub.dev/packages/zxcvbn/license)
- [logger (MIT)](https://pub.dev/packages/logger/license)
- [image_picker (Apache-2.0, BSD-2-Clause)](https://pub.dev/packages/image_picker/license)
- [image_cropper (BSD-3-Clause)](https://pub.dev/packages/image_cropper/license)
- [uuid (MIT)](https://pub.dev/packages/uuid/license)
- [cached_network_image (MIT)](https://pub.dev/packages/cached_network_image/license)
- [enum_to_string (MIT)](https://pub.dev/packages/enum_to_string/license)
- [json_annotation (BSD-3-Clause)](https://pub.dev/packages/json_annotation/license)
- [intl (BSD-3-Clause)](https://pub.dev/packages/intl/license)
- [flutter_local_notifications (BSD-3-Clause)](https://pub.dev/packages/flutter_local_notifications/license)
- [rxdart (Apache-2.0)](https://pub.dev/packages/rxdart/license)
- [get_it (MIT)](https://pub.dev/packages/get_it/license)
- [flutter_datetime_picker_plus (MIT)](https://pub.dev/packages/flutter_datetime_picker_plus/license)
- [shared_preferences (BSD-3-Clause)](https://pub.dev/packages/shared_preferences/license)
- [flutter_keyboard_visibility (MIT)](https://pub.dev/packages/flutter_keyboard_visibility/license)
- [url_launcher (BSD-3-Clause)](https://pub.dev/packages/url_launcher/license)
- [flutter_phone_direct_caller (MIT)](https://pub.dev/packages/flutter_phone_direct_caller/license)
- [mockito (Apache-2.0)](https://pub.dev/packages/mockito/license)


## Material Design Icons

Die App nutzt Material Design Icons aus Flutter.

## Kontakt

Nachdem die Projektlaufzeit des eigentlichen Forschungsprojekts abgelaufen ist, werden die Anwendung sowie dieses Repository nicht mehr vom PeerPAL-Team betreut. Falls Sie das Projekt selbstständig weiterentwickeln wollen, können Sie gerne einen Fork des Repository erstellen.

### Herausgeber:

**Ostbayerische Technische Hochschule Regensburg (OTH)**  
Seybothstr. 2  
93053 Regensburg  
[https://www.oth-regensburg.de](https://www.oth-regensburg.de)

**Katholische Hochschule Mainz (KH)**  
Saarstr. 3  
55122 Mainz  
[https://www.kh-mz.de](https://www.kh-mz.de)

### Kontaktpersonen:

**Frau Prof.in Dr. Norina Lauer**  
Tel.: +49 941 943-1087  
Fax: +49 941 943-1468  
E-Mail: norina.lauer@oth-regensburg.de  
Ostbayerische Technische Hochschule Regensburg (OTH)  
Seybothstr. 2  
93053 Regensburg

**Frau Prof.in Dr. Sabine Corsten**  
Tel.: 06131 – 289 44 540  
Fax: 06131 – 289 44 8 540  
E-Mail: sabine.corsten@kh-mz.de  
Katholische Hochschule Mainz (KH)  
Saarstr. 3  
55122 Mainz


# English

## Description

PeerPAL is a collaborative project between the Ostbayerischen Technischen Hochschule (OTH) Regensburg and the Katholischen Hochschule (KH) Mainz. The acronym PeerPAL stands for Peer-to-Peer Support in Aphasia to Enhance Quality of Life. Aphasia is an acquired language disorder, most commonly caused by a stroke. Peers are like-minded individuals, in this case, people who also have aphasia.

## Project Goals

PeerPAL aims to achieve the following key objectives:
- Development of an accessible digital social network for people with aphasia
- "Peer" exchange and mutual support
- Initiation of joint activities and in-person meetings
- Enhancement of the quality of life and social participation of people with aphasia
- Gaining insights into the use of digital networks under the condition of language impairment

## Description of Functionality

The PeerPAL app is designed for people with aphasia to get to know each other, interact, and, if desired, meet in person. The app is divided into five sections: Activities, Discover (search and find other users), Friends, Chat, and Settings.

What makes the app special is that it was developed in collaboration with people with aphasia. Their needs and wishes were optimally integrated into the development process. For example, the app offers the possibility to use simple text modules in the chat to start and maintain interaction with another person despite language impairment. Additionally, each section of the app has a help video that users can play if help is needed. These videos explain the respective functions step-by-step and in simple language.

Beyond the usual chat function found in other messaging services, the PeerPAL app includes a section for planning activities. Users with aphasia can arrange to meet for coffee or visit a museum, for example. There is a selection of 19 activities available, all represented by icons, so that individuals with aphasia can plan activities despite language difficulties. They can then choose whether to invite only specific people (from their friends list) to the activity or to post the activity publicly, allowing all users to participate if they wish.

More detailed information about the app and the study can be found in the published study protocol at [https://www.frontiersin.org/journals/communication/articles/10.3389/fcomm.2023.1187233/full](https://www.frontiersin.org/journals/communication/articles/10.3389/fcomm.2023.1187233/full).

## Requirements

- Dart & Flutter
- Sufficiently powerful computer/laptop
- Environment for a NodeJS server
- Firebase Firestore Database, Firebase Authentication, Firestore Storage, Firebase Notifications
- Smartphone (Android/iOS)

## Installation

To compile the source code on your system, you need Dart and Flutter. Flutter can be installed using the official guide.

The project can be retrieved and started as follows:


$ git clone https://github.com/logo-othr/peerpal.git

$ cd peerpal

$ flutter pub get

$ flutter run

The *.g.dart files can be regenerated with this command:

$ flutter pub run build_runner build --delete-conflicting-outputs



## Server and Database

- NodeJS server for communication with the database and sending notifications
- Firebase Firestore Database as backend

## Further Development

The following points were requested by the target group but were not implemented by the end of the project:

- Listed at the end of the README

## Data Privacy

The following data can be provided in the app:

- Email address
- Phone number
- Username
- Age (in years)
- Profile picture
- Contacts in the app
- Messages with other users in the app
- Planned activities
- User's participation status in activities

Additionally, Firebase is used for database, authentication and authorization, storage, and notifications. Information about Google's Firebase data privacy can be found in Firebase's privacy policy.

## Sponsors, Contributors, and Acknowledgements

The collaborative project was funded by the Federal Ministry of Education and Research (BMBF) as part of the funding guideline "Verbesserung der Lebensqualität in Stadt und Land durch soziale Innovationen" (FH-Sozial 2018). The originally applied and approved funding period of 3 years (December 2020 to November 2023) was extended by one more year without additional costs (until November 30, 2024). Grant numbers: FKZ 13FH077SA8 (OTH Regensburg) and FKZ 13FH077SB8 (KH Mainz).

The following individuals were involved in the creation of the project and have given their consent to be mentioned. Legal notice: [§13 Copyright Act](https://dejure.org/gesetze/UrhG/13.html)

### Project Management

Prof. Dr. Norina Lauer  
Prof. Dr. Sabine Corsten  

### Scientific employees:

Christina Kurfeß

Maria Knieriemen

Almut Plath

Maren Nickel


### Technical employees:

Daniel Kreiter

### Student assistants and bachelor students:

Franziska Gärtner

Sarah Gomez

Anna Holzammer

Larisa Malanchev

Isabell Starke

Viktoria Thedens

Lena Werner

Andreas Rothballer


There were additional contributors who prefer not to be named. Thank you very much for your support of the project!

## Contribute

This project has been successfully completed and is not being actively developed further in its current form. However, we appreciate the interest of the Open Source Community. We welcome you to create a fork and make your own adjustments. We look forward to seeing the new ideas and improvements that emerge from the community.

## License

The license file can be found in the repository.

## Dart and Flutter Packages Used


- [cupertino_icons (MIT)](https://pub.dev/packages/cupertino_icons/license)
- [flow_builder (MIT)](https://pub.dev/packages/flow_builder/license)
- [flutter_bloc (MIT)](https://pub.dev/packages/flutter_bloc/license)
- [equatable (MIT)](https://pub.dev/packages/equatable/license)
- [meta (BSD-3-Clause)](https://pub.dev/packages/meta/license)
- [formz (MIT)](https://pub.dev/packages/formz/license)
- [cloud_firestore (BSD-3-Clause)](https://pub.dev/packages/cloud_firestore/license)
- [firebase_storage (BSD-3-Clause)](https://pub.dev/packages/firebase_storage/license)
- [firebase_messaging (BSD-3-Clause)](https://pub.dev/packages/firebase_messaging/license)
- [firebase_auth (BSD-3-Clause)](https://pub.dev/packages/firebase_auth/license)
- [firebase_core (BSD-3-Clause)](https://pub.dev/packages/firebase_core/license)
- [email_validator (MIT)](https://pub.dev/packages/email_validator/license)
- [zxcvbn (MIT)](https://pub.dev/packages/zxcvbn/license)
- [logger (MIT)](https://pub.dev/packages/logger/license)
- [image_picker (Apache-2.0, BSD-2-Clause)](https://pub.dev/packages/image_picker/license)
- [image_cropper (BSD-3-Clause)](https://pub.dev/packages/image_cropper/license)
- [uuid (MIT)](https://pub.dev/packages/uuid/license)
- [cached_network_image (MIT)](https://pub.dev/packages/cached_network_image/license)
- [enum_to_string (MIT)](https://pub.dev/packages/enum_to_string/license)
- [json_annotation (BSD-3-Clause)](https://pub.dev/packages/json_annotation/license)
- [intl (BSD-3-Clause)](https://pub.dev/packages/intl/license)
- [flutter_local_notifications (BSD-3-Clause)](https://pub.dev/packages/flutter_local_notifications/license)
- [rxdart (Apache-2.0)](https://pub.dev/packages/rxdart/license)
- [get_it (MIT)](https://pub.dev/packages/get_it/license)
- [flutter_datetime_picker_plus (MIT)](https://pub.dev/packages/flutter_datetime_picker_plus/license)
- [shared_preferences (BSD-3-Clause)](https://pub.dev/packages/shared_preferences/license)
- [flutter_keyboard_visibility (MIT)](https://pub.dev/packages/flutter_keyboard_visibility/license)
- [url_launcher (BSD-3-Clause)](https://pub.dev/packages/url_launcher/license)
- [flutter_phone_direct_caller (MIT)](https://pub.dev/packages/flutter_phone_direct_caller/license)
- [mockito (Apache-2.0)](https://pub.dev/packages/mockito/license)

## Material Design Icons

The app uses Material Design Icons from Flutter.

## Contact

After the project period of the original research project has ended, the application and this repository will no longer be maintained by the PeerPAL team. If you wish to further develop the project independently, you are welcome to create a fork of the repository.

### Publisher:

**Ostbayerische Technische Hochschule Regensburg (OTH)**  
Seybothstr. 2  
93053 Regensburg  
[https://www.oth-regensburg.de](https://www.oth-regensburg.de)

**Katholische Hochschule Mainz (KH)**  
Saarstr. 3  
55122 Mainz  
[https://www.kh-mz.de](https://www.kh-mz.de)

### Contact:

**Frau Prof.in Dr. Norina Lauer**  
Tel.: +49 941 943-1087  
Fax: +49 941 943-1468  
E-Mail: norina.lauer@oth-regensburg.de  
Ostbayerische Technische Hochschule Regensburg (OTH)  
Seybothstr. 2  
93053 Regensburg

**Frau Prof.in Dr. Sabine Corsten**  
Tel.: 06131 – 289 44 540  
Fax: 06131 – 289 44 8 540  
E-Mail: sabine.corsten@kh-mz.de  
Katholische Hochschule Mainz (KH)  
Saarstr. 3  
55122 Mainz




# Table with all bugs and additional improvements, mentioned by the participants

## Bugs and improvements regarding the app area chat

| B/I | C | N | Bug / Current status                                                                                                           | Improvement suggestion                                                                              |
|-----|---|---|--------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------|
| B   |   | X | Two chats with the same user are displayed. This happens when two users independently start a new chat while one or both of them do not have internet access. | Remove bug.                                                                                         |
| B   | X |   | Red dots are always displayed when you open the chat area, whether you have read the messages or not. A red dot usually indicates an unread message. | Remove bug.                                                                                         |
| I   |   | X | When a new message appears on the lock screen and the user clicks the message, the general chat area opens.                   | Open the specific chat with the user who sent the message, as in other messengers.                  |
| I   |   | X | When users open the chat area, it says there are no chats while it loads. After a short wait, chats will appear.              | Add a loading screen.                                                                               |
| I   |   | X | The text box is too small.                                                                                                    | Increase the size of the text box.                                                                  |
| B   |   | X | Some pictures sent are cropped. This means that you cannot see the whole picture.                                             | Remove bug.                                                                                         |
| I   |   | X | Images are too small and cannot be enlarged.                                                                                  | Ability to enlarge images, as in other messengers.                                                  |
| I   |   | X | Only one picture can be selected and sent at a time.                                                                          | Ability to select multiple pictures and send them at once, as in other messengers.                  |
| I   |   | X | The camera cannot be accessed via chat.                                                                                       | Ability to access the camera directly from the chat to take and send a picture, as in other messengers. |
| I   |   | X | Messages and pictures cannot be deleted from chat once they have been sent.                                                   | Ability to delete messages and images from the chat, as in other messengers.                        |
| I   |   | X | There are no confirmations for sending and reading messages.                                                                  | Ability to display send and read confirmations, for example, with tick marks, as in other messengers. |
| I   |   | X | Messages are not time stamped.                                                                                                | Insert timestamps, as in other messengers.                                                          |
| I   |   | X | Voice messages cannot be sent.                                                                                                | Ability to send voice messages, as in other messengers.                                             |
| I   |   | X | Video calls cannot be made.                                                                                                   | Ability to make video calls, as in other messengers.                                                |
| I   |   | X | Group chats are not available.                                                                                                | Availability of group chats, as in other messengers.                                                |
| I   |   | X | Links in chat cannot be clicked (restricted for security reasons).                                                            | Ability to click on links in chat (e.g., a link to Google Maps) and be transferred directly, as in other messengers. |
| I   |   | X | Messages cannot be read aloud by the app.                                                                                     | Option to have messages read aloud by the app.                                                      |
| I   |   | X | There are predefined text modules, but you cannot add your own text modules.                                                  | Ability to add your own text modules.                                                               |
| I   |   | X | You cannot block other app users.                                                                                             | Ability to block other users in the app, as in other messengers.                                    |
| I   |   | X | Only English designations are offered (e.g., to copy and paste text).                                                         | Designations should be offered in German.                                                           |

## Bugs and improvements regarding the app area activities

| B/I | C | N | Bug / Current status                                                                                                           | Improvement suggestion                                                                              |
|-----|---|---|--------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------|
| I   |   | X | Only users of the app can be invited to activities.                                                                            | Ability to invite people outside the app to an activity.                                            |
| I   |   | X | You cannot change the theme of an activity once it has been created.                                                           | Ability to change an activity after it has been created (e.g., change a walk to a restaurant visit). |
| I   |   | X | Cancelled activities no longer appear.                                                                                        | Leave a cancelled activity visible, but greyed out, so that everyone can see that it has been cancelled. |
| I   |   | X | You cannot share pictures of a completed activity through the activity.                                                       | Ability to upload pictures of a completed activity to share with other participants.                |
| B   |   | X | When creating a new activity, the date is displayed in the usual (for Germany) day-month-year format. However, it switches to the year-month-day format to enter the date of the meeting. | Adjustment to always display a standardised day-month-year format.                                  |
| I   |   | X | Link activities to your calendar.                                                                                             | Ability to link the app to a calendar app on the smartphone so that activities can be added directly to your calendar. |
| I   |   | X | Only one activity can be selected for each scheduled face-to-face meeting.                                                    | Possibility to combine different activities.                                                        |
| I   |   | X | When planning an activity, you always need to provide information about the city, meeting point and so on.                    | Ability to save individual information for activities, so that, for example, the city does not have to be entered every time, but is suggested based on frequent use. |
| B   |   | X | There is a back button in the top left corner until you have entered the location and street for the activity. From then on there is no back button. | This button should be included in all steps of planning an activity.                                |
| I   |   | X | You can only set a date for an activity, you cannot ask others to choose a date from a number of possible dates.               | Possibility to conduct a survey on activity dates to improve scheduling (similar to the "Doodle" survey platform). |
| I   |   | X | You can only schedule activities as face-to-face meetings. Digital activities can only be scheduled through the other option, where you can add your own description. | Addition of a digital activity to the pool of activities for selection.                             |

## Bugs and improvements regarding the app area discover

| B/I | C | N | Bug / Current status                                                                                                           | Improvement suggestion                                                                              |
|-----|---|---|--------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------|
| I   |   | X | When searching for users, you can only find them if you search for the full name with the correct spelling.                    | After entering 2-3 letters, the app should be able to suggest other users.                          |
| I   |   | X | When searching for users, you can only find them if you search for the full name with the correct spelling.                    | When you enter a name with an incorrect spelling, the app should be able to suggest users with similar names. |
| I   |   | X | When searching for users, you can only find them if you search for the full name with the correct spelling.                    | If no results are found when searching for users, an error message should be displayed.             |
| I   |   | X | You can add locations in your area and the app will suggest users who have added the same locations.                           | Ability to set your own location and a radius within which you are mobile and other users in the app can be searched for. |
| I   |   | X | Users' locations are only displayed in written form.                                                                           | Ability to view the location of all users on a map. This allows you to see who is where.            |
| I   |   | X | All users who match by location or interests are displayed in one long list.                                                   | Ability to provide a better overview of matching users by dividing them into different categories, for example, users who match based on location and users who match based on interests. |
| I   |   | X | Both friends made and unknown users are displayed in the list for finding matching users.                                      | Ability to find new matching users in the app by only showing users you are not friends with in the list. |
| B   | X |   | In the area discover, interests are listed under "activities"; in a profile, interests are listed under "interests".           | Interests should be labelled in a consistent way.                                                   |

## General Improvements

| B/I | C | N | Bug / Current status                                                                                                           | Improvement suggestion                                                                              |
|-----|---|---|--------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------|
| I   |   | X | Font size is not adjustable in the app.                                                                                        | Ability to adjust font size in the app.                                                             |
| I   |   | X | The app can only be used on a smartphone.                                                                                      | Possibility of a tablet version of the app to make the app bigger and easier to use.                |

Note: B = Bug; I = Improvement (additionally); C = Corrected; N = Not corrected.
