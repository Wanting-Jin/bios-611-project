FROM rocker/verse
RUN apt update && apt-get install -y emacs openssh-server python3-pip
RUN R -e "install.packages(c(\"shiny\",\"deSolve\",\"signal\"))"
RUN R -e "install.packages(\"rmarkdown\")";
RUN R -e "install.packages(\"reshape2\")";
RUN R -e "install.packages(\"tidyverse\")";
RUN R -e "install.packages(\"gtsummary\")";
RUN R -e "install.packages(c(\"flextable\",\"webshot\"))";
RUN R -e "install.packages(c(\"survival\",\"survminer\"))";
RUN apt-get update
RUN apt-get install nano
