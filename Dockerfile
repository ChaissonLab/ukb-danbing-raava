FROM ubuntu:20.04
  
RUN apt-get update && \
  apt-get install -y --no-install-recommends libz-dev libncurses5-dev libbz2-dev liblzma-dev libssl-dev make gcc g++ autoconf python3-pip && \
  pip install numpy==1.23.3 pandas==1.5.0 scikit-learn==1.1.2 && \
  apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /opt

COPY samtools-1.21.tar.bz2 .

RUN bunzip2 samtools-1.21.tar.bz2 && \
  tar xvf samtools-1.21.tar && \
  cd samtools-1.21 && \
  ./configure && make -j 8 && make install && \
  cd .. && rm -rf samtools-1.21*

COPY raava/script/kmerutils.py raava/script/rarevar.call.py raava/script/TR_bubble_search.py raava/script/binaryIO.py /usr/local/bin/

RUN rm -rf raava

COPY danbing-tk ./danbing-tk

RUN cd danbing-tk && mkdir -p bin && \
  make bin/danbing-tk && \
  cp bin/danbing-tk /usr/local/bin/ && \
  cd .. && rm -rf danbing-tk

