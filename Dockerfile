FROM openjdk:11-jdk-stretch

USER root
WORKDIR /tmp/opsgenie

ENV REMCO_VER 0.11.1
ENV OGINT_VER 2019.18.07
ENV MARID_VER 1.0.0
ENV JRUBY_VER 9.2.7.0
ENV TINI_VERSION v0.18.0

RUN set -eux pipefail && \
  # Update and install packages
  apt-get -y update && apt-get -y install \
    curl \
    wget \
    vim

# Install Remco
RUN wget https://github.com/HeavyHorst/remco/releases/download/v${REMCO_VER}/remco_${REMCO_VER}_linux_amd64.zip && \
	unzip remco_${REMCO_VER}_linux_amd64.zip && rm remco_${REMCO_VER}_linux_amd64.zip && \
	mv remco_linux /bin/remco && \
  chmod +rx /bin/remco

# Install Marid and JRuby
RUN curl -o OpsGenieClient-v2-${OGINT_VER}.zip https://codeload.github.com/opsgenie/opsgenie-integration/zip/OpsGenieClient-v2-${OGINT_VER} && \
  unzip OpsGenieClient-v2-${OGINT_VER}.zip && \
  dpkg -i opsgenie-integration-OpsGenieClient-v2-${OGINT_VER}/jiraservicedesk/packages/opsgenie-jiraServiceDesk_${MARID_VER}_all.deb && \
  curl -o /var/lib/opsgenie/marid/jruby-complete-${JRUBY_VER}.jar https://s3.amazonaws.com/jruby.org/downloads/${JRUBY_VER}/jruby-complete-${JRUBY_VER}.jar

# Setup opsgenie user
RUN passwd -d opsgenie && \
  addgroup opsgenie sudo

# Add Tini (A tiny but valid init for containers) https://github.com/krallin/tini
RUN wget -O /tini https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini && \
  wget -O /tini.asc https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini.asc && \
  gpg --batch --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7 && \
  gpg --batch --verify /tini.asc /tini && \
  chmod +rx /tini

# Install Remco configs
COPY --chown=opsgenie:root remco /etc/remco

USER opsgenie
WORKDIR /var/opsgenie

# Copy over startup scripts
COPY --chown=opsgenie:opsgenie ./files/entrypoint.sh ./
RUN chmod ug+x ./entrypoint.sh

# marid http port
EXPOSE 8080

# java jdwp port
EXPOSE 17777
VOLUME ["/var/opsgenie/marid/static"]

ENTRYPOINT ["/tini", "--", "./entrypoint.sh"]

