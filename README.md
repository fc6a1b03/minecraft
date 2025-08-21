这个分支将会使用[Modpacks](https://modrinth.com/modpack)作为构建核心

> 镜像规范：ghcr.io/fc6a1b03/{{ NORMALIZED_NAME }}:{{ MOD_LOADERS }}-{{ MODPACK_VERSION }}-{{ GAME_VERSION }}

### 制作Dockerfile
- [Dockerfile](Dockerfile)
- docker build -t minecraft-server-fabric .
- docker run -d --restart=unless-stopped -v /data/:/data/ -v /server/mods:/server/mods -p 25565:25565 -p 25575:25575 minecraft-server-fabric

### 编写server.properties文件
- [properties详解](https://minecraft.fandom.com/zh/wiki/Server.properties)
- [server.properties](server.properties)

### 使用说明
- 世界资源默认读取`/data/`路径，可选择 -v /data/:/data/
- 配置文件`server.properties`放置与server.jar所在的目录中，可选择 -v /server/server.properties:/server/server.properties
- 模组文件默认读取`/server/mods/`路径，可选择 -v /server/mods:/server/mods
  - `fabric-api.jar`基础模组会自动添加到mods中，配置挂载也不会影响。
- 模组配置文件默认读取`/server/config/`，可选择 -v /server/config:/server/config
- 端口都按官方默认
  - server-port=25565，可选择 -p 25565:25565
  - rcon.port=25575，可选择 -p 25575:25575
- RCON远程访问密码，每次构建镜像都会生成一个随机的 30 位大小写字母和数字组合的密码，基于`tr -dc 'A-Za-z0-9'`
  - 可选择
    1. 通过自有配置覆盖来修改密码
    2. 通过`docker exec -it minecraft-server-fabric cat /server/server.properties`查询密码

### 默认模组

### 补充信息
- [客户端启动器](https://ci.huangyuhui.net/job/HMCL/)
- [客户端整合基础包](https://www.curseforge.com/minecraft/modpacks/fabulously-optimized)
- [NectarRCON](https://github.com/zkhssb/NectarRCON)
- [docker-image.yml](.github/workflows/docker-image.yml)可自动完成镜像上传过程