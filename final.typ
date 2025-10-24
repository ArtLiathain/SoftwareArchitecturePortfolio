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
The current codebase is an artifact that seeks to achieve High speed particle simulation @merlin_domain_model.
In development an accidental architecture @merlin_c4_diagram formed as ad-hoc feature development approach meant that the only concrete architectural factor was the tech stack(@merlin_tech_stack).
@merlin_codescene_maintainability_circle is a clear example of the outcome of this, a jumbled mess of code mashed together.

While successful in achieving functionality the code architecture makes change difficult and has slowed the potential development of features due to the complexity of adding new features.
The key issues that must be resolved are:
- The blurring of lines of one off features verses core development goals
- Adding proper tests which run in a consistent reproducible manner
- Improving the flexibility of the code to allow new developers to contribute new features

== Proposed Architecture
To address these issues, looking at the Merlin documentation highlights the two key architectural goals the project had in development; to do the job in the simplest form and to produce a set of loosely coupled components which are easily maintainable @appleby_merlin_2022.


These goals along with the core purpose of the system being simulation leads me to believe that a microkernel architecture is the best architecture for this project.
A microkernel architecture is a system built around a single purpose, in this case simulation while allowing a plugin system to introduce new functionality without changing the core code @microsoft_corporation_net_2009.

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

Adopting a microkernel architecture would provide a stable testable core, while rust would optimise the performance and robustness of the simulation, integral to high precision simulations (highlighted here @merlin_utility_tree).
These changes would improve the long term maintainability of the code, as well as preventing unsafe code from entering the codebase.

Additionally, Rust inherently supports the functional programming paradigm, which I believe is well placed in the plugin-based architecture.
If plugins are enforced to be functional, they will act as stateless modules interacting through interfaces, reducing the risk of architectural drift @ernst_technical_2021 as a plugin with state could become a dependency.
Merlin can then maintain clear separation between the stable simulation kernel and user-developed extensions, ensuring long-term scalability and maintainability while allowing feature flexibility.


== Conclusion
This architecture proposal aligns with the ideal goals Merlin had laid out @appleby_merlin_2022.
Allowing merlin developers to focus on new features to develop over jumping around spaghetti code trying to understand issues.
Shifting the focus from maintenance and compiling being the standard to a robust performant easily extensible system being at the core of CERN high speed particle tracking simulations.


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

#pagebreak()
= Fluctuating Finite Element Analysis (FFEA) Case Study

== Current state
FFEA is a tool primarily focused on simulating larger scale proteins using tetrahedrons (@ffea_domain_model) as well as preparing protein files for simulation(FFEA Tools).
The tool works as intended but due to the haphazard development a God class based architecture has developed as seen in @ffea_class_diagram.
Overloaded classes blatantly breaking single responsibility has lead to classes with cyclomatic complexity in the hundreds @ffea_complexity_diagram.


Complexity at this scale severely reduces the capabilities of new developers contributing to the project as the god class must be understood at a base level. 
Reducing the number of new experiments that can be carried out.


== Proposed Architecture
The current state of the project needs extensibility and maintainability as core parts of the new architecture as described @ffea_utility_tree.
The architecture that best fits the use case is a microkernel architecture @microsoft_corporation_net_2009. 


A microkernel architecture is a system built around a single purpose, in this case simulation while allowing a plug-in system to introduce new functionality without changing the core code @microsoft_corporation_net_2009.

#figure(image("./images/2025-10-23-14:21:46.png"),
caption: [MicroKernel Architecture Diagram])



The advantages this brings are numerous:
- The core code being largely static encourages *testability* and *robustness* as a set of comprehensive tests to be developed and maintained.
- As the kernel will be the focus of development *performance* can be improved more easily.
- Removing the plugins from the core developer responsibilities improves *maintainability* as only the core code must be maintained.
- The plugin system allows for development *extensibility*, allowing new features without changing the core code.


== Reasoning
The accidental architecture of god classes in FFEA lends itself well inferring what should be made the microkernel.
The god class (Seen in @ffea_C4_diagram) in FFEA is a solid starting point to the refactor, tackling the biggest problem (@ffea_architecture_codesense)  and converting it to a solid foundation to the new architecture.
This approach addresses the root of the maintainability issue rather than layering more complexity on top.


By adopting a microkernel architecture, FFEA can evolve into a modular and sustainable framework where new experiments and simulation types can be added without disrupting the existing system.
Plug-ins allow for contributors who are focused on testing a new experiment instead of long term code quality can implement features without architecture erosion @ernst_technical_2021.
This shift towards microkernel prioritizes maintainability performance within the core codebase and extensibility for new scientists, the key qualities identified that FFEA needs.

