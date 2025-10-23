#set page(width: 210mm, height: 297mm, margin: 25mm)
#set heading(numbering: "1.")
#import "@preview/pintorita:0.1.4"
#show raw.where(lang: "pintora"): it => pintorita.render(it.text)

#align(center)[

= Software Architecture Design Portfolio


Art Ó Liathain \
October 2025
]


= Table of Contents
#outline()

#outline(
  title: [List of Figures],
  target: figure.where(kind: image)
)


#pagebreak()

= Merlin++


== Current State
The current codebase is an artifact that seeks to achieve @merlin_domain_model (High speed particle simulation).
The code has an accidental architecture as an ad-hoc feature development approach meant that the only concrete factor was the tech stack(@merlin_tech_stack).
@merlin_codescene_maintainability_circle is a clear example of the outcome of this, a jumbled mess of code is mashed together.


While successful in achieving functionality the code architecture makes change difficult and has slowed the potential development of features due to the complexity of adding new features.
This architecture is something that will not last in the long term and a purpose picked architecture is needed to support the l:wqong running development and maintenance of the project in future.


== Proposed Architecture
To address these issues, looking at the Merlin documentation highlights the two key architectural goals the project had in development; to do the job in the simplest form and to produce a set of loosely coupled components which are easily maintainable (@appleby_merlin_2022).
These goals along with the core purpose of the system being simulation leads me to believe that a microkernel architecture is the best architecture for this project.
A microkernel architecture is a system built around a single purpose, in this case simulation while allowing a plugin system to introduce new functionality without changing the core code @rana_survey_2023.

#figure(image("./images/2025-10-23-14:21:46.png"),
caption: [MicroKernel Architecture Diagram])



The advantages this brings are numerous:
- The core code being largely static encourages *testability* and *robustness* as a set of comprehensive tests to be developed and maintained.
- Removing the plugins from the core developer responsibilities improves *maintainability* as only the core code must be maintained.
- The plugin system allows for development *flexibility*, allowing new features without changing the core code. Opening the code to extensibility without the new features encroaching on the core simulation.

== Reasoning
This re-architecture is feasible due to the big shutdown happening to Merlin.
As just fixing the code is a monumental task, seen here @merlin_technical_debt_cost.
To take full advantage of the shutdown I propose to rewrite the codebase in Rust.

Adopting a microkernel architecture would provide a stable testable core, while rust would optimise the performance and robustness of the simulation, integral to high precision simulations.
These changes would improve the long term maintainability of the code, as well as preventing unsafe code from entering the codebase.

Additionally, Rust inherently supports the functional programming paradigm, which I believe is well placed in the plugin-based architecture.
If plugins are enforced to be functional, they will act as stateless modules interacting through interfaces, reducing the risk of architectural drift as a plugin with state could become a dependency (CITE HERE).
Merlin can then maintain clear separation between the stable simulation kernel and user-developed extensions, ensuring long-term scalability and maintainability while allowing feature flexibility.


== Conclusion
This architecture proposal aligns with the ideal goals Merlin had laid out (CITE HERE).
Allow new developers to merlin focus on new features to develop over jumping around spaghetti code trying to understand issues.
Shifting the focus from maintenance and compiling being the standard to a robust performant system being at the core of Merlin.


== Diagrams
=== Tech Stack

#figure(
  image("images/merlin/tech_stack.png", width: 60%),
  caption: [Merlin Tech Stack]
) <merlin_tech_stack>


=== Domain Model
#figure(```pintora
mindmap
@param layoutDirection LR
+ Core Domain
++ Complex beam dynamics tracking
++ Object oirientated design
++ Mulitple accelator Modelling
++ Charged particle tracking
+ Supporting Domain
++ High energy particle accelerators
+ Generic Domain
++ RF cavity acceleration
++ Synchotron raditation damping
++ on-line physical aperture checks and collimation
++ proton scattering
++ wakefield simulation
++ spin tracking
```
, caption : [Merlin Domain Model]) <merlin_domain_model>


=== Utility Tree

#figure(
  image("images/merlin/utility_tree.png", width: 80%),
  caption: [Merlin Utility Tree]
) <merlin_utility_tree>

=== Use Case Diagram
#figure(
  image("images/merlin/20250930_140952.png"),
  caption: [Merlin Use Case diagram]
) <merlin_use_case_diagram>

=== 4 + 1 Diagram
=== Logical View
#figure(```pintora
classDiagram
class CoreSimLoop{
  doSimulation()
}

