# HoosBus

The once-beloved real-time transit app for UVa and Charlottesville Area Transit, now open-sourced.

## What's included

This repository includes a complete HoosBus app in the "iOS" subfolder, as well as a python script in the "GTFSImporter" subfolder to convert GTFS data files into a sqlite database used in the app.

## Compile the app

In order to compile the app, you need to have latest XCode installed. Also, you need to have a copy of [BetterTransit](https://github.com/HappenApps/BetterTransit) and make sure the "BetterTransit" directory is right beside the "HoosBus" directory. This is because HoosBus links the files in BetterTransit using relative paths. 

## App features

* Show nearby bus stops
* Search for a bus stop by stop name or stop code
* A map view showing nearby stops
* Real-time prediction of all routes running through a bus stop
* A routes view
* Each route has a trip view, which can be inbound or outbound.


## How to update static transit data

A single script "import_gtfs.py" converts the GTFS data into a sqlite database to be used by the app. To update the database, first download the lastest GTFS data files from Connexionz's website, unzip into "google_transit" folder, and run
    
    python import_gtfs.py

This creates the database file in the same folder, which can then be copied to the iOS folder.

You may also need to update "routesToDisplay.plist" with the new routes.

## License
Released under the MIT license.
