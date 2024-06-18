How to use diffusion.mlapp
==========================

## 1. clone the repo to your device

This can be done via the download button at the root repo directory. The host machine must have MATLAB with the addons: curve fitting toolbox, image processing toolbox,
and signal processing toolbox.

## 2. double click the .mlapp file

It's the one named diffusion. MATLAB will open. this is supposed to happen. The app window will take sevral seconds to open.

## 3. load your images
Press the load images button and select the images you will be using.

## 4. set save location
the set save location will allow you to set a folder in which all saved files will be saved.

## 5. extract the linear fit
select the image of the linear referance line and go to settings. in 'settings' select crop, and then then draw a rectangle around the wanted area by dragging the
mouse on the image, then press 'finish' to complete the cropping . If The image is still noisy, you may return to the 'control' tab and change the threshold or use
the mask tool. Changing the other values in the settings tab is not recomended. Finally, in 'control', press the 'extract data' button, and then in settings 
press the 'extract linear fit' button. The slope should appear in the m edit field on the left.

## 6. insert data values
in order to prpcess the data you will need to insert the parameters into the program.

A - distance from laser lens to diffusion cell.

B - distance from diffusion cell to screen.

w - width of the diffusion cell.

Err - length mesurement error

conv - cm/px conversion ratio. For best results do a calibration graph.

convErr - error of conversion ratio.

## 7. extracting raw data

Select an image to process. If the is noise, adjust with threshold or mask. If part of the curve is out of frame,
use the cropping tool in 'settings' to change the frame size. If you want to retain this info, press 'save data'.
what will be saved is the points you saw in the results graph as a \_raw.txt file.

## 8. processing data

Click 'process Data'. an Rsqure will appear at the bottom of the window, so you can guage the quality of your results. If you are satisfied
press the 'save data' button. it will be saved as a \_processed.txt file.

## 9. extract graphs.

### This will only work if you have not changed the image file names at all

press the 'final graphs' button. The process may take up to thirty seconds. A graph of all the processed data will appear, along with a linear regression
of the sigma values. An .xlsx file with the fit perameters of all the processed fits will appear in the save location.

## 10. start new data set

press clear to reset the program.
