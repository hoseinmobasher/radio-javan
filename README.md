# Radio Javan Client

This project aims to provide flutter based application to interact with https://radiojavan.com website.

In this application, I am using following plugins:

-    http: ^0.12.2
     - Request web information from Radio Javan website.
-    flutter_launcher_icons: ^0.8.1
     - To customize launcher icon (both in Android and iOS)
-    flutter_launcher_name: ^0.0.1
     - To change application name shown in app list.
-    google_fonts: ^1.1.2
     - To customize application font and set google provided fonts.
-    xpath_parse: ^1.0.2
     - To parse html contents and find the desired tags.
-    pull_to_refresh: 1.6.3
     - Add pull to refresh capability to extract required tags.
-    cached_network_image: ^2.5.0
     - Download network images and cache to prevent re-download.
-    url_launcher: ^5.7.10
     - Open links outside application.
-    provider: ^4.3.3
     - Share data in widget hierarchy.
-    lottie: ^0.7.0+1
     - Show lottie animation files.
-   audio_service: ^0.16.2
    - To interact with media service.
-   sqflite: ^1.3.2+3
    - Save and load user specific data (music queue, etc) into database.


## Getting Started

Clone source code and run it using following commands:

    git clone https://github.com/hoseinmobasher/radio-javan.git
    flutter pub get
    flutter install