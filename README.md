# BottleRocket

An experimental CLI tool for generating normalized Swift models from example JSON responses.

## Goals

- Generate Swift models that don't need any cleanup by hand
- Allow parsing partial JSON responses into the same model
  - Properties that don't show up in every model are optional
- Generated Swift JSON parsing code without dependencies
- Experiment with functional programming techniques in Swift

## Installation

Don't have a good way to do this yet. For now:

- Download project
- Open `BottleRocket.xcodeproj`
- Build
- Expand the Products group, option-click `BottleRocket` and select `Show in Finder`
- Put the executable somewhere

## Example

Suppose you have two different endpoints that return JSON:

`http://myservice.com/api/events`

```json
{
  "title": "Birthday party",
  "likes": 12,
  "is_public": true,
  "users": [
    {
      "name": "Sam",
      "id": 1
    },
    {
      "name": "Zoey",
      "id": 2
    }
  ]
}
```

`http://myservice.com/api/user/1`

```json
{
  "name": "Sam",
  "age": 28,
  "id": 1,
  "horoscope": "gemini"
}
```

You can save both sample responses into two files: `events.json` and `user.json`. Then run:

```shell
$ bottlerocket gen ~/path/to/models
```

Which then generates two different models:

```swift
final class Event: NSCoding {
  let title: String
  let likes: NSNumber
  let is_public: Bool
  let users: [User]

  init(title: String, likes: NSNumber, is_public: Bool, users: [User]) {
    // ...
  }

  convenience init?(json: [String: Any]) {
    // unpack and parse models
    // call designated init
  }

  // encode/decode
}

final class User: NSCoding {
  let name: String
  let id: NSNumber

  // only shows up in api/user/1 response
  let age: NSNumber?
  let horoscope: String?

  // init, json, coding, etc
}
```

## Dependencies

- [InflectorKit](https://github.com/mattt/InflectorKit) to convert plural keys into singular classnames
- [SwiftCLI](https://github.com/jakeheis/SwiftCLI) because this is my first CLI app
