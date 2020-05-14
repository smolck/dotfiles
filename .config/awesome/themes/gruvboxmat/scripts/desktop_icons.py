import glob
import os

home_dir = os.getenv('HOME')

local_files = glob.glob(f'{home_dir}/.local/share/applications/*.desktop')
root_files = glob.glob('/usr/share/applications/*.desktop')


for i in root_files:
    with open(i, 'r') as f:
        lines = f.readlines()
        for line in lines:
            if 'Icon=' in line:
                print(line)
                path = line.split('Icon=')[1]
                break

    # print(path)
