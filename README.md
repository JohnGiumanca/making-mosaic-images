# Making Mosaic Images
A program that given an image makes a mosaic using tiny images.

<p align="center">
<img src="https://i.imgur.com/eT3uNpD.jpg" width="280" height="200" style="float: right;">
<img src="https://i.imgur.com/tgncO5D.jpg?1" width="280" height="200" style="float: right;">
<img src="https://i.imgur.com/lME7nRJ.jpg?1" width="280" height="200" style="float: right;">
</p>

## Description
The program will take an image and a set of smaller images and will construct a mosaic of the given image using the smaller ones. The pieces of the mosaic can have different configurations: different neighbours, hexagonal shape, random placement.

The algorithm will move a window the size of a small image from the collection on the initial input image. It will calculate the average color of the cropped image from the window and will choose the best image from the collection(the one with the smallest euclidian distance). The window can be moved on a grid or random untill the mosaic will be complete(or almost complete).

The hexagonal configuration uses the same principle as above, the difference is that it uses a mask of zeros to make the shape of the hexagon and the window will move on a grid so that the hexagons will intertwine. 

## Running the project
The project unfortunately is written in roumanian but it is pretty easy to run and understand, I will walk you through it.

In the 'cod' folder you will find the matlab scripts. The one that you neet to configure and run is "ruleazaProiect.m".

### Configuration
* on line 9 you need to write the path to the input image
```Matlab
params.imgReferinta = imread('../data/imaginiTest/ferrari.jpeg');
```

* on line 13,15,16 and 17 you specify the small image collection path, the type and the size of an image(all images needs to be the same size)
```Matlab
params.numeDirector = '../data/colectie/';
params.tipImagine = 'png';
params.dimPiesaH = 28;
params.dimPiesaW = 40;
```
* on line 21 set the number of pieces on the horizontal axis(the vertical one will be calculated)
```Matlab
params.numarPieseMozaicOrizontala = 100;
```

* on line 26 set 1 for image collection preview
```Matlab
params.afiseazaPieseMozaic = 0;
```

* on line 30 set 'caroiaj' for grid placement of the pieces or 'aleator' for random placement
```Matlab
params.modAranjare = 'caroiaj';
```

* on line 35 set the piece choosing criteria: 
  * 'aleator' for random
  * 'distantaCuloareMedie' for smallest distance between average collors
  * 'distantaCuloareMedieSiVeciniDiferiti' same but different neighbours
  * 'pieseHexagonale' same but hexagonal shape
```Matlab
params.criteriu = 'pieseHexagonale';
```
### Other datasets
You can use the [CIFAR](https://www.cs.toronto.edu/~kriz/cifar.html) dataset to make themtic mosaic images, like a plane made of smaller planes(you get the idea).

## Presentation

<p align="center">
<img src="https://i.imgur.com/lz0YaMy.jpg" width="400" height="280" style="float: right;">
<img src="https://i.imgur.com/S4IBo5v.jpg?1" width="400" height="280" style="float: right;">
<img src="https://i.imgur.com/sSPGEgV.jpg" width="400" height="280" style="float: right;">
<img src="https://i.imgur.com/xZw8BEK.jpg?1" width="400" height="280" style="float: right;">
<img src="https://i.imgur.com/A8Zlfld.jpg" width="400" height="280" style="float: right;">
<img src="https://i.imgur.com/1p2gbWX.jpg" width="400" height="280" style="float: right;">
</p>
