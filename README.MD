# cell

操作表格的DSL。

## 快速开始

### 下载依赖
```shell
go mod tidy
```

### 根据g4生成代码

将 `LocalBase` 设置为项目跟目录。可以修改项目下 `run-gen.sh` 目录直接执行。

> 为 `run-gen.sh` 脚本文件赋予可执行权限: `chmod u+x gen.sh`

```shell
LocalBase="/Users/apple/WorkSpace/self/code/golang/cell"
LocalG4="${LocalBase}/cell/antlr"
LocalGen="${LocalBase}/gen"
docker run --rm -v ${LocalG4}:/data -v ${LocalGen}:/gen -it cqlwm/antlr4 -Dlanguage=Go /data/Cell.g4 -o /gen
```

## 常用命令

### 清理gen文件夹

```shell
rm -f gen/*
```

