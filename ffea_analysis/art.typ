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

#figure(
  image("tech_stack.png", width: 60%),
  caption: [Tech Stack]
)
The tech stack is primarily focused on C++, the processing and the simulations are all carried out in C++, this is a natural choice as performance is a tenant of the program. The visualisations build on the PyMol library with a plugin. This leads to a natural decoupling where visualisation is separated from processing. This is a suitable tech stack for the project allow for a modular approach and follwing the qualities required for the project. 


#pagebreak()
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



#pagebreak()

= Use Case Diagram
#figure(

  image("Use_case.png", width: 80%),
  caption: [Use Case Diagrams]
)
The primary use case for FFEA is to process protein files to then simulate under user desired conditions. The interface is rudimentary in terms of use as the complexity lies in both the simulation and parameters which means that a simple process still has layers of complexity. Looking at the use case there could be an argument to bundle the tooling as the whole purpose of ffeatools is to prepare files for ffea meaning a single unified process that processes then displays based on cli arguments would streamline the process.



= Utility Tree
#figure(
  image("utility_tree.png", width: 80%),
  caption: [Utility Tree]
)
The utility tree is quite idealistic of aspirational long term goals of the project. There is a heavy focus on maintainability as that must be a tenant of the software for the longevity of the project and research. The maintainability goals have been selected as the foundational work needed in terms of refactoring to move the project to a useable state before any new features are added. 

Testability is primarily focused on having a robust test suite to test against to allow simpler refactoring. The goal of 100% test coverage is lofty but a necessary requirement to allow for refactoring with confidence.

Performance is a tenant that is key to the project through the functional requirements but in terms of ilities it is much harder to focus non fucntional requirements through that lens as the testable performance is not easily described.

Useability is targeted towards allowing this tool to be run anywhere regardless of OS as Windows is not supported now but docker can resilve this. THe tool must allow for users to interact with it without needing the wiki to see the help commands and simple processing as well to allow for easier and more vaired user testing and feedback.

= SysML Diagram
#figure(
  image("sysMl.png", width: 80%),
  caption: [SysML Diagram]
)
The SysML diagram highlights the standout requirements of the tool to allow for accurate protein simulations to be done with respect to user input. There are undoubtedly many more functional requirements but assuming the simulations as primarily a black box the requirements centre around accurate simulations to be done and visualised based on the user configuration allowing for the correct interactions to be observed. The requirements are broken into three large logical sections being the processing, simulating and visualing. This SysML structure allows for room for growth as more requirements are discovered.


= Codesense Diagram
#figure(
  image("codesense_architecture.png", width: 80%),
  caption: [Codesense Architecture Diagram]
)
This digram highlights three key things about the architecture decisions taken for this project. The first feature being the flat structure taken for src, this means that all files are the same level and there is no logical grouping for any of the src files which makes grouping much more difficult. The is in spite of the fact that the test files are very well structured.

This leads into the second point of the severe size difference in size between tests and src, this signifies a significant amount of the code is untested making it much more difficult to add to the codebase with confidence.

Lastly looking at the colours of the larger files three files are exceptionally difficult to modify and maintain, again a major hit to maintainability



#pagebreak()


= SonarQube Diagram
#figure(
  image("sonarqube_complexity.png", width: 80%),
  caption: [SonarQube Complexity Diagram]
)
#figure(
  image("sonarqube_maintainability.png", width: 80%),
  caption: [Understand Function Analysis]
)
This is the cyclomatic complexity of the offending files and others from the codesense analysis. 


= DV8
#figure(
  image("dv8_high_level.png", width: 80%),
  caption: [Understand Function Analysis]
)
#figure(
  image("dv8_low_level.png", width: 80%),
  caption: [Understand Function Analysis]
)

= Understand
#figure(
  image("understand_function.png", width: 80%),
  caption: [Understand Function Analysis]
)
#figure(
  image("complexity_understand.png", width: 80%),
  caption: [Understand Function Analysis]
)

= C4 Diagram
#figure(
  image("2025-10-08-11:06:59.png", width:80%),
  caption: [C4 Diagram]
)

= Dependency Graph
#figure(
  image("2025-10-09-13:50:35.png", width:80%),
  caption: [Dependency Graph]
)

= Class Diagram
#figure(
  image("2025-10-09-13:51:26.png", width: 80%),
  caption: [Class Diagram]
)

= References
- Typst Documentation: https://typst.app/docs/

#pagebreak()
