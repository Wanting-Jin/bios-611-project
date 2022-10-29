FROM rocker/verse
RUN apt update && apt-get install -y emacs openssh-server python3-pip
RUN R -e "install.packages(c(\"shiny\",\"deSolve\",\"signal\"))"
RUN R -e "install.packages(\"Rcpp\")";
RUN R -e "install.packages(\"reticulate\")";
RUN R -e "install.packages(\"ppclust\")";
RUN R -e "install.packages(\"gbm\")";
RUN R -e "install.packages(\"rdist\")";
RUN R -e "install.packages(\"caret\")";
RUN R -e "install.packages(\"reshape\")"
RUN apt-get update
RUN apt-get install nano
