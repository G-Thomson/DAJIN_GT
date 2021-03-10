FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive 

RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-utils \
    build-essential \
    python3.8 \
    python3-pip \
    python3-setuptools \
    python3-dev \
    build-essential \
    r-base \
    wget \
    curl \ 
    gcc \ 
    bzip2 \ 
    make \
    zlib1g \ 
    zlib1g-dev \
    libpng-dev \
    mysql-server \
    libmysqlclient-dev \
    emboss \
    samtools \
    # R packages
    && Rscript -e "install.packages('reticulate', dependencies=TRUE)" \
    && Rscript -e "install.packages('vroom', dependencies=TRUE)" \
    && Rscript -e "install.packages('furrr', dependencies=TRUE)" \
    # Minimap2
    && cd /usr/local/ \ 
    && wget https://github.com/lh3/minimap2/releases/download/v2.17/minimap2-2.17.tar.bz2 \
    && tar -xjvf minimap2-2.17.tar.bz2 \ 
    && cd minimap2-2.17 \ 
    && make \
    && mv minimap2 /usr/local/bin \
    && cd ..  
    
ENV MACHTYPE=x86_64
RUN curl -OL http://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/blat/blat \
    && chmod u+x blat \
    && mv -v blat /usr/local/bin \    
    && curl -OL http://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/faToTwoBit \
    && chmod u+x faToTwoBit \
    && mv -v faToTwoBit /usr/local/bin \
    && curl -OL http://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/twoBitInfo \
    && chmod u+x twoBitInfo \
    && mv -v twoBitInfo /usr/local/bin \
    && curl -OL http://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/twoBitToFa \
    && chmod u+x twoBitToFa \
    && mv -v twoBitToFa /usr/local/bin \
    && curl -OL http://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/pslToBed \
    && chmod u+x pslToBed \
    && mv -v pslToBed /usr/local/bin \ 
    && curl -OL http://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/pslSelect \
    && chmod u+x pslSelect \
    && mv -v pslSelect /usr/local/bin

COPY requirements.txt .
RUN pip3 install -r requirements.txt

RUN ln -s /usr/bin/python3 /usr/bin/python \ 
    && ln -s /usr/bin/pip3 /usr/bin/pip

RUN cd / \
    && rm -rf /tmp/* \
    && apt-get remove --purge -y $BUILDDEPS \
    && rm -rf minimap2-2.17.tar.bz2 minimap2-2.17 \
    && apt-get remove -y wget curl gcc bzip2 make zlib1g-dev \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* 

WORKDIR /home

ENTRYPOINT ["/bin/bash"]
