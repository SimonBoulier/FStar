# Fstar build container
FROM everest_base_image:1

ARG BUILDLOGfILE
ARG MAXTHREADS

#BUILD FSTAR
RUN mkdir ${MYHOME}/FStar
COPY --chown=everest / ${MYHOME}/FStar/
RUN rm -rf  ${MYHOME}/FStar/.git
WORKDIR ${MYHOME}/FStar
RUN echo ${MAXTHREADS} >> ${BUILDLOGfILE}
RUN echo $(date -u '+%Y-%m-%d %H:%M:%S') >> ${BUILDLOGfILE} 
RUN make -C src/ocaml-output && make -j "${MAXTHREADS}" -C ulib/ml >> ${BUILDLOGfILE}
RUN echo $(date -u '+%Y-%m-%d %H:%M:%S') >> ${BUILDLOGfILE}


