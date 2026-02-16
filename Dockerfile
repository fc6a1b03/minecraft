FROM eclipse-temurin:25 as builder
WORKDIR /server

COPY folia-server.jar folia-server.jar
RUN mkdir -p /temp/cache && java -jar folia-server.jar --nogui --universe /temp/cache/ || true

################################

FROM eclipse-temurin:25-jre
WORKDIR /server
EXPOSE 25565

COPY --from=builder /server/folia-server.jar .
RUN rm -rf server.properties eula.txt logs/* 2>/dev/null || true
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
-Djava.awt.headless=true \
-Dfile.encoding=UTF-8 \
-Djava.net.preferIPv4Stack=true" \
    TZ=Asia/Shanghai

RUN ln -sf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone

RUN mkdir -p /server/plugins /server/config /data

ENTRYPOINT ["sh", "-c", "java ${JVM_OPTS} -jar folia-server.jar --nogui --eraseCache --forceUpgrade --universe /data/"]
