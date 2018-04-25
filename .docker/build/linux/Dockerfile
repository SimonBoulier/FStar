# Fstar build container
FROM everest_base_image:1

#BUILD FSTAR
RUN mkdir ${MYHOME}/FStar
COPY --chown=everest / ${MYHOME}/FStar/
RUN rm -rf  ${MYHOME}/FStar/.git
WORKDIR ${MYHOME}/FStar
RUN make -C src/ocaml-output && make -j 48 -C ulib/ml > buildlog.txt


