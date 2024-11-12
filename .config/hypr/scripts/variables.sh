# mpv size
mpv_width=681
mpv_height=454

x_offset=-150
y_offset=-100

l_hidden=$(($x_offset-$mpv_width))
r_hidden=$((1920-$x_offset))
# mpv coords
x1_coord=$((1920-$x_offset-$mpv_width))
y1_coord=$y_offset

x2_coord=$x1_coord
y2_coord=$((1080-$y_offset-$mpv_height))

x3_coord=$x_offset
y3_coord=$y1_coord

x4_coord=$x3_coord
y4_coord=$y2_coord

