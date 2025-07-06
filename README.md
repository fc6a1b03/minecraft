### 获取`Purpur`文件
1. 获取`Purpur`下载地址
    - 地址为：`https://api.purpurmc.org/v2/purpur/{minecraft.version}/{purpur.version}/download`
    - `minecraft.version`可通过`https://api.purpurmc.org/v2/purpur`地址查询
    - `purpur.version`可通过`https://api.purpurmc.org/v2/purpur/1.21.7`地址查询；当然，也可以直接使用`latest`获取适应`minecraft`的最新`purpur`版本，如：`api.purpurmc.org/v2/purpur/1.21.7/latest`
    - 以上确认之后可在最后补充`/download`，请求后即可获取`Purpur`文件

### 制作Dockerfile
- [Dockerfile](Dockerfile)
- docker build -t minecraft-server .
- docker run -d --restart=unless-stopped -v /data/:/data/ -p 25565:25565 -p 25575:25575 minecraft-server

### 编写server.properties文件
- [properties详解](https://minecraft.fandom.com/zh/wiki/Server.properties)
- [server.properties](server.properties)

### 使用说明
- 世界资源默认读取`/data/`路径，可选择 -v /data/:/data/
- 配置文件`server.properties`放置与server.jar所在的目录中，可选择 -v /server/server.properties:/server/server.properties
- 插件文件默认读取`/server/plugins/`路径，可选择 -v /server/plugins:/server/plugins
  - `PurpurExtras.jar`基础插件会自动添加到plugins中，配置挂载也不会影响。
- 模组配置文件默认读取`/server/config/`，可选择 -v /server/config:/server/config
- 端口都按官方默认
  - server-port=25565，可选择 -p 25565:25565
  - rcon.port=25575，可选择 -p 25575:25575
- RCON远程访问密码，每次构建镜像都会生成一个随机的 30 位大小写字母和数字组合的密码，基于`tr -dc 'A-Za-z0-9'`
  - 可选择
    1. 通过自有配置覆盖来修改密码
    2. 通过`docker exec -it minecraft-server cat /server/server.properties`查询密码
