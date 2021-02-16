# -*- coding: utf-8 -*- 

import re
try:
    import Image, ImageFilter
except ImportError:
    from PIL import Image, ImageFilter, ImageDraw, ImageFont

def has_cyrillic(text): 
	return bool(re.search('[\u0400-\u04FF]', text))

cover_path = "testcover.png"
gradient_path = "gradient3.png"

track_name = u"Тестовый альбом"
artists = [u"test 1", u"тест 2"]
album_name = u"Тестовый альбом"


print(track_name)
print(artists)
print(album_name)

print("Rendering...")

cover = Image.open(cover_path);
cover.thumbnail((1920,3000))

gradient = Image.open(gradient_path);

video_content = Image.new('RGB', (1920, 1080));
video_content.paste(cover, (0,-540))
video_content = video_content.filter(ImageFilter.GaussianBlur(20))

# Вставка и размытие обложки

drawrect = ImageDraw.Draw(video_content, 'RGBA')
drawrect.rectangle (((0, 0), (1920, 1080)), fill=(0, 0, 0, 125))

# Маленькое затемнение экрана

video_content.paste (gradient, (0, 0), gradient)

# Размещение градиента

cover = Image.open(cover_path);
cover.thumbnail((740, 740))

video_content.paste (cover, (105, 105))

# Размещение обложки

font_lb = ImageFont.truetype ("lbold.ttf", 56);
font_lr = ImageFont.truetype ("lreg.ttf", 46);
font_cyr = ImageFont.truetype ("SimSun-01.ttf", 56);

# Инициализация шрифтов

draw = ImageDraw.Draw(video_content)

draw.text(
	(950, 350),
	track_name,
	font=font_lb,
	fill='#FFFFFF'
)

position = 495
pos = 0

for artist in artists:
	if has_cyrillic(artist):
		draw.text(
			(950, position),
			artist,
			font=font_lr,
			fill='#FFFFFF'
		)		
	else:
		draw.text(
			(950, position),
			artist,
			font=font_cyr,
			fill='#FFFFFF'
		)
	
	pos += 1
	position += 55
		
position += 35

if has_cyrillic(album_name):
	draw.text(
		(950, position),
		album_name,
		font=font_lr,
		fill='#FFFFFF'
	)		
else:
	draw.text(
		(950, position),
		album_name,
		font=font_cyr,
		fill='#FFFFFF'
	)
	
# Текст	

video_content.save('video_content.png')
