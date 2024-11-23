# mpv size
mpv_width=480
mpv_height=320

x_offset=-90
y_offset=45

l_hidden=$(($x_offset-$mpv_width))
r_hidden=$((1920-$x_offset))
# mpv coords
x1_coord=$((1920-$x_offset-$mpv_width))
y2_coord=$y_offset

x2_coord=$x1_coord
y1_coord=$((1080-$y_offset-$mpv_height))

x3_coord=$x_offset
y3_coord=$y1_coord


x4_coord=$x3_coord
y4_coord=$y2_coord

