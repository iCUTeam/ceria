# Ceria

(Cerita Rakyat Interaktif Anak)

MACRO Challenge ADA@BINUS - C5 | iCU (i Curry U) - Group 6 Afternoon

- UI Framework: UIKit Hybrid (Programmatically + Storyboard)

- Tech Stack: TBA



## App Architecture: MVVM-C (with Coordinator Pattern)

```
ceria
|
|__ Resources
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
|   |   |__ Illustrations
|   |   |
|   |   |__ Buttons
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
|       |__ Audio Players
|       |
|       |__ PencilKit
|       |
|       |__ Core Motion
|       |
|       |__ 3D
|
|__ Services
|   |
|   |__ Feeders
|
|__ Models
|   |
|   |__ JSON Files
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
|   |       |__ About
|   |       |
|   |       |__ Collection
|   |       |
|   |       |__ Instruction
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
|   |       |   |   |__ Game 1
|   |       |   |   |
|   |       |   |   |__ Game 2
|   |       |   |   |
|   |       |   |   |__ Game 3
|   |       |   |   |
|   |       |   |   |__ Game 4
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