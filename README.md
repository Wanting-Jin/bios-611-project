UNC BIOS 611 Project
=======================
This is a project created by Wanting Jin for BIOS 611 at UNC, Chapel Hill.


## Introduction
Allogeneic hematopoietic stem cell transplantation (HSCT) is a standard therapy for children with a variety of both malignant (i.a. acute lymphoblastic leukemia, acute myelogenous leukemia) and nonmalignant diseases (i.a. severe aplastic anemia, Fanconi anemia). It is of significant importance to find matched donor such that ensure success outcome and reduce the risk of complications like graft-versus-host disease after transplantation procedure. In gereral, Human Leukocyte Antigens (HLA) Matching is conducted to find out if hematopoietic stem cells match between the donor and the patient receiving the transplant. However, due to the difficulty and time consuming to find a fully matched donor, it is acceptable to use unrelated donors mismatched at 1-2 HLA alleles. Previous research also proposed that increased dosage of CD34+ cells / kg extends overall survival time without simultaneous occurrence of undesirable events affecting patients' quality of life (Kaw艂ak et al., 2010).

This data set describes pediatric patients with several hematologic diseases grouped into malignant disorders and nonmalignant. All patients were subject to the unmanipulated allogeneic unrelated donor hematopoietic stem cell transplantation. A total of 187 patients are included in this data set. And 39 attributes about donor and recipient抯 matching properties and their survival outcomes after transplantation are recorded.


Using This Repository
=====================
This repository is best used via Docker although you may be able to
consult the Dockerfile to understand what requirements are appropriate
to run the code.

Docker is a tool from software engineering (really, deployment) which
is nevertheless of great use to the data scientist. Docker builds an
_environment_ (think of it as a light weight virtual computer) which
contains all the software needed for the project. This allows any user
with Docker (or a compatible system) to run the code without bothering
with the often complex task of installing all the required libraries.

One Docker container is provided for both "production" and
"development." To build it you will need to create a file called
`.password` which contains the password you'd like to use for the
rstudio user in the Docker container. Then you run:

```
docker build . -t 611-project
```

This will create a docker container. Users using a unix-flavor should
be able to start an RStudio server by running:

```
docker run -v $(pwd):/home/rstudio -e PASSWORD=hello -p 8787:8787 -t 611-project
```

You then visit http://localhost:8787 via a browser on your machine to
access the machine and development environment. 


Project Organization
====================

The best way to understand what this project does is to examine the
Makefile.

A Makefile is a textual description of the relationships between
_artifacts_ (like data, figures, source files, etc). In particular, it
documents for each artifact of interest in the project:

1. what is needed to construct that artifact
2. how to construct it

But a Makefile is more than documentation. Using the _tool_ make
(included in the Docker container), the Makefile allows for the
automatic reproduction of an artifact (and all the artifacts which it
depends on) by simply issueing the command to make it.




The final report
================

The final report is wrote using overleaf.




Reference
----------------------------
Krzysztof Kałwak, etc. Higher CD34+ and CD3+ Cell Doses in the Graft Promote Long-Term Survival, and Have No Impact on the Incidence of Severe Acute or Chronic Graft-versus-Host Disease after In Vivo T Cell-Depleted Unrelated Donor Hematopoietic Stem Cell Transplantation in Children,
Biology of Blood and Marrow Transplantation,
Volume 16, Issue 10,
2010,
Pages 1388-1401,
ISSN 1083-8791,
https://doi.org/10.1016/j.bbmt.2010.04.001.
