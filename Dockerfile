FROM python:2.7.8
RUN apt-get update ; apt-get install emacs-nox -y
RUN easy_install cython
# If you compile a statically linked program
# /usr/bin/ld: /usr/lib/gcc/x86_64-linux-gnu/4.9/crtbeginT.o: relocation R_X86_64_32 aga# inst `__TMC_END__' can not be used when making a shared object; recompile with -fPIC
# /usr/lib/gcc/x86_64-linux-gnu/4.9/crtbeginT.o: error adding symbols: Bad value
# collect2: error: ld returned 1 exit status
# http://askubuntu.com/questions/530617/how-to-make-a-static-binary-of-coreutils/530647#530647
RUN cp /usr/lib/gcc/x86_64-linux-gnu/4.9/crtbeginS.o /usr/lib/gcc/x86_64-linux-gnu/4.9/crtbeginT.o

ADD Static.make StaticSetup add_builtins.py /usr/src/python/
ENV PATH /usr/local/python-static/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
RUN make -f Static.make ;\
    make install;\
		mkdir -p /build/src
WORKDIR /build/src
ONBUILD ADD . /build/src