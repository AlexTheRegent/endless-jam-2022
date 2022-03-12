import fileinput
import re

for line in fileinput.input('prefabs/ship.tscn', inplace=True):
    if line.startswith('region_rect = Rect2'):
        r = re.search('region_rect = Rect2\( (\d+), (\d+), (\d+), (\d+) \)', line)
        x = int(r.group(1))
        y = int(r.group(2))
        w = int(r.group(3))
        h = int(r.group(4))

        line = f'region_rect = Rect2( {x - 1}, {y - 1}, {w + 2}, {h + 2} )'

    print(line, end='')

# with open('prefabs/ship.tscn') as file:
#     for line in file.readlines():
#         if line.startswith('region_rect = Rect2'):
#             r = re.search('region_rect = Rect2\( (\d+), (\d+), (\d+), (\d+) \)', line)
#             x = int(r.group(1))
#             y = int(r.group(2))
#             w = int(r.group(3))
#             h = int(r.group(4))

#             print(f'region_rect = Rect2( ({x - 1}), ({y - 1}), ({w - 2}), ({h - 2}) )')
