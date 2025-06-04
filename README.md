# CameraButtonKit

![GitHub repo size](https://img.shields.io/github/repo-size/jaydeep-godhani/CameraButtonKit)
![GitHub stars](https://img.shields.io/github/stars/jaydeep-godhani/CameraButtonKit?style=social)
![GitHub forks](https://img.shields.io/github/forks/jaydeep-godhani/CameraButtonKit?style=social)
![Platform](https://img.shields.io/badge/platform-iOS%2013.0%2B-blue.svg?style=flat)
![Language](https://img.shields.io/badge/language-swift%205-4BC51D.svg?style=flat)
![License](https://img.shields.io/badge/license-MIT-orange)

A customizable and lightweight camera-style record button for iOS, with support for tap, long-press recording, progress spinner animation, and delegate callbacks.

---

https://github.com/yourusername/CameraButtonKit/assets/your-video-id/video.mp4

---

## Features

- 🎥 Long-press to start recording
- 🟢 Tap to trigger single-shot action
- 🌀 Circular animated spinner around button
- ⏱️ Auto-stop after max duration
- ⚠️ Delegate warning if recording is too short
- 🔁 Customizable sizes, colors, and timings

## Requirements

- iOS 13.0+
- Swift 5
- Xcode 12 or higher

## Installation

This is an Xcode project, so you can directly clone or download the project into your workspace.

### Clone the Repository

```bash
git clone https://github.com/jaydeep-godhani/CameraButtonKit.git
```
Alternatively, you can download the project as a ZIP file from the GitHub repository page.

### Integrating into Your Project

To integrate the `CameraButtonView` into your own Xcode project:

1. Download or clone the repository.
2. Copy the contents of the `Source` folder into your project.
3. Add `CameraButtonView` to your storyboard or use it programmatically in your view controllers.

## Usage

```swift
import CameraButtonKit

class ViewController: UIViewController, CameraButtonDelegate {

 override func viewDidLoad() {
     super.viewDidLoad()
     
     let cameraButton = CameraButtonView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
     cameraButton.center = view.center
     cameraButton.delegate = self
     view.addSubview(cameraButton)
 }

 // MARK: - CameraButtonDelegate Methods

 func onStartRecord() {
     print("Started recording")
 }

 func onEndRecord() {
     print("Finished recording")
 }

 func onDurationTooShortError() {
     print("Recording too short!")
 }

 func onSingleTap() {
     print("Single tap action")
 }

 func onCancelled() {
     print("Recording cancelled")
 }

}
```

## Customization

| Property             | Description                          | Default |
| -------------------- | ------------------------------------ | ------- |
| `lineWidth`          | Thickness of the spinner             | `10`    |
| `spinnerLineSpacing` | Gap between button and spinner       | `20`    |
| `spinnerPadding`     | Additional space outside the spinner | `15`    |
| `minRecordDuration`  | Minimum valid duration in seconds    | `0.3`   |
| `maxRecordDuration`  | Maximum allowed duration             | `60.0`  |

You can also change the spinner color by updating `spinnerLayer.strokeColor`.

## Contributions

We welcome contributions! If you find a bug, have an idea for a new extension, or want to improve the documentation, feel free to fork the repo and create a pull request.

## License

This project is licensed under the MIT License - see the `LICENSE` file for details.
