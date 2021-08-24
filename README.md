# google_mobile_ads ad load time issue

This project is a simplified version of our implementation. 

In our project we have an adhesion ad that sticks to the top of the screen as user scrolls. This ad refreshes every 20 seconds. There are also banner ads inside the body. They are all loaded using Google Ad Manager.

The ads are loading lazyly as user scrolls. However, when there are too many ads on the screen (about 15 ads) and user scrolls to the bottom of the screen quickly, it forces all of the ads to load at the same time. This increases the load times of all the ads. In this case when the banner ad refreshes, it doesn't load at all until all of the other ads are loaded. 

Here is a video demonstrating this issue:

https://user-images.githubusercontent.com/75324076/130649709-08b7ef76-cb4a-475b-94db-6ec2523ded11.mov
