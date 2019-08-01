FROM openjdk:14-jdk

ENV REMCO_VER 0.11.1
ENV MARID_VER 2.15.0
ENV JRUBY_VER 9.2.7.0

RUN wget https://github.com/HeavyHorst/remco/releases/download/v${REMCO_VER}/remco_${REMCO_VER}_linux_amd64.zip && \
	unzip remco_${REMCO_VER}_linux_amd64.zip && rm remco_${REMCO_VER}_linux_amd64.zip && \
	mv remco_linux /bin/remco

RUN curl -O https://s3-us-west-2.amazonaws.com/opsgeniedownloads/repo/opsgenie-marid_${MARID_VER}_all.deb && \
  dpkg -i opsgenie-marid_${MARID_VER}_all.deb && \
  curl -o /var/lib/opsgenie/marid/jruby-complete-${JRUBY_VER}.jar https://s3.amazonaws.com/jruby.org/downloads/${JRUBY_VER}/jruby-complete-${JRUBY_VER}.jar

