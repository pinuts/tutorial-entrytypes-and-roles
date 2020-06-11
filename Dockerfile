FROM openjdk:11.0-jdk

RUN adduser --system --disabled-password --home /UM --shell /bin/bash --uid 102 um

COPY build/UM-current.sh .um.varfile /
COPY .docker-entrypoint.sh /UM/docker-entrypoint.sh
RUN chown -R um /UM

WORKDIR /UM
USER um

# Persist certain config files:
RUN mkdir /UM/.install4j
RUN sh /UM-current.sh -q -dir ~ -varfile /.um.varfile
RUN chmod +x /UM/docker-entrypoint.sh
RUN echo "cmsbs.gui.login = internal\ncmsbs.database.url=jdbc:h2:/UM/cmsbs-work/db.h2\ncmsbs.log.allFilesToStdout = true\ncmsbs.directory.listen.syncWithVfs = true\ninclude.1 = cmsbs-conf/docker.properties" >> /UM/cmsbs-conf/cmsbs.properties
RUN sed -i /UM/scripts/.umrc -e 's/LC_CTYPE=.*/# Removed by Dockerfile/'

# ----------------------------------------------------

FROM openjdk:11.0-jdk

EXPOSE 8080

RUN adduser --system --disabled-password --home /UM --shell /bin/bash um
ENV TZ=Europe/Berlin
ENV LC_LOCALE=C.UTF-8

COPY --from=0 /UM /UM/
COPY build/current.zip /UM/um-project.zip
RUN chown -R um.nogroup /UM

VOLUME [ "/UM/cmsbs-work", "/UM/cmsbs-persistent-conf" ]

ENTRYPOINT ["/UM/docker-entrypoint.sh"]
