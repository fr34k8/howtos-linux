# How to merge pdf's using Imagemagick

If you have .png or .jpg scanned pages:

	convert -quality 90 *.png page_%02d.jpg
	convert *.jpg final.pdf
