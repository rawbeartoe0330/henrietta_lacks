NFT- Application 
BioBanker client with blockchain implementations assign ownership for specimens and proceedings.

Objectives
The objectives of this software is to manage the relationships between the specimens,
the researches, the healthcare providers and their legitimate owners (the patients):

Application Description: 
The application was programmed using Flutter
This application connects to the Ethereum network
The NOSQL Database is Hosted in Firebase.

I PART I:  How to setup the environment 
- Git accounts 
- Flutter install 
- Android Studio
- Android Emulator
- XCode
- Iphone Emulator
- Cococa
- npm (Node Package Manager)
- Test Flutter 
- Download Application
- Run Application

=====
Minimum requirements 

OSX +700MB of free storage
10 GB - Android studio and Xcode 
Mac OS X Mojave

Developing Environment

Install Flutter 
Full installation guide in https://docs.flutter.dev/get-started/install

Download flutter from Mac and move it to folder you create with name Developer 
    YourUsername/Developer/

Unzip file to Flutter folder, so the address looks like this:
    YourUsername/Developer/Flutter/

Now its time to create global route to use flutter in the entire system:

If you use bash in the terminal you need to update your .bash_profile file :
you can use vim or nano, I will show both ways 

    Vim .bash_profile 
        export PATH="$PATH:/Users/YOUR-USER-NAME/Developer/Flutter/flutter/bin"

If you use ZSH 
    sudo nano ~/.zshrc
        export PATH="$PATH:/Users/YOUR-USER-NAME/Developer/Flutter/flutter/bin"

Save and exit the file in vim or nano (:wq! )

More references about this step in:
https://docs.flutter.dev/get-started/install/macos#update-your-path


If this step works, you should be able to run flutter doctor 
    flutter doctor

Flutter doctor should show something like a a checklist of software that needs to be installed


Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, 2.10.4, on macOS 12.2.1 21D62 darwin-arm, locale en)

[✓] Android toolchain - develop for Android devices (Android SDK version 32.1.0-rc1)
    

[✓] Xcode - develop for iOS and macOS (Xcode 13.1)

    Download XCODE from 
    https://apps.apple.com/us/app/xcode/id497799835?mt=12

    Configure the Xcode command-line tools:

        sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
        sudo xcodebuild -runFirstLaunch

    Set up the iOS simulator
        open -a Simulator

    Install CocoaPods
        sudo gem install cocoapods


[✓] Chrome - develop for the web
you can download chrome  from the following link
https://www.google.com/chrome/?brand=YTUH&gclid=Cj0KCQjwpImTBhCmARIsAKr58czlOLJbbDk6iBO8HCPZ9n2YOSgxjntrW1Cwin5FFsDYELV9DQLPFnsaAkjQEALw_wcB&gclsrc=aw.ds

[✓] Android Studio (version 2021.1)
you can download android studio from the following link
https://developer.android.com/studio/?gclid=Cj0KCQjwpImTBhCmARIsAKr58cwMJC8KYskQs7JgK9vW-Krk_QlH42viO70fTagvbloMF96HS7-SYJEaAuQ2EALw_wcB&gclsrc=aw.ds

[✓] IntelliJ IDEA Ultimate Edition (version 2021.3)
    *** Fluter doctor will identify your IDE ***
    
[✓] VS Code (version 1.66.2)
    **** Fluter doctor will identify your IDE ***

[✓] Connected device (3 available)

    Create a virtual device
    Go To android studio 
    Click on — 
    Select Device —
    Create new Android device 
    PIXEL 4 XL API 32 Mobile 
        - To improve performance select hardware in options at creation 

[✓] HTTP Host Availability


+++++++++++++++++++++++++++++++++ END OF FLUTTER DOCTOR +++++++++++++++++++++++++++++
Make sure all flutter doctor checks are green. 
If some components are missing. I have posted links to obtain the software needed. 
Some instructions are placed between checks to help with each problem

To check Flutter is working propperly:

Create a new flutter app by running 
    flutter create my_app

Enter the my_app file and
    cd my_app

Ensure a simulator is running and run 
    flutter run 
    


You should be able to run a basic demo application in the simulator. 

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Now clone the repository 

In the repository go to nft_flutter folder 
run
    npm install
    (Install the dependencies to the local node_modules folder.)

run
    flutter pub get

run     
    flutter pub upgrade

In the VS code, lower right corner select the pixel emulator 
In Android studio select the android device next to the run button 

run 
    flutter run  
    flutter run lib/main.dart


After displaying a few warnings, the application should run in the emulator. 


if you dont have Node Package Manager Installed) 
More on npm install: https://docs.npmjs.com/cli/v8/commands/npm-install


Troubleshooting
Delete build files manually or running 
    flutter clean

Delete pubspec.lock
Delete node_modules manually
run 
    npm install
again



Part II: Database connection  + Blockchain connection
Software 
    Ganache 
    Truffle 



PART III 
Software Betails
3.1  Users / Roles:
- Patient
- Physician
- Technician
- Biobanker
- Ethical Broker
-

3.2  Protocols
We will use protocols to regulate the tissue procurement collection