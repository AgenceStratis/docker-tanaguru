FROM tomcat:7
MAINTAINER Romain Moreau <moreau.romain83@gmail.com>

USER root

RUN apt-get update -qq 

#Install Tools needed for further installations steps
RUN apt-get -yqq install debconf-utils
RUN apt-get -yqq install wget   #To dl firefox
RUN apt-get -yqq install bzip2  #To unarchive firefox.tar.bz2
RUN apt-get -yqq install git 	#To dl source code of tanaguru
RUN apt-get -yqq install openjdk-7-jdk #To compile sources of tanaguru
RUN apt-get -yqq install maven 	#To compile sources of tanaguru


#Install MySQL
RUN echo 'mysql-server mysql-server/root_password password tanaguru'|debconf-set-selections 
RUN echo 'mysql-server mysql-server/root_password_again password tanaguru'|debconf-set-selections
RUN apt-get -yqq install mysql-server mysql-client
RUN sed "s/max_allowed_packet = 16M/max_allowed_packet = 64M/g" /etc/mysql/my.cnf

WORKDIR /home/root
ADD requests.sql sql/
RUN service mysql start &&  mysql -uroot -ptanaguru < sql/requests.sql

#Install JAVA Dependecies and link them to good directory
RUN apt-get install -yqq libspring-instrument-java
RUN ln -s /usr/share/java/spring3-instrument-tomcat.jar /usr/local/tomcat/bin/spring3-instrument-tomcat.jar
RUN ln -s /usr/share/java/mysql-connector-java.jar /usr/local/tomcat/bin/mysql-connector-java.jar

#Install & Configure xvfb
RUN apt-get -yqq install xvfb
ADD xvfb /etc/init.d/
RUN chmod +x /etc/init.d/xvfb
RUN /etc/init.d/xvfb start
RUN update-rc.d xvfb defaults

#Install Firefox
WORKDIR /opt
RUN wget -q http://download.cdn.mozilla.net/pub/mozilla.org/firefox/releases/31.4.0esr/linux-i686/en-US/firefox-31.4.0esr.tar.bz2
RUN tar xvfj firefox-31.4.0esr.tar.bz2
RUN mv firefox firefox-31.4.0esr
RUN ln -s firefox-31.4.0esr firefox


#Compile Tanaguru
WORKDIR /home/root/
RUN git clone https://github.com/Tanaguru/Tanaguru.git
WORKDIR Tanaguru
RUN mvn clean install -DskipTests=true
WORKDIR /home/root
RUN mv Tanaguru/cli/tanaguru-cli/target/tanaguru-*.tar.gz .
RUN tar xzf *.tar.gz 
RUN mv tanaguru*/ ./tanaguru/ 

#Install Tanaguru
WORKDIR tanaguru
RUN service mysql start && echo "yes\n" | ./install.sh --mysql-tg-db tanaguru_db \ 
				 --mysql-tg-user tanaguru \
				 --mysql-tg-passwd tanaguru \
				 --tanaguru-url http://localhost:8080/tanaguru/ \
				 --tomcat-webapps /var/lib/tomcat7/webapps \
				 --tomcat-user root \
				 --tg-admin-email tanaguru@email.com \
				 --tg-admin-passwd tanaguru \
				 --firefox-esr-path /opt/firefox/firefox \
				 --display-port :99 

EXPOSE 8080				 
