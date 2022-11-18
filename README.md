# Carita

(Cerita Rakyat Interaktif Anak - #RumahmuPetualanganmu)

MACRO Challenge ADA@BINUS - C5 | iCU (i Curry U) - Group 6 Afternoon

- UI Framework: UIKit Hybrid (Programmatically + Storyboard)

- Tech Stack: PencilKit, PDFKit, SceneKit, ARKit, RealityKit, AVFoundation, CoreMotion



## App Architecture: MVVM-C (with Coordinator Pattern)

```
ceria
|
|__ Resources
|   |
|   |__ Files
|   |
|   |__ Audio
|   |   |
|   |   |__ BGM
|   |   |
|   |   |__ SFX
|   |   |
|   |   |__ Voices
|   |
|   |__ Themes
|   |   |
|   |   |__ Fonts
|   |
|   |__ Assets
|   |   |
|   |   |__ Common
|   |   |
|   |   |__ Pages
|   |
|   |__ Models
|
|__ Core
|
|__ Utilities
|   |
|   |__ Extensions
|   |   |
|   |   |__ PencilKit
|   |   |
|   |   |__ UI
|   |
|   |__ Helpers
|       |
|       |__ 3D Animation
|       |
|       |__ Audio Players
|       |
|       |__ PencilKit
|       |
|       |__ Core Motion
|       |
|       |__ Gameplay
|
|__ Services
|   |
|   |__ Feeders
|
|__ Models
|   |
|   |__ JSON_Files
|
|__ Views
|   |
|   |__ UI
|   |   |
|   |   |__ Components
|   |   |
|   |   |__ Pages
|   |       |
|   |       |__ Landing
|   |       |
|   |       |__ Story
|   |       |
|   |       |__ Gameplay
|   |       |   |
|   |       |   |__ Explore
|   |       |   |
|   |       |   |__ Power
|   |       |   |
|   |       |   |__ Tutorial
|   |       |   |
|   |       |   |__ Challenge
|   |       |   |   |
|   |       |   |   |__ Game 2
|   |       |   |
|   |       |   |__ Success 
|   |       |
|   |       |__ Reflection
|   |
|   |__ Controllers
|
|__ ViewModels
|
|__ Coordinators

```
