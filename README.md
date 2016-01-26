# Project 1 - flix

flix is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: 1 hour spent in total

## User Stories

The following **required** functionality is complete:

- [x] User can view a list of movies currently playing in theaters from The Movie Database.
- [ ] Poster images are loaded using the UIImageView category in the AFNetworking library.
- [ ] User sees a loading state while waiting for the movies API.
- [ ] User can pull to refresh the movie list.

The following **optional** features are implemented:

- [ ] User sees an error message when there's a networking error.
- [ ] Movies are displayed using a CollectionView instead of a TableView.
- [ ] User can search for a movie.
- [ ] All images fade in as they are loading.
- [ ] Customize the UI.

The following **additional** features are implemented:

- [ ] List anything else that you can get done to improve the app functionality!

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. better and more efficient methods of improving animation labels 
2. where additional optionals should be included for subsets/elements in the movie dictioanry to prevent crashing

## Video Walkthrough 

Here's a walkthrough of implemented user stories:

<img src='http://i.imgur.com/m1v00sV.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Describe any challenges encountered while building the app.
Had an initial issue with the app crashing when the Now Playing endpoint wasn't updated completely with all the data, e.g. no title image. Fixed it with optionals.

I created this seperate xcode project from the actual project I'm working on (which is ahead of the schedule) as I'm not sure what specifically is being checked.

## License

    Copyright [2016] [Brian Wang]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
