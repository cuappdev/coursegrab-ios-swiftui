# CourseGrab - Get in to the Courses That You Want

<p align="center"><img src=https://raw.githubusercontent.com/cuappdev/coursegrab-ios/master/CourseGrab/Supporting/Assets.xcassets/Logos/coursegrab-readme.imageset/coursegrab-readme.png width=210/></p>

CourseGrab is one of the latest applications by [Cornell AppDev](http://cornellappdev.com), an engineering project team at Cornell University focused on mobile app development. Currently catering to Cornell University's class roster, CourseGrab enhances the student enrollment experience by notifying students of available spots in courses they wish to enroll in.

## Development

### 1. Installation

We use [Swift Package Manager](https://swift.org/package-manager/) for dependency management — no additional installation required.

To access the project, clone the repository and open `CourseGrab.xcodeproj` in Xcode.

### 2. Configuration

You will need a `CourseGrabSecrets/` folder placed at the root of the project containing both `GoogleService-Info.plist` and `Keys.xcconfig`.

For AppDev members, this folder is pinned as a zip file in the `#coursegrab-ios` Slack channel. Download it, unzip it, and place the `CourseGrabSecrets/` folder at the root of the project.

If you aren't an AppDev member, you will need to:
- Generate your own `GoogleService-Info.plist` by following these [instructions](https://support.google.com/firebase/answer/7015592?hl=en)
- Create a `Keys.xcconfig` file with the following contents:
```
// Server
SERVER_HOST = INSERT_SERVER_HOST

// AppDev Announcements
ANNOUNCEMENTS_COMMON_PATH = INSERT_COMMON_PATH
ANNOUNCEMENTS_HOST = INSERT_HOST
ANNOUNCEMENTS_PATH = INSERT_PATH
ANNOUNCEMENTS_SCHEME = INSERT_SCHEME
```

Once your secrets are in place, open `CourseGrab.xcodeproj` and enjoy CourseGrab!

## Contributors

### Top Contributors
<a href="https://github.com/cuappdev/coursegrab-ios-swiftui/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=cuappdev/coursegrab-ios-swiftui" alt="contrib.rocks image" />
</a>
