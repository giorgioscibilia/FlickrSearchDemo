# FlickrSearchDemo
A simple iOS app written in Objective-C that shows how to use flickr search apis.


Overview:
The main view controller contains a search bar where you can type any keyword, when you will then hit "search" the scrollview below will be populated with images related to the keyword(s) you used.
Tap on an image to see it larger and then click on the info icon to see picture details (exif data).
When seeing images that contain geolocalization info you will also see a "search pics in the same area" button, click on it and you will be redirected to the main page where pics with similar geolocation info will be displayed.


Most Important Classes:
- FSDImageItem: represents the main "photo object" returned by the flickr search apis, with some factory and/or utility methods.
- FSDImagesCache: singleton that handles the images downloading/caching. Used as a unique endpoint to obtain images 
- FSDSearchUtils: singleton that handles all the image searches.


Third party libraries:
- https://github.com/jdg/MBProgressHUD :  Used to display a "wait for image loading" message while searchin the images to display.




To compile/run just download/use the latest version XCode ()