class PhysicsProcesses{
  doPhyscis()
}

class InputSystem{
  readInput()
}

class VisualisationFramework{
  render()
}

class AcceleratorModels{
  accelerate()
}

class Models{
  model()
}

class LatticeModel{
  func()
}

class InputReader{
  readInput()
}

InputReader --> Models : Sends params
Models --> AcceleratorModels : Creates
Models --> LatticeModel : Creates
Models --> CoreSimLoop : Sends models as base
CoreSimLoop --> PhysicsProcesses : Depends on
CoreSimLoop --> VisualisationFramework : Sends output to

```
, caption : [Merlin Logical View]) <merlin_logical_view>
=== Physical View
#figure(```pintora
classDiagram
class LinuxOrMacMachine{
  + worker thread
  + main thread
}
```,
caption: [Merlin Physical View]) <merlin_physical_view>


=== Development View
- The structure of the code is flat there is no file or folder organisation
- There are larger multiclass components such as Particle tracking, Physics processes and lattice calcualtions but these are only grouped in code not in file structure
- There are no git rules for commits

=== Process View
#figure(```pintora
classDiagram
class CoreSimulation {
  calculateParticle()
}

class Visualisation{
  visualise()
}

class worker1{
  doCalculation()
}
class workerN{
  doCalculation()
}

CoreSimulation --> Visualisation
CoreSimulation --> worker1
CoreSimulation --> workerN
```,
caption: [Merlin Process view]) <merlin_process_view>
Each node represents a thread in the process view where the Core simulation can spin up worker threads for calculations in a HPC environment
=== Codescene
#figure(
  image("images/merlin/codescene_coupling.png"),
  caption: [Merlin Codescene coupling graph]
) <merlin_codescene_coupling_graph>
#figure(
  image("images/merlin/codescene_maintainability.png"),
  caption: [Merlin Codescene maintainability circle]
) <merlin_codescene_maintainability_circle>
=== DV8

#figure(
  image("images/merlin/dv8merlin.png"),
  caption: [Merlin Dv8 Dev tool analysis]
) <merlin_dv8_dev_tool_analysis>
#figure(
  image("images/merlin/dv82analysis.png"),
  caption: [Merlin Dv8 high level analysis]
) <merlin_dv8_high_level_analysis>
=== SonarQube
#figure(
  image("images/merlin/20250930_141644.png"),
  caption: [Merlin Technical debt cost]
) <merlin_technical_debt_cost>
#figure(
  image("images/merlin/20250930_141703.png"),
  caption: [Merlin Duplicated code analysis]
) <merlin_duplicated_code_analysis>


=== Understand
#figure(
  image("images/merlin/function_understand.png"),
  caption: [Merlin Function complexity understand]
) <merlin_function_complexity_understand>
#figure(
  image("images/merlin/understand_code_language.png"),
  caption: [Merlin Coding langauge breakdown]
) <merlin_coding_langauge_breakdown> 

#figure(
  image("images/merlin/understand_dependency_graph.png"),
  caption: [Merlin Understand code dependency graph]
) <merlin_understand_code_dependency_graph>
=== C4
#figure(
  image("images/merlin/2025-10-08-12:40:09.png", width: 80%),
  caption: [Merlin C4 Diagram]
) <merlin_c4_diagram>
#figure(
  image("images/merlin/tech_stack.png", width: 60%),
  caption: [Tech Stack]
) <tech_stack>

#pagebreak()
== Fluctuating Finite Element Analysis (FFEA) Case Study 

== Tech Stack

#figure(
  image("images/ffea/tech_stack.png", width: 60%),
  caption: [Tech Stack]
)
The tech stack is primarily focused on C++, the processing and the simulations are all carried out in C++, this is a natural choice as performance is a tenant of the program. The visualisations build on the PyMol library with a plugin. This leads to a natural decoupling where visualisation is separated from processing. This is a suitable tech stack for the project allow for a modular approach and follwing the qualities required for the project. 


#figure(
```pintora
mindmap
@param layoutDirection LR
@param useMaxWidth true
+ Core Domain
++ Larger scale proteins modelled using tetrahedrons instead of atomic
++ Protein Protein interactions
++ Protein visualisations
++ Kinetic state changes can be simulated together with the continuum model
+ Supporting Domain
++ PyMol plugin allowing of FFEA visualisations
++ Distance relations with harmonic potentials
++ Initialisation and analysis tools under a python CLI API
+ Generic Domain
++ Atomic protein modelling
++ Computational Biophysics

