# onloop

Engineering Coding Task [Flutter]

## Getting Started

1. Run 'flutter pub get' to install the packages.
2. Run 'Flutter run' to start the app

### Tasks completed

Task 1, 2, 3 and 4

##### Assumptions

1. API will provide all the info - title, description, thumbnail_url, content_url, created_at, tags. None of them will be null, but the content card will only show one tag, as it would affect how to layout the UI.
2. To convert the string 'red', 'blue', etc. to the Color object, one mapping file, color_helper.dart , has been created for 'red', 'blue', 'green' and 'yellow'. There is a third party package to do the convertion, but unfortunately it's not null-safe yet.
3. For 'Thumb up' and 'Thumb down', the empty click event has been added - basically it does nothing.

###### Known issue

The tag section is not exactly like the mockup. Even though it's "Wrap" widget, it is working like a "Table" for some reason. Off the top of my head, I don't know an easy solution. Probably it needs to create custom widgets. Sorry.