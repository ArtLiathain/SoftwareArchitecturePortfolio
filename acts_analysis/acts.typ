#set page(width: 210mm, height: 297mm, margin: 25mm)
#set text(font: "Linux Libertine", size: 12pt)
#set heading(numbering: "1.")
#import "@preview/pintorita:0.1.4"
#show raw.where(lang: "pintora"): it => pintorita.render(it.text)

#align(center)[
  = Block 4.2: CS6514: Software Architecture Design Portfolio  

Fluctuating Finite Element Analysis (FFEA) Case Study \
Art Ó Liathain \
September 2025
]

#pagebreak()

= Table of Contents
#outline()

#outline(
  title: [List of Figures],
  target: figure.where(kind: image)
)

#pagebreak()

= Tech Stack
Main Language: C++

Heavily used external libraries: Eigen, boost, cmake

Used for example scripts: Python bindings using pybind11

Containerisation: Docker

#pagebreak()
#figure(
```pintora
mindmap
@param layoutDirection LR
@param useMaxWidth true
+ Core Domain
++ Particle track reconstruction for high energy physics
++ Extensive test bed for high modularity testing
++ Geometry material modelling
+ Supporting Domain
++ Atlas Common Tracking Software
++ Open Data Detector
++ Machine learning
+ Generic Domain
++ Runge-Kutta-Nyström RKN method

```,
  caption: [Domain Model]
)

= Utility Tree
#figure(
```pintora
mindmap
@param layoutDirection LR
@param useMaxWidth true
+ Maintability
++ Composition over inheritance approach to plugins
++ The files must be logically grouped in folders
++ Cyclomatic Complexity must not be over 15
++ CI/CD musat be used for automatic testing and analysis
++ Semantic verisoning must be used to allow for api version management
+ Useabilility
++ The code must have clear function descriptions for LSP
++ The APIs must be stateless or encapsulate state withing objects
++ There must be clear maintained documentation highlighting how to use the code
+ Performance
++ The code must allow itself to be paralellised

```,
  caption: [Utility Tree]
)

= Use Case Diagram

#figure(
  image("2025-10-13-20:55:48.png", width: 80%),
  caption: [Use Case Diagram]
)


= 4+1 Diagram
#figure(```pintora
classDiagram
  class UserInterfaces {
    + input
    + output
    + calculateOutput()
  }
  class MathematicalFunctions {
    + doMath()
  }

  class CoreFunctionLoop {
    + doCalculation()
  }

  class GeometryMeshFunctions {
    + drawSquare()
  }

  class ParticleTrackingFunctions {
    + findParticle()
  }

  UserInterfaces --> CoreFunctionLoop : Gets called and returns output of core function loop
  CoreFunctionLoop --> GeometryMeshFunctions : Models the material and geometry
  CoreFunctionLoop --> ParticleTrackingFunctions : Tracks particles based on input params
  CoreFunctionLoop --> MathematicalFunctions : Utility math functions to be called
  CoreFunctionLoop --> UserInterfaces 

```,
caption: []
)




= Codescene
#figure(
  image("2025-10-13-20:20:01.png", width: 80%),
  caption: [Dependency Coupling Graph]
)
#figure(
  image("2025-10-13-20:21:32.png", width: 80%),
  caption: [Technical Debt Codescene]
)

= Understand
#figure(
  image("2025-10-13-20:27:38.png", width: 80%),
  caption: [Understand High Level Info]
)
#figure(
  image("2025-10-13-20:28:11.png", width: 80%),
  caption: [Understand complexity ratings]
)
#figure(
  image("2025-10-13-20:29:40.png", width: 80%),
  caption: [Class Diagram Inheritance]
)
#figure(
  image("2025-10-13-20:29:48.png", width: 80%),
  caption: [Class Diagram flat]
)

= Sonarqube

#figure(
  image("2025-10-14-12:21:07.png", width:80%),
  caption: []
)
#figure(
  image("2025-10-14-12:21:13.png", width:80%),
  caption: []
)
#figure(
  image("2025-10-14-12:21:31.png", width:80%),
  caption: []
)
#figure(
  image("2025-10-14-12:22:07.png", width:80%),
  caption: []
)