```,
  caption: [Domain Model]
)




== Use Case Diagram
#figure(

  image("images/ffea/Use_case.png", width: 80%),
  caption: [Use Case Diagrams]
)
The primary use case for FFEA is to process protein files to then simulate under user desired conditions. The interface is rudimentary in terms of use as the complexity lies in both the simulation and parameters which means that a simple process still has layers of complexity. Looking at the use case there could be an argument to bundle the tooling as the whole purpose of ffeatools is to prepare files for ffea meaning a single unified process that processes then displays based on cli arguments would streamline the process.



== Utility Tree
#figure(
  image("images/ffea/utility_tree.png", width: 80%),
  caption: [Utility Tree]
)
The utility tree is quite idealistic of aspirational long term goals of the project. There is a heavy focus on maintainability as that must be a tenant of the software for the longevity of the project and research. The maintainability goals have been selected as the foundational work needed in terms of refactoring to move the project to a useable state before any new features are added. 

Testability is primarily focused on having a robust test suite to test against to allow simpler refactoring. The goal of 100% test coverage is lofty but a necessary requirement to allow for refactoring with confidence.

Performance is a tenant that is key to the project through the functional requirements but in terms of ilities it is much harder to focus non fucntional requirements through that lens as the testable performance is not easily described.

Useability is targeted towards allowing this tool to be run anywhere regardless of OS as Windows is not supported now but docker can resilve this. THe tool must allow for users to interact with it without needing the wiki to see the help commands and simple processing as well to allow for easier and more vaired user testing and feedback.

== SysML Diagram
#figure(
  image("images/ffea/sysMl.png", width: 80%),
  caption: [SysML Diagram]
)
The SysML diagram highlights the standout requirements of the tool to allow for accurate protein simulations to be done with respect to user input. There are undoubtedly many more functional requirements but assuming the simulations as primarily a black box the requirements centre around accurate simulations to be done and visualised based on the user configuration allowing for the correct interactions to be observed. The requirements are broken into three large logical sections being the processing, simulating and visualing. This SysML structure allows for room for growth as more requirements are discovered.


== Codesense Diagram
#figure(
  image("images/ffea/codesense_architecture.png", width: 80%),
  caption: [Codesense Architecture Diagram]
)
This digram highlights three key things about the architecture decisions taken for this project. The first feature being the flat structure taken for src, this means that all files are the same level and there is no logical grouping for any of the src files which makes grouping much more difficult. The is in spite of the fact that the test files are very well structured.

This leads into the second point of the severe size difference in size between tests and src, this signifies a significant amount of the code is untested making it much more difficult to add to the codebase with confidence.

Lastly looking at the colours of the larger files three files are exceptionally difficult to modify and maintain, again a major hit to maintainability



#pagebreak()

== 4+1 Diagram
=== Logical View
```pintora
  classDiagram
  class InputReader{}
  class MaskGeometryModel{}
  class CoreSimulationLoop{}
  class ProteinSimulationCalculator{}
  class BoundaryCalculator{}
  class PhysicsProcesses{}
  class Renderer{}

  InputReader --> CoreSimulationLoop : Sends data to
  CoreSimulationLoop --> MaskGeometryModel : Makes Calls to
  ProteinSimulationCalculator --> BoundaryCalculator : Makes Calls to
  PhysicsProcesses --> BoundaryCalculator : Makes Calls to
  CoreSimulationLoop --> PhysicsProcesses : Makes calls to
  CoreSimulationLoop --> ProteinSimulationCalculator : Makes Calls to
  CoreSimulationLoop --> MaskGeometryModel : Makes Calls to
  CoreSimulationLoop --> Renderer : Sends data to
```

=== Process View

```pintora
classDiagram
class CoreSimulation {
  calculateParticle()
}

class Visualisation{
  visualise()
}

class worker1{
  doCalculation()
}
class workerN{
  doCalculation()
}

