FROM blang/latex

ENV TZ="Etc/UTC"

RUN apt-get update -y \
    && echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections \
    && apt-get install -y ttf-mscorefonts-installer \
    && fc-cache -f

