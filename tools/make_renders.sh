#!/bin/sh
# Re-render the website pictures into ../images from the housing model (macOS).
# Expects the class repository at ~/class-board-2026 (set CB to change it).
O="${OPENSCAD:-/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD}"
CB="${CB:-$HOME/class-board-2026}"
H="$CB/docs/students/lihdong/housing/housing.scad"
cd "$(dirname "$0")"
"$O" -o ../images/assembled.png --imgsize=1600,1000 --viewall --autocenter --camera=0,0,0,55,0,25,0 -D ghost=false "$H"
"$O" -o ../images/exploded.png  --imgsize=1600,1100 --viewall --autocenter --camera=0,0,0,62,0,28,0 -D ghost=false -D explode=40 "$H"
"$O" -o ../images/top.png       --imgsize=1600,1000 --viewall --autocenter --projection=o --camera=0,0,0,0,0,0,0 -D ghost=false "$H"
"$O" -o ../images/rear.png      --imgsize=1600,800  --camera=125,-10,-5,78,0,200,190 -D ghost=false "$H"
"$O" -o ../images/plate.png     --imgsize=1400,1200 --viewall --autocenter --camera=0,0,0,40,0,20,0 -D 'part="plate"' "$H"
"$O" -o ../images/coupon.png    --imgsize=1000,600  --viewall --autocenter --camera=0,0,0,50,0,30,0 -D 'part="coupon"' "$H"
mkdir -p frames
for i in $(seq 0 23); do
  "$O" -o "frames/f$(printf %02d $i).png" --imgsize=800,520 --viewall --autocenter --camera=0,0,0,58,0,$(( i*15 + 25 )),0 -D ghost=false "$H" &
  [ $(( i % 6 )) -eq 5 ] && wait
done
wait
python3 make_gif.py frames ../images/turntable.gif && rm -rf frames