CoreSimulation --> Visualisation
CoreSimulation --> worker1
CoreSimulation --> workerN
```

=== Developmental View
- The file structure is flat
- There is a high level of redundant code
- There is a god class called world
- The tests dont pass
- There are two main simulation sections being rods and blobs
- There is a logical separation between rendering and simulation due to pyton vs c++ being used

=== Physical View
#figure(
  ```pintora
  classDiagram
  class linuxormacmachine{
      + main program
      + worker threads
  }

  ```
)

== SonarQube Diagram
#figure(
  image("images/ffea/sonarqube_complexity.png", width: 80%),
  caption: [SonarQube Complexity Diagram]
)
#figure(
  image("images/ffea/sonarqube_maintainability.png", width: 80%),
  caption: [Understand Function Analysis]
)
This is the cyclomatic complexity of the offending files and others from the codesense analysis. 


== DV8
#figure(
  image("images/ffea/dv8_high_level.png", width: 80%),
  caption: [Understand Function Analysis]
)
#figure(
  image("images/ffea/dv8_low_level.png", width: 80%),
  caption: [Understand Function Analysis]
)

== Understand
#figure(
  image("images/ffea/understand_function.png", width: 80%),
  caption: [Understand Function Analysis]
)
#figure(
  image("images/ffea/complexity_understand.png", width: 80%),
  caption: [Understand Function Analysis]
)

== C4 Diagram
#figure(
  image("images/ffea/2025-10-08-11:06:59.png", width:80%),
  caption: [C4 Diagram]
)

== Dependency Graph
#figure(
  image("images/ffea/2025-10-09-13:50:35.png", width:80%),
  caption: [Dependency Graph]
)

== Class Diagram
#figure(
  image("images/ffea/2025-10-09-13:51:26.png", width: 80%),
  caption: [Class Diagram]
)

#pagebreak()
= iDavie Case Study

== Tech Stack
- Renderer : Unity with C\#
- Interaction Framework : Steam VR
- Simulation Framework : C++ with eigen and boost
- Tests : Ctest with python add ons


== Domain Model
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


== Utility Tree
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
== Use case diagram 

#figure(image("images/idavie/2025-10-07-21:10:14.png", width: 80%), caption: [Use case state machine])

== 4 + 1 Diagram
=== Logical View
#figure(
  image("images/idavie/Pasted image 20251014134042.png", width: 80%),
  caption : [Logical View]
)

=== Physical view
```pintora
classDiagram
class LinuxOrMacMachine{
  + data thread
  + main thread
  + simulation thread
}
```
=== Process View
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
=== Developmental View
- Not extensible, forking is recommmended to add large features
- High change propagation
- Current core is fairly static
- Data management is the largest dependency and a core of the codebase
- There is logcial grouping of files
- No automated tests
- PRs need to go through manual testing via form for changes

== Codescene
#figure(image("images/idavie/2025-10-07-17:28:17.png", width: 80%), caption: [Codescene coupling diagram 40%])
#figure(image("images/idavie/2025-10-07-17:27:55.png", width: 80%), caption: [Codescene Maintenance Diagram])
#figure(image("images/idavie/2025-10-07-22:03:44.png", width: 80%), caption: [Codescene Hotspot overview])
== Sonarqube 
#figure(image("images/idavie/2025-10-07-22:02:56.png", width: 80%), caption: [Sonarqube cyclomatic complexity])
#figure(image("images/idavie/2025-10-07-22:03:05.png", width: 80%), caption: [Sonarqube maintainability])
#figure(image("images/idavie/2025-10-07-22:03:10.png", width: 80%), caption: [Sonarqube reliability graph])

#figure(image("images/idavie/2025-10-07-22:03:24.png", width: 80%), caption: [Duplications Graph])

== Understand Code Analysis
#figure(
  image("images/idavie/2025-10-09-13:46:42.png", width: 80%),
  caption: []
)

== Class Diagrams
#figure(
  image("images/idavie/2025-10-09-13:48:25.png", width: 80%),
  caption: []
)

#figure(
  image("images/idavie/2025-10-09-13:48:47.png", width: 80%),
  caption: []
)
== C4 Diagram
#figure(
  image("images/idavie/2025-10-09-15:09:49.png", width: 80%),
  caption: [C4 Diagram]
)


#pagebreak()

= ACTS Case Study 


== Tech Stack
Main Language: C++

Heavily used external libraries: Eigen, boost, cmake

Used for example scripts: Python bindings using pybind11

Containerisation: Docker




#figure(
```pintora
mindmap
@param layoutDirection LR
@param useMaxWidth true
+ Core Domain
++ Particle track reconstruction for high energy physics
++ Extensive test bed for high modularity testing
++ Geometry material modelling
++ Detector Material Modelling
++ GPU support
+ Supporting Domain
++ Atlas Common Tracking Software
++ Open Data Detector
++ Machine learning
++ Hadronic Field Modelling
++ Magnetic Field Modelling
+ Generic Domain
++ Runge-Kutta-Nyström RKN method
++ Kalman Filter
++ High non-gaussian systems
```,
  caption: [Domain Model]
)

== Utility Tree
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

== Use Case Diagram

#figure(
  image("images/acts/2025-10-13-20:55:48.png", width: 80%),
  caption: [Use Case Diagram]
)


== 4+1 Diagram

=== Logical View
#figure(```pintora
classDiagram
  class TrackReconstruction{
  }
  class VertexReconstruction{
  }
  class PatternRecognition{
  }
  class ParticleIdentifier{
  }
  class VisualisationFramework{
  }
  class PerformanceOptimisation{}
  class Simulation{}
  class CoreApplication{}
  class UserInterface{}
  class AlgorithmApp{}
  UserInterface --> CoreApplication : Sends Requests to
  CoreApplication --> AlgorithmApp : Makes calls to
  AlgorithmApp --> TrackReconstruction : Makes calls to
  AlgorithmApp --> VertexReconstruction : Makes calls to
  AlgorithmApp --> PatternRecognition : Makes calls to
  AlgorithmApp --> ParticleIdentifier : Makes calls to
  AlgorithmApp --> VisualisationFramework : Makes calls to
  AlgorithmApp --> PerformanceOptimisation : Makes calls to
  CoreApplication --> Simulation : Makes calls to

