FROM eclipse-temurin:25 as builder
WORKDIR server

COPY purpur-server.jar purpur-server.jar
RUN mkdir -p /temp/cache && java -jar purpur-server.jar --nogui --universe /temp/cache/

################################

FROM eclipse-temurin:25-jre
WORKDIR server
Expose 25565

COPY --from=builder server .
RUN rm -rf server.properties eula.txt logs/*
COPY server.properties .
COPY PurpurExtras*.jar /public/
RUN echo "eula=true" > eula.txt

# JVM针对2C6G机器
ENV JVM_OPTS="\
-server \
-Xms1G \
-Xmx6G \
-XX:+UseG1GC \
-XX:MaxGCPauseMillis=50 \
-XX:+ParallelRefProcEnabled \
-XX:ParallelGCThreads=1 \
-XX:ConcGCThreads=1 \
-XX:+AlwaysPreTouch \
-XX:+UseCompressedOops \
-XX:G1ReservePercent=15 \
-XX:G1MixedGCLiveThresholdPercent=85 \
-XX:InitiatingHeapOccupancyPercent=30 \
-XX:G1NewSizePercent=35 \
-XX:G1MaxNewSizePercent=45 \
-XX:MaxTenuringThreshold=1 \
-XX:G1MixedGCCountTarget=8 \
-XX:+DisableExplicitGC \
-XX:CICompilerCount=1 \
-XX:+TieredCompilation \
-XX:TieredStopAtLevel=4 \
-XX:MetaspaceSize=128M \
-XX:MaxMetaspaceSize=256M \
-XX:ReservedCodeCacheSize=128M \
-XX:+UseStringDeduplication \
-XX:+UnlockExperimentalVMOptions \
-XX:+G1UseAdaptiveIHOP \
-Djava.awt.headless=true \
-Dfile.encoding=UTF-8 \
-Djava.net.preferIPv4Stack=true" \
    TZ=Asia/Shanghai
RUN ln -sf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone

ENTRYPOINT ["sh", "-c", "cp -r /public/* plugins/ && java -jar ${JVM_OPTS} purpur-server.jar --nogui --eraseCache --forceUpgrade --universe /data/"]
