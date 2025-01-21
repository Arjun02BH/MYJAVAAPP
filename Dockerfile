# Use an official Tomcat image as a base
FROM tomcat:9.0

# Copy the WAR file into Tomcat's webapps directory
COPY target/my-java-webapp-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/

# Expose the port Tomcat is running on
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
