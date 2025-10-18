#set page(width: 210mm, height: 297mm, margin: 25mm)
#set text(font: "Linux Libertine", size: 12pt)
#set heading(numbering: "1.")
#import "@preview/pintorita:0.1.4"
#show raw.where(lang: "pintora"): it => pintorita.render(it.text)

#align(center)[
  = Block 4.2: CS6514: Software Architecture Design Portfolio  

iDavie Case Study \
Art Ó Liathain \
October 2025
]

#pagebreak

= Table of Contents
#outline

#outline(
  title: [List of Figures],
  target: figure.where(kind: image)
)

#pagebreak

= Tech Stack
- Renderer : Unity with C\#
- Interaction Framework : Steam VR
- Simulation Framework : C++ with eigen and boost
- Tests : Ctest with python add ons


= Domain Model
#figure(
```pintora
mindmap
@param layoutDirection LR
+ Core Domain
++ User interaction with 3D datasets
++ Deep interaction with 3D environment screenshots, movement maps, etc
++ Volumetric Shaders
++ VR Rendering
++ Friendly GUI
++ Masking Data
+ Supporting Domain
++ Galaxy galaxy interactino modelling
++ Cosmic web large scale structure
++ Gas/kinematics of nearby galaxies
++ Modelling of neurological images and other medical systems
+ Generic Domain
++ Computational Biophysics
++ User comprehension of complex phonemena

```,
  caption: [Domain Model]
)


= Utility Tree
#figure(
```pintora
mindmap
@param layoutDirection LR
+ Maintainability
++ Use CI/CD to automatically run test instead of a google form
++ Structure the codebase into a distributed monolith
++ Adhere to SOLID principles
++ Comment the why not the how
++ An average cyclomatic complexity of 15
++ Test branch coverage must be over 90%
+ Performance
++ Ensure smmoth usage on minimum specs
++ Unit testing must not take longer than a second
+ Useability
++ Create a docker image to allow for repeatable deployments
++ Update the docuementation to allow for a user guide on how to run the code

```,
  caption: [Utility Tree]
)
= Use case diagram 

#figure(image("2025-10-07-21:10:14.png", width: 80%), caption: [Use case state machine])

= 4 + 1 Diagram
= Logical View
#figure(
  image("Pasted image 20251014134042.png", width: 80%),
  caption : [Logical View]
)

= Physical view
```pintora
classDiagram
class LinuxOrMacMachine{
  + data thread
  + main thread
  + simulation thread
}
```
== Process View
```pintora
classDiagram
class CoreSimulation {
  calculateParticle()
}

class DataManagement{}

class Visualisation{
  visualise()
}

CoreSimulation --> Visualisation
CoreSimulation --> DataManagement
```
= Developmental View
- Not extensible, forking is recommmended to add large features
- High change propagation
- Current core is fairly static
- Data management is the largest dependency and a core of the codebase
- There is logcial grouping of files
- No automated tests
- PRs need to go through manual testing via form for changes

= Codescene
#figure(image("2025-10-07-17:28:17.png", width: 80%), caption: [Codescene coupling diagram 40%])
#figure(image("2025-10-07-17:27:55.png", width: 80%), caption: [Codescene Maintenance Diagram])
#figure(image("2025-10-07-22:03:44.png", width: 80%), caption: [Codescene Hotspot overview])
= Sonarqube 
#figure(image("2025-10-07-22:02:56.png", width: 80%), caption: [Sonarqube cyclomatic complexity])
#figure(image("2025-10-07-22:03:05.png", width: 80%), caption: [Sonarqube maintainability])
#figure(image("2025-10-07-22:03:10.png", width: 80%), caption: [Sonarqube reliability graph])

#figure(image("2025-10-07-22:03:24.png", width: 80%), caption: [Duplications Graph])

= Understand Code Analysis
#figure(
  image("2025-10-09-13:46:42.png", width: 80%),
  caption: []
)

= Class Diagrams
#figure(
  image("2025-10-09-13:48:25.png", width: 80%),
  caption: []
)

#figure(
  image("2025-10-09-13:48:47.png", width: 80%),
  caption: []
)
= C4 Diagram
#figure(
  image("2025-10-09-15:09:49.png", width: 80%),
  caption: [C4 Diagram]
)
