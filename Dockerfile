FROM eclipse-temurin:25 as builder
WORKDIR /server

COPY folia-server.jar folia-server.jar
RUN mkdir -p /temp/cache && java -jar folia-server.jar --nogui --universe /temp/cache/

################################

FROM eclipse-temurin:25-jre
WORKDIR /server
EXPOSE 25565

COPY --from=builder server .
RUN rm -rf server.properties eula.txt logs/*
COPY server.properties .
RUN echo "eula=true" > eula.txt

ENV JVM_OPTS="\
-server \
-Xms1G \
-Xmx6G \
-XX:+UseShenandoahGC \
-XX:+AlwaysPreTouch \
-XX:+DisableExplicitGC \
-XX:+ParallelRefProcEnabled \
-XX:+UseStringDeduplication \
-XX:+UseLargePages \
-XX:LargePageSizeInBytes=2M \
-XX:MetaspaceSize=256M \
-XX:MaxMetaspaceSize=512M \
-XX:ReservedCodeCacheSize=256M \
-XX:+OptimizeStringConcat \
-XX:+UseCompressedOops \
-XX:+UseNUMA \
-Djava.awt.headless=true \
-Dfile.encoding=UTF-8 \
-Djava.net.preferIPv4Stack=true \
-Dpaper.settings.async-chunks=true \
-Dpaper.settings.async-entities=true" \
    TZ=Asia/Shanghai
RUN ln -sf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone

ENTRYPOINT ["sh", "-c", "exec java ${JVM_OPTS} -jar folia-server.jar --nogui --universe /data/"]
