/*
 *  Settings.h
 *  BetterTransit
 *
 *  Created by Yaogang Lian on 11/9/09.
 *  Copyright 2009 Happen Next. All rights reserved.
 *
 */

#define PRODUCTION_READY

#define CENTER_LATITUDE 38.034039
#define CENTER_LONGITUDE -78.499479

// Custom settings
#define MAIN_DB @"HoosBus-GTFS"
#define ADD_TO_FAVS_PNG @"addToFavs.png"
#define NUM_STOPS 480
#define NUM_ROUTES 30
#define NUM_TILES 1
#define REFRESH_INTERVAL 20
#define TIMEOUT_INTERVAL 10.0
#define ENGLISH_UNIT

// Colors
#define COLOR_TABLE_VIEW_BG [UIColor colorWithRed:0.918 green:0.906 blue:0.906 alpha:1.0]
#define COLOR_TABLE_VIEW_SEPARATOR [UIColor colorWithRed:0.345 green:0.482 blue:0.580 alpha:0.25]
#define COLOR_TAB_BAR_BG [UIColor colorWithRed:0.0 green:0.42 blue:0.8 alpha:0.3]
#define COLOR_NAV_BAR_BG [UIColor colorWithRed:0.118 green:0.243 blue:0.357 alpha:1.0]

// API
#define API_BASE_URL @"http://hoosbus.appspot.com/v1"

// App settings
#define APP_SETTINGS_XML @"http://artisticfrog.com/cross_promote/hoosbus/app_settings.xml"
#define APP_SETTINGS_OS3_XML @"http://artisticfrog.com/cross_promote/hoosbus/app_settings_os3.xml"

#define AD_ZONE_1 1 // stops view, trip view
#define AD_ZONE_2 2 // routes view
#define AD_ZONE_3 3 // prediction view

//#define AD_FREE [AdWhirlManager testAdFree]
#define AD_FREE [AppSettings adFree]
// Remember to call [AdWhirlManager removeAds] to stop timers when we want to switch off ads

// Ad networks settings
#define ADWHIRL_API_KEY @"00e9827988454c9d8079529617fe540f"
#define ADMOB_APP_ID @"a14cee7368e76fb"
#define INMOBI_APP_ID @"4028cba630724cd90130a9788bd10134"

// Appirater
#define APP_NAME	@"HoosBus"
#define APP_ID 334856530

// Flurry
#define FLURRY_KEY @"HRQJ5Z5UC7TUEANL7UXE"

// Cross promotion
#define APP_LIST_XML @"http://artisticfrog.com/cross_promote/hoosbus/app_list.xml"

// FAQ, Blog
#define URL_FAQ @"http://artisticfrog.com/cross_promote/hoosbus/faq.xml"
#define URL_BLOG @"http://happenapps.tumblr.com"