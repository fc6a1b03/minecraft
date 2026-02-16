这个分支将会使用[Folia](https://github.com/PaperMC/Folia)作为服务端

> Folia 是 Paper 的分支，专为高性能服务器设计，采用区域化多线程架构。

### 获取`Folia`文件

Folia 通过 PaperMC API 分发：

1. **获取 Folia 可用版本列表**
    - `https://fill.papermc.io/v3/projects/folia`
2. **获取指定版本的构建列表**
    - `https://fill.papermc.io/v3/projects/folia/versions/{version}`
3. **获取指定构建的下载信息**
    - `https://fill.papermc.io/v3/projects/folia/versions/{version}/builds/{build}`
    - 返回 JSON 中包含 `$.downloads["server:default"].url` 字段，即为直接下载地址

完整示例：`https://fill-data.papermc.io/v1/objects/xxxxx/folia-1.21.11-13.jar`

### 制作Dockerfile

- [Dockerfile](Dockerfile)
- `docker build -t minecraft-folia .`
- `docker run -d --restart=unless-stopped -v /data/:/data/ -p 25565:25565 -p 25575:25575 minecraft-folia`

### 编写server.properties文件

- [properties详解](https://minecraft.fandom.com/zh/wiki/Server.properties)
- [server.properties](server.properties)

### 使用说明

- 世界资源默认读取`/data/`路径，可选择 `-v /data/:/data/`
- 配置文件`server.properties`放置与 server.jar 所在的目录中，可选择
  `-v /server/server.properties:/server/server.properties`
- 插件文件默认读取`/server/plugins/`路径，可选择 `-v /server/plugins:/server/plugins`
- 配置文件默认读取`/server/config/`，可选择 `-v /server/config:/server/config`
- 端口都按官方默认
    - server-port=25565，可选择 `-p 25565:25565`
    - rcon.port=25575，可选择 `-p 25575:25575`
- RCON远程访问密码，每次构建镜像都会生成一个随机的 32 位大小写字母和数字组合的密码
    - 可选择
        1. 通过自有配置覆盖来修改密码
        2. 通过`docker exec -it minecraft-folia cat /server/server.properties`查询密码

### 注意事项

- Folia 采用区域化多线程架构
- 文档地址：https://docs.papermc.io/folia
