import os
import shutil
import sys
from pathlib import Path

import yaml

filename = r'ops.yaml'
types = ('file', 'dir')
render_env = '' if len(sys.argv) != 2 else sys.argv[1].lower()

# 判断是否需要渲染配置文件
if not os.path.isfile(filename):
    sys.exit(0)

with open(filename) as f:
    try:
        loader = yaml.load(f, Loader=yaml.FullLoader)
    except:
        print('config: {} syntax error'.format(filename))
        sys.exit(1)

if 'configs' not in loader:
    print('invalid config')
    sys.exit(1)

configs = loader['configs']
if len(configs) == 0:
    sys.exit(0)

for config in configs:
    config_env = config.get('env', '')
    config_type = config['type'].lower()
    src, dst = config['src'], config['dst']

    if render_env != config_env:
        continue

    if config_type not in types:
        print('type: {} is invalid, only support: [file, dir]'.format(
            config_type))
        sys.exit(1)

    # 配置存在项目目录，不允许在根目录
    if dst.startswith('/'):
        dst = '.' + dst

    if config_type == 'file':
        if not os.path.isfile(src):
            print('file: {} is not exist'.format(src))
            sys.exit(1)
        if '/' in dst:
            Path(dst).parent.mkdir(parents=True, exist_ok=True)
        shutil.copy(src, dst)
    else:
        if not os.path.isdir(src):
            print('directory: {} is not exist'.format(src))
            sys.exit(1)
        shutil.copytree(src, dst, dirs_exist_ok=True)