```,
caption: []
)

=== Process view

#figure(
  ```pintora
  classDiagram
  class SimulationProcess{}
  class CalculationProcessLoop{}
  
  CalculationProcessLoop --> SimulationProcess : Might make calls to
  ```,
  caption: [Process view]
)

=== Physcial View
#figure(
  ```pintora
  classDiagram
    class LinuxOrMacMachine{
      + Main program
  }

  ```
)

=== Development View
- There are two layers of folder organistion in the codebase. The first is include/ and src/ follwing that there are logical groupings such as Geometry/ but there are some subfolders with a high file count befitting another layer of depth which is not in place. Geometry/ has over 30 files flat
- There is a consistent commit structure and rule
- Integration tests are loosely handled in 

== Codescene
#figure(
  image("images/acts/2025-10-13-20:20:01.png", width: 80%),
  caption: [Dependency Coupling Graph]
)
#figure(
  image("images/acts/2025-10-13-20:21:32.png", width: 80%),
  caption: [Technical Debt Codescene]
)

== Understand
#figure(
  image("images/acts/2025-10-13-20:27:38.png", width: 80%),
  caption: [Understand High Level Info]
)
#figure(
  image("images/acts/2025-10-13-20:28:11.png", width: 80%),
  caption: [Understand complexity ratings]
)
#figure(
  image("images/acts/2025-10-13-20:29:40.png", width: 80%),
  caption: [Class Diagram Inheritance]
)
#figure(
  image("images/acts/2025-10-13-20:29:48.png", width: 80%),
  caption: [Class Diagram flat]
)

== Sonarqube

#figure(
  image("images/acts/2025-10-14-12:21:07.png", width:80%),
  caption: []
)
#figure(
  image("images/acts/2025-10-14-12:21:13.png", width:80%),
  caption: []
)
#figure(
  image("images/acts/2025-10-14-12:21:31.png", width:80%),
  caption: []
)
#figure(
  image("images/acts/2025-10-14-12:22:07.png", width:80%),
  caption: []
)

== C4
#figure(
  image("images/acts/2025-10-16-15:12:38.png", width:80%),
  caption: [Context Diagram]
)

#figure(
  image("images/acts/2025-10-16-15:12:45.png", width:80%),
caption: [Component Diagram]
)
#figure(
  image("images/acts/2025-10-16-15:12:48.png", width:80%),
  caption: [Container Diagram]
)

#bibliography("references.bib")