== Conclusion
There is a lot of work to do with FFEA, the codebase is in a continuous loop of; no development, funding for new experiment, implement experiment and repeat.
This vicious cycle is why the code is in the current state as there are no incentives for clean code.
The proposed solution fits well to enable extensibility by many researchers while still preserving the core code from deteriorating between funding cycles.

== Diagrams

=== Tech Stack

#figure(
  image("images/ffea/tech_stack.png", width: 60%),
  caption: [FFEA Tech Stack]
)


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
  caption: [FFEA Domain Model]
) <ffea_domain_model>




=== Use Case Diagram
#figure(

  image("images/ffea/Use_case.png", width: 80%),
  caption: [FFEA Use Case Diagrams]
  
)



=== Utility Tree
#figure(
  ```pintora
  mindmap
  @param layoutDirection LR
  + Maintainability
  ++ Enforce a clear and consistent file structure
  ++ Obey SOLID Principles in class design
  ++ No files with a cyclomatic complexity over 10
  ++ The core classes must not require change for a experiment modification
  + Extensability
  ++ New experiments must not change core functionality
  ++ Experiment features must be able to be combined
  + Performance
  ++ The code must be written in a compiled language
  ++ The code must not leak memory
  ++ The code must use paralellism
  + Useability
  ++ The tool must use docker with containerisation
  ++ The tool must accept external protein files
  ```,
  caption: [Utility Tree]
) <ffea_utility_tree>

=== SysML Diagram
#figure(
  image("images/ffea/sysMl.png", width: 80%),
  caption: [SysML Diagram]
)


=== Codesense Diagram
#figure(
  image("images/ffea/codesense_architecture.png", width: 80%),
  caption: [Codesense Architecture Diagram]
) <ffea_architecture_codesense>




=== 4+1 Diagram
=== Logical View
```pintora
  classDiagram
  class InputReader{}
  class MaskGeometryModel{}
  class CoreSimulationLoop{}
  class ProteinSimulationCalculator{}
  class BoundaryCalculator{}
  class PhysicsProcesses{}

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

=== SonarQube Diagram
#figure(
  image("images/ffea/sonarqube_complexity.png", width: 80%),
  caption: [SonarQube Complexity Diagram]
) <ffea_complexity_diagram>
#figure(
  image("images/ffea/sonarqube_maintainability.png", width: 80%),
  caption: [Understand Function Analysis]
)
This is the cyclomatic complexity of the offending files and others from the codesense analysis. 


=== DV8
#figure(
  image("images/ffea/dv8_high_level.png", width: 80%),
  caption: [Understand Function Analysis]
)
#figure(
  image("images/ffea/dv8_low_level.png", width: 80%),
  caption: [Understand Function Analysis]
)

=== Understand
#figure(
  image("images/ffea/understand_function.png", width: 80%),
  caption: [Understand Function Analysis]
)
#figure(
  image("images/ffea/complexity_understand.png", width: 80%),
  caption: [Understand Function Analysis]
)

=== C4 Diagram
#figure(
  image("images/ffea/2025-10-08-11:06:59.png", width:80%),
  caption: [C4 Diagram]
) <ffea_C4_diagram>

=== Dependency Graph
#figure(
  image("images/ffea/2025-10-09-13:50:35.png", width:80%),
  caption: [Dependency Graph]
)

=== Class Diagram
#figure(
  image("images/ffea/2025-10-09-13:51:26.png", width: 80%),
  caption: [FFEA Class Diagram]
) <ffea_class_diagram>

#pagebreak()
= iDavie Case Study

== Current State
IDavie is primary focused on creating 3d renderings of various inputs that can be explored in VR with data masking @idavie_domain_model.
A key feature of this being the interactivity between the users and the environment which was created ad-hoc.
The current architecture has been reconstructed by the current developers @idavie_logical_view.
As seen in the diagram, the architecture is disorganised with a disproportionate amount of emphasis put on the DataManager.
This accidental architecture came to be due to ever flowing requirements and fixes being applied one on top of the other to the codebase.

Currently the code is in such a state that adding a feature such as particles over the current astronomy rendering requires a fork and a fundamental restructuring to complete.
A contributing factor is the high coupling of evolutionary dependencies @ernst_technical_2021 @idavie_coupling.
Maintainability of the codebase is nonexistent and for pull requests, manual testing by the means of a google form must be completed.
Showing at a foundational level that standard practice is not being followed allowing additional architectural deterioration.


== Proposed Architecture
The key features IDavie needs are *useability*, *maintainability* and *extensibility* seen here @idavie_utility_tree.
The architecture that best fits the use case is a microkernel architecture @microsoft_corporation_net_2009. 
A microkernel architecture is a system built around a single purpose, in this case the astrophysics simulation, while creating a plug-in system to introduce new functionality without changing the core code @microsoft_corporation_net_2009.

#figure(image("./images/2025-10-23-14:21:46.png"),
caption: [MicroKernel Architecture Diagram])



The advantages this brings are numerous:
- The core code being largely static encourages *testability* and *robustness* as a set of comprehensive tests to be developed and maintained.
- As the kernel will be the focus of development *performance* can be improved more easily.
- Removing the plugins from the core developer responsibilities improves *maintainability* as only the core code must be maintained.
- The plugin system allows for development *extensibility*, allowing new features without changing the core code.

== Reasoning
IDavie at its core it a 3D volumetric rendering tool in VR that allows user interaction seen in this use case diagram @idavie_use_case_diagram @noauthor_introduction_nodate.
To continue expanding into new fields such as particle simulation, it needs a structure that prioritises controlled extensibility.


The microkernel architecture would create a core simulation, regulating features such as astrophysics or medical imaging to plug-ins @noauthor_introduction_nodate.
Therefore changing the identity of IDavie to be a platform to allow all kinds of volumetric rendering, allowing developers to contribute independently without disrupting the core system.

In practice maintainability and usability would be core tenants of the new architecture.
The static core would reduce the maintenance load on the team as well as allow for a planned consistent user interface as well as other core features to be developed that would not change based on ad-hoc new features.

== Conclusion
In the long term, transitioning to a microkernel design would change IDavie from a tightly coupled tool into a robust, maintainable, extensible platform.
It would enable consistent development on the core features, while encouraging new developers to add functionality through plugins.
This shift would not only improve current performance and usability but also ensure IDavie can continue to grow as new rendering technologies and scientific needs emerge.

== Diagrams
=== Tech Stack
- Renderer : Unity with C\#
- Interaction Framework : Steam VR
- Simulation Framework : C++ with eigen and boost
- Tests : Ctest with python add ons


=== Domain Model
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
) <idavie_domain_model>


=== Utility Tree
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
+ Extensability
++ New experiments must not change core functionality
++ Experiment features must be able to be combined
+ Useability
++ Create a docker image to allow for repeatable deployments
++ Update the docuementation to allow for a user guide on how to run the code

```,
  caption: [Utility Tree]
) <idavie_utility_tree>
=== Use case diagram 

