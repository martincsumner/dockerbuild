FROM openshift/base-centos7
MAINTAINER Jorge Morales <jmorales@redhat.com>

RUN yum install -y --enablerepo=centosplus \
    tar unzip bc which lsof java-1.8.0-openjdk java-1.8.0-openjdk-devel && \
    mkdir -p /opt/openshift && \
    mkdir -p /opt/app-root/source && chmod -R a+rwX /opt/app-root/source && \
    mkdir -p /opt/s2i/destination && chmod -R a+rwX /opt/s2i/destination && \
    mkdir -p /opt/app-root/src && chmod -R a+rwX /opt/app-root/src


LABEL io.k8s.description="Platform for building Spring Boot applications with maven or gradle" \
      io.k8s.display-name="Spring Boot builder 1.0" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,maven-3,gradle-2.6,springboot"

RUN chown -R 1001:1001 /opt/openshift

# This default user is created in the openshift/base-centos7 image
USER 1001

EXPOSE 8080

#RUN curl http://192.168.1.14:8081/nexus/content/repositories/macmartin/org/springframework/ms-spring-boot-docker/0.1.0/ms-spring-boot-docker-0.1.0.jar -o /opt/openshift/app.jar

RUN echo 'checking the path has been passed ${BINARY_PATH}'
RUN curl ${BINARY_PATH} -o /opt/openshift/app.jar


CMD ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/opt/openshift/app.jar"]