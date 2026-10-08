# make_gif.py FRAMES_DIR OUT.gif - join the turntable frames into a looping GIF (needs Pillow)
import glob, sys
from PIL import Image
frames = [Image.open(f).convert("P", palette=Image.ADAPTIVE, colors=128)
          for f in sorted(glob.glob(sys.argv[1] + "/f*.png"))]
frames[0].save(sys.argv[2], save_all=True, append_images=frames[1:], duration=160, loop=0, optimize=True)
print(len(frames), "frames ->", sys.argv[2])