#figure(image("images/idavie/2025-10-07-21:10:14.png", width: 80%), caption: [Use case state machine]) <idavie_use_case_diagram>

=== 4 + 1 Diagram
=== Logical View
#figure(
  image("images/idavie/Pasted image 20251014134042.png", width: 80%),
  caption : [Logical View]
) <idavie_logical_view>

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

=== Codescene
#figure(image("images/idavie/2025-10-07-17:28:17.png", width: 80%), caption: [Codescene coupling diagram 40%]) <idavie_coupling>
#figure(image("images/idavie/2025-10-07-17:27:55.png", width: 80%), caption: [Codescene Maintenance Diagram]) <idavie_maintenance>
#figure(image("images/idavie/2025-10-07-22:03:44.png", width: 80%), caption: [Codescene Hotspot overview])
=== Sonarqube 
#figure(image("images/idavie/2025-10-07-22:02:56.png", width: 80%), caption: [Sonarqube cyclomatic complexity])
#figure(image("images/idavie/2025-10-07-22:03:05.png", width: 80%), caption: [Sonarqube maintainability])
#figure(image("images/idavie/2025-10-07-22:03:10.png", width: 80%), caption: [Sonarqube reliability graph])

#figure(image("images/idavie/2025-10-07-22:03:24.png", width: 80%), caption: [Duplications Graph])

=== Understand Code Analysis
#figure(
  image("images/idavie/2025-10-09-13:46:42.png", width: 80%),
  caption: [Understand IDavie]
)

=== Class Diagrams
#figure(
  image("images/idavie/2025-10-09-13:48:25.png", width: 80%),
  caption: [FLat class diagram Idavie]
)

#figure(
  image("images/idavie/2025-10-09-13:48:47.png", width: 80%),
  caption: [Hierarchical Class diagram Idavie]
)
=== C4 Diagram
#figure(
  image("images/idavie/2025-10-09-15:09:49.png", width: 80%),
  caption: [C4 Diagram]
)


