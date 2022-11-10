# About

Repository containing the files used to build the documentation for the common data model.

# Setup

The Dockerfile creates a container with the necessary software to build the pdf documentation using LaTeX.

# Usage

From the cloned repository:

```
git clone https://github.com/glamod/common_data_model.git
cd common_data_model
docker build -t latex_env .
docker run -it -v ${pwd}:/local latex_env
cd /local/tex
lualatex cdm.tex
``` 

# Notes

The pdf uses the Verdana font from Microsoft. To install the required fonts as part of the install a line needs to be 
uncommented to accept the EULA for the fonts.
