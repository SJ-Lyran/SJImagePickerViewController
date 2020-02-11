SJImagePickerViewController
==============

[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://raw.githubusercontent.com/SJ-Lyran/SJImagePickerViewController/master/LICENSE)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/v/SJImagePickerController.svg?style=flat)](http://cocoapods.org/pods/SJImagePickerController)&nbsp;
[![Support](https://img.shields.io/badge/support-iOS%209%2B%20-blue.svg?style=flat)](https://www.apple.com/nl/ios/)&nbsp;

![image](https://github.com/SJ-Lyran/SJImagePickerViewController/blob/master/demo1.gif)   

Installation
==============

### CocoaPods

1. Add `pod 'SJImagePickerController'` to your Podfile.
2. Run `pod install` or `pod update`.
3. Import SJImagePickerController.

### Manually
1. Download all the files in the `SJImagePickerController` subdirectory.
2. Add the source files to your Xcode project.
3. Add `NSPhotoLibraryUsageDescription`

Usage
==============
**SJImagePickerController** works as a normal controller, just instantiate it and present it.

```swift
let imagePicker = SJImagePickerController(delegate: self)
present(imagePicker, animated: true, completion: nil)
```

**SJImagePickerController** has two delegate methods that will inform you what the users are up to:

```swift
func imagePickerController(_ picker: SJImagePickerController, didFinishPickingMediaWithInfo info: [SJImagePickerController.InfoKey : Any])
func imagePickerControllerDidCancel(_ picker: SJImagePickerController)
```

**SJImagePickerController** supports limiting the amount of images that can be selected, it defaults
to 9

```swift
let imagePicker = SJImagePickerController(delegate: self)
imagePicker.maximumSelectedPhotoCount = 9
```