#pagebreak()

= ACTS Case Study 
== Current State
ACTS is a particle tracking software library built on the ATLAS common track as a base. @noauthor_acts_nodate
The current goal of the software is to provide high quality particle tracking in a performant modular way, captured in this domain model @acts_domain_model.

The current architecture is closest to a microkernel architecture @microsoft_corporation_net_2009, this fits well for the use case focusing development on static core to the codebase.
The primary issues with the codebase are:
- Some plugins are moving to be a core dependency which is mentioned in the documentation, introducing architectural drift @ernst_technical_2021.
- The current codebase is still dealing with technical debt from building upon the ATLAS codebase. @acts_maintainability
- There are examples which are being called integration tests taking a majority of the codebase @acts_architecture_map
- There is extremely high coupling 90% across many components these evolutionary dependencies slow down features severely @acts_codescene_coupling

== Proposed Architecture
To address these issue I believe a modular monolith with purely functional APIs is the best approach.
A regular monolithic structure would have one single, indivisible unit whereas a modular monolith takes this approach but breaks the structure down into logical high level groupings which could be represented as containers in a C4 diagram @acts_c4_container.

The benefits this brings are:
- Strong grouping of components making any coupling explicit and allowing changes in components without altering others similar to how a layered architecture.
- The functional interfaces would simplify parallelism and improve performance.
- It still allows extension in the form of plugins, as new plugins can add new modularity without changing core behaviour
- A shared runtime ensures the entire codebase is on the same dependencies not allowing version drift over time between plugins

== Reasoning
The principle goal for acts is to model particle tracking, with the key qualities for usage being performance and reliability, while maintainability is at the forefront for developers @acts_utility_tree.
The current microkernel-style design has worked well for flexibility, but the growing coupling and architectural drift show that the boundaries between the kernel and plugins have blurred over time.
A functional modular monolith aligns directly with these priorities.

Grouping related code into cohesive components naturally reduces cross cutting dependencies @gharbi_software_2019 and encapsulates the code logically.
Similar to a layered architecture this separation of concerns would encourage concurrent development without the overhead of distributed complexity.
The shared monolithic runtime also helps avoid version drift between plugins/components and ensures consistent performance across all modules, something that’s critical for simulation reproducibility.

Adopting purely stateless function calls through the functional paradigm allows for users to expect consistent *deterministic* results regardless of internal state or previous function calls.
This characteristic directly parallels the deterministic nature of physical simulations; given identical inputs, the output must always be consistent.
Such a design not only supports reproducibility and testability but also aligns the software’s logical model with the scientific principles.
It also allows for safe parallel execution and reproducibility across hardware configurations, which are essential for CERN-scale computations.

== Conclusion
Long term this architecture strikes a balance between maintainability, performance and precision.
Enabling the library to grow without fragmenting into disparate components or becoming tightly coupled to a repository wide cross cutting dependency.
Ensuring ACTS will remain a strong developing library for high speed particle tracking in the long term.

== Diagrams

=== Tech Stack
Main Language: C++

Heavily used external libraries: Eigen, boost, cmake

Used for example scripts: Python bindings using pybind11

Containerisation: Docker



=== Domain Model
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
++ Flexible usage through specific APIs
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
) <acts_domain_model>

=== Utility Tree
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
+ Reliability
++ The code must be deteministic

```,
  caption: [Utility Tree]
) <acts_utility_tree>

=== Use Case Diagram

#figure(
  image("images/acts/2025-10-13-20:55:48.png", width: 80%),
  caption: [Use Case Diagram]
)


=== 4+1 Diagram

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

=== Codescene
#figure(
  image("images/acts/2025-10-13-20:20:01.png", width: 80%),
  caption: [Dependency Coupling Graph]
) <acts_codescene_coupling>
#figure(
  image("images/acts/2025-10-13-20:21:32.png", width: 80%),
  caption: [Technical Debt Codescene]
) <acts_architecture_map>

=== Understand
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

=== Sonarqube

#figure(
  image("images/acts/2025-10-14-12:21:07.png", width:80%),
  caption: [Maintainability Overview]
) <acts_maintainability>
#figure(
  image("images/acts/2025-10-14-12:21:31.png", width:80%),
  caption: [Cyclomatic Complexity overview]
)
#figure(
  image("images/acts/2025-10-14-12:22:07.png", width:80%),
  caption: [Cyclomatic Complexity files]
)

=== C4
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
) <acts_c4_container>

#bibliography("references.bib")
