FROM eclipse-temurin:21-jre

WORKDIR server
Expose 25565

COPY server.jar .
COPY server.properties .
RUN echo "eula=true" > eula.txt

# JVM针对2C6G机器
ENV JVM_OPTS="\
-server \
-Xms512M \
-Xmx5G \
-Xshare:auto \
-XX:+UseTLAB \
-XX:+UseG1GC \
-Duser.language=zh \
-Duser.country=CN \
-Duser.timezone=GMT+8 \
-Dfile.encoding=UTF-8 \
-XX:MaxGCPauseMillis=100 \
-XX:+ParallelRefProcEnabled \
-XX:ParallelGCThreads=1 \
-XX:ConcGCThreads=1 \
-XX:+UnlockExperimentalVMOptions \
-XX:+AlwaysPreTouch \
-XX:+UseCompressedOops \
-XX:G1HeapRegionSize=4M \
-XX:G1ReservePercent=15 \
-XX:G1MixedGCLiveThresholdPercent=90 \
-XX:InitiatingHeapOccupancyPercent=15 \
-XX:G1NewSizePercent=20 \
-XX:G1MaxNewSizePercent=60 \
-XX:SurvivorRatio=8 \
-XX:MaxTenuringThreshold=2 \
-XX:G1MixedGCCountTarget=2 \
-Djava.awt.headless=true \
-XX:CICompilerCount=2 \
-XX:+TieredCompilation \
-XX:TieredStopAtLevel=4 \
-XX:MetaspaceSize=64M \
-XX:MaxMetaspaceSize=128M \
-XX:CompileThreshold=15000 \
-XX:InitialCodeCacheSize=16M \
-XX:ReservedCodeCacheSize=64M \
-Djava.net.preferIPv4Stack=true \
-XX:+UseStringDeduplication" \
    TZ=Asia/Shanghai
RUN ln -sf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone

ENTRYPOINT ["sh", "-c", "java -jar ${JVM_OPTS} server.jar --nogui --eraseCache --forceUpgrade --universe /data/"]
