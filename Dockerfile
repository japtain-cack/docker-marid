FROM openjdk:14-jdk

USER root

ENV REMCO_VER 0.11.1
ENV MARID_VER 2.15.0
ENV JRUBY_VER 9.2.7.0

# Install Remco
RUN wget https://github.com/HeavyHorst/remco/releases/download/v${REMCO_VER}/remco_${REMCO_VER}_linux_amd64.zip && \
	unzip remco_${REMCO_VER}_linux_amd64.zip && rm remco_${REMCO_VER}_linux_amd64.zip && \
	mv remco_linux /bin/remco

# Install Marid and JRuby
RUN curl -O https://s3-us-west-2.amazonaws.com/opsgeniedownloads/repo/opsgenie-marid_${MARID_VER}_all.deb && \
  dpkg -i opsgenie-marid_${MARID_VER}_all.deb && \
  curl -o /var/lib/opsgenie/marid/jruby-complete-${JRUBY_VER}.jar https://s3.amazonaws.com/jruby.org/downloads/${JRUBY_VER}/jruby-complete-${JRUBY_VER}.jar

# Setup marid user
RUN adduser --shell /bin/bash --home /home/marid --gecos "" --disabled-password marid && \
  passwd -d marid && \
  addgroup marid sudo

# Add Tini (A tiny but valid init for containers) https://github.com/krallin/tini
RUN wget -O /tini https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini && \
  wget -O /tini.asc https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini.asc && \
  gpg --batch --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7 && \
  gpg --batch --verify /tini.asc /tini && \
  chmod +x /tini

# Install Remco configs
COPY remco /etc/remco

USER marid
WORKDIR /home/marid

# Copy over scripts
COPY ./files/entrypoint.sh ./

EXPOSE 80
ENTRYPOINT ["/tini", "--", "./entrypoint.sh"]

