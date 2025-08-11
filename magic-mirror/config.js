/* Config Sample
 *
 * For more information on how you can configure this file
 * see https://docs.magicmirror.builders/configuration/introduction.html
 * and https://docs.magicmirror.builders/modules/configuration.html
 *
 * You can use environment variables using a `config.js.template` file instead of `config.js`
 * which will be converted to `config.js` while starting. For more information
 * see https://docs.magicmirror.builders/configuration/introduction.html#enviromnent-variables
 */
let config = {
	address: "0.0.0.0",
	port: 8080,
	basePath: "/",	// The URL path where MagicMirror² is hosted. If you are using a Reverse proxy
	// you must set the sub path here. basePath must end with a /
	ipWhitelist: [ "192.168.0.0/16", "127.0.0.1"],
//	["127.0.0.1", "::ffff:127.0.0.1", "::1",],	// Set [] to allow all IP addresses
	// or add a specific IPv4 of 192.168.1.5 :
	// ["127.0.0.1", "::ffff:127.0.0.1", "::1", "::ffff:192.168.1.5"],
	// or IPv4 range of 192.168.3.0 --> 192.168.3.15 use CIDR format :
	// ["127.0.0.1", "::ffff:127.0.0.1", "::1", "::ffff:192.168.3.0/28"],

	useHttps: false,			// Support HTTPS or not, default "false" will use HTTP
	httpsPrivateKey: "",	// HTTPS private key path, only require when useHttps is true
	httpsCertificate: "",	// HTTPS Certificate path, only require when useHttps is true

	language: "en",
	locale: "en-US",   // this variable is provided as a consistent location
	// it is currently only used by 3rd party modules. no MagicMirror code uses this value
	// as we have no usage, we  have no constraints on what this field holds
	// see https://en.wikipedia.org/wiki/Locale_(computer_software) for the possibilities

	logLevel: ["INFO", "LOG", "WARN", "ERROR"], // Add "DEBUG" for even more logging
	timeFormat: 24,
	units: "metric",

	modules: [
		{
			module: 'MMM-AutoDimmer',
			position: 'fullscreen_above',
			header: '',
			// Don't change anything above this line
			config: {
				transitionDuration: 3000,
			//	schedules: [{
			//		dimTime: 0,
			//		brightTime: 2359,
			//		maxDim: 1,
			//		notificationTriggers: [
			//			{
			//				name: "USER_PRESENCE",
			//				value: false,
			//			},
			//		],
			//	},{
			//		brightTime: 0,
			//		dimTime: 2359,
			//		maxDim: 0,
			//	}]
			}
		},
		{
			module: 'MMM-Remote-Control',
			config: {
				customCommand: {},  // Optional, See "Using Custom Commands" below
				showModuleApiMenu: true, // Optional, Enable the Module Controls menu
				secureEndpoints: false, // Optional, See API/README.md
			}
		},		
		{
			module: "alert",
		},
		{
			module: "updatenotification",
			position: "top_bar"
		},
		{
			module: "clock",
			position: "top_left"
		},
		{
			module: "calendar",
			header: "Apple Calendar",
			position: "top_left",
			config: {
				calendars: [
					{
						fetchInterval: 60 * 60 * 1000,
						symbol: "calendar-check",
						url: "webcal://p118-caldav.icloud.com/published/2/MTY5NjcwOTc3MzExNjk2Ny9Hz2cscEdzFJdK-zThRORT7m43H6kF1HE1IIp01Mn5"
					}
				]
			}
		},
		{
			module: 'MMM-SL-PublicTransport',
			position: 'top_left',
			header: 'SL',
			config: {
				stations: [                     // REQUIRED at least one entry. 
					// Definition of the stations that you would like to see
					{
						stationId: 9110,
						stationName: 'Abbeberg',
						direction: 2,             // Optional. 1 or 2
						forecast: 60,               
					},
				],
				maxDestinationLength: 999,      // Optional, will truncate the destination string to the set length.
				displaycount: 10,               // Optional, show this number of departures for each direction.
				dontDisplayIfAlmostleft: 3*60,  // Optional, hides departues with time left less then this value in seconds
				// Note that you need to set the omitDeparturesLeft parameter to true for 
				// this to take effect. Also useDisplayTime has to be set to false.
				omitDeparturesLeft: false,      // Optional, if set to true departures that have left the station
				// is not shown.
				showdisturbances: false,        // Not implemented yet
				fade: true,                     // Optional. Shall the table of departures be faded or not
				fadePoint: 0.2,                 // Optional. Fraction from end where to start fading
				delayThreshhold: 180,            // Optional. If a departure is delayed or in advance only
				// show this
				// if the delay/advance is greater than this number in
				// seconds.            
				updateInterval: 5*60*1000,      // Optional. Number of milliseconds between calls to
				// Trafiklab's API. This value shall preferably be larger then 1 min
				// There are limitations on number of calls per minute and month
				highUpdateInterval: {},         // Optional if you dont need it don't define it.
				// If defined use higher frequences for updates, see
				// "Set what times to update more frequently" below
				uiUpdateInterval: 10*1000,         // Optional. Number of milliseconds between updates of the
				// departure list. This value shall preferably be less then 10 sec
				SSL: false,                     // Optional. Use https to access the TrafikLab services,
				// defaults to false since I have experienced problems  
				// accessing this service over https. Have an ongoing  
				// discussion with TrafikLab
				debug: false,                   // Optional. Enable some extra output when debugging
				ignoreSanityCheck: false,       // Optional. If set to true config sanity checks are not done.
				useDisplayTime: false,          // Optional. If true use the actual displaytime that is
				// received via the API instead of the ExpectedDateTime and
				// TimeTabledDateTime. See the DisplayTime section below.
				cleanHeader: false,             // If set to true the last update time is not shown
				// in the header
				showIcon: true                  // Optional. If true show an icon of the type of transport

			}
		},
		{
			module: "weather",
			position: "top_right",
			config: {
				weatherProvider: "openmeteo",
				type: "current",
				lat: 59.338476,
				lon: 17.951872
			}
		},
		{
			module: "weather",
			position: "top_right",
			header: "Weather Forecast",
			config: {
				weatherProvider: "openmeteo",
				type: "forecast",
				lat: 59.338476,
				lon: 17.951872
			}
		},
		{
			module: "MMM-ServerStatus",
			header: "What's up?",   
			position: "top_right", 
			config: {
				upSymbol: 'circle-check',
				upText: '',
				downSymbol: 'circle-xmark',
				downText: '',
				hosts: [    
					{ name: "Macbook Pro", ip: "albins.local" },
					{ name: "Home Assistant", ip: "hass.jonfelt.se" },
					{ name: "Reverse Proxy", ip: "rp2.local" }
				],
			},
		},
		{
			module: 'MMM-Sonos',
			header: 'Now playing',
			position: 'top_right',
			config: {
				animationSpeed: 1000,
				showFullGroupName: false,
				showArtist: true,
				showAlbum: true,
				showMetadata: true
			}
		},
	]
};

/*************** DO NOT EDIT THE LINE BELOW ***************/
if (typeof module !== "undefined") { module.exports = config; }
