# Base image olarak OpenJDK 8 kullanıyoruz
FROM openjdk:8-jdk

# GlassFish sunucusunun 4.1.1 sürümünü indiriyoruz
ENV GLASSFISH_VERSION 4.1.1
ENV GLASSFISH_HOME /glassfish

RUN wget http://download.oracle.com/glassfish/4.1.1/release/glassfish-${GLASSFISH_VERSION}.zip \
    && unzip glassfish-${GLASSFISH_VERSION}.zip -d / \
    && mv /glassfish4 ${GLASSFISH_HOME} \
    && rm glassfish-${GLASSFISH_VERSION}.zip

# Proje dosyalarını container'a kopyalıyoruz
COPY . /usr/src/app

# Proje dizinine gidiyoruz
WORKDIR /usr/src/app

# WAR dosyasını manuel olarak oluşturuyoruz
RUN jar cvf HelloWeb.war .

# Oluşturduğumuz WAR dosyasını GlassFish autodeploy dizinine kopyalıyoruz
RUN cp HelloWeb.war ${GLASSFISH_HOME}/glassfish/domains/domain1/autodeploy/

# GlassFish'in HTTP portunu açıyoruz
EXPOSE 8080 4848

# GlassFish sunucusunu başlatıyoruz
CMD ["sh", "-c", "${GLASSFISH_HOME}/bin/asadmin start-domain -v"]
