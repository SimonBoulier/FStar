# Fstar build container
FROM everest_base_image:1

ARG MAXTHREADS

#BUILD FSTAR
RUN mkdir ${MYHOME}/FStar
COPY --chown=everest / ${MYHOME}/FStar/
RUN rm -rf  ${MYHOME}/FStar/.git
WORKDIR ${MYHOME}/FStar
RUN echo $(date -u '+%Y-%m-%d %H:%M:%S') >> buildlog.txt 
RUN make -C src/ocaml-output && make -j ${MAXTHREADS} -C ulib/ml >> buildlog.txt
RUN echo $(date -u '+%Y-%m-%d %H:%M:%S') >> buildlog.txt


