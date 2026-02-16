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

# JVM 配置说明：
# - 基于 Folia 官方推荐的 JVM 参数 (https://fill.papermc.io/v3/projects/folia/versions/{version})
# - 针对 2C6G 机器优化：总内存 6G，分配 4G 给堆内存，保留 2G 给系统和元空间
# - 使用 G1GC (官方推荐)
ENV JVM_OPTS="\
-server \
-Xms4G \
-Xmx4G \
-XX:+UseG1GC \
-XX:ParallelGCThreads=2 \
-XX:ConcGCThreads=1 \
-XX:+UseDynamicNumberOfGCThreads \
-XX:+AlwaysPreTouch \
-XX:+DisableExplicitGC \
-XX:+ParallelRefProcEnabled \
-XX:+PerfDisableSharedMem \
-XX:+UnlockExperimentalVMOptions \
-XX:G1HeapRegionSize=8M \
-XX:G1HeapWastePercent=5 \
-XX:G1MaxNewSizePercent=40 \
-XX:G1MixedGCCountTarget=4 \
-XX:G1MixedGCLiveThresholdPercent=90 \
-XX:G1NewSizePercent=30 \
-XX:G1RSetUpdatingPauseTimePercent=5 \
-XX:G1ReservePercent=20 \
-XX:InitiatingHeapOccupancyPercent=15 \
-XX:MaxGCPauseMillis=200 \
-XX:MaxTenuringThreshold=1 \
-XX:SurvivorRatio=32 \
-XX:+UseStringDeduplication \
-XX:StringDeduplicationAgeThreshold=1 \
-XX:MetaspaceSize=256M \
-XX:MaxMetaspaceSize=512M \
-XX:ReservedCodeCacheSize=256M \
-XX:+UseLargePages \
-XX:LargePageSizeInBytes=2M \
-XX:+UseTransparentHugePages \
-XX:+OptimizeStringConcat \
-XX:+UseCompressedOops \
-XX:+UseNUMA \
-XX:+UseVectorApi \
-Djava.awt.headless=true \
-Dfile.encoding=UTF-8 \
-Djava.net.preferIPv4Stack=true \
-Dpaper.settings.async-chunks=true \
-Dpaper.settings.async-entities=true \
-Djdk.incubator.vector.VECTOR_ACCESS_OOB_CHECK=0" \
    TZ=Asia/Shanghai
RUN ln -sf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone

ENTRYPOINT ["sh", "-c", "exec java ${JVM_OPTS} -jar folia-server.jar --nogui --universe /data/"]
