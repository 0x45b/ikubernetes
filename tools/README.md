# 使用说明

- 配置文件  
  会根据配置文件 `ops.yaml` 进行配置渲染，如果没有该配置文件，则不会进行配置文件渲染。

- 使用方式

  ```bash
  python render_config [<env>]
  ```

  如果没有 `env` ，则 `ops.yaml` 文件也不要定义 `env` 字段。
  只会渲染和在命令行中定义的 `env` 相同的配置到指定目录下。

- 配置文件语法

  ```yaml
  configs:
    - env: test
      type: file
      src: devops/test/config.js
      dst: test_config.js
    - env: test
      type: file
      src: devops/test/config1.js
      dst: test_config1.js
    - env: staging
      type: file
      src: devops/stagingß/config.js
      dst: staging_config.js
    - env: prod
      type: file
      src: devops/production/config.js
      dst: prod_config.js
  ```

  `configs`：定义配置。
  `env`：定义该配所属的环境，需要和 `python render_config [<env>]` 中的 `env` 一致。
  `type`：指定文件类型，可以是 `file` 或 `dir`。
  `src`：指定源文件。
  `dst`：指定渲染后的目标文件。
