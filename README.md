# PRISM 30-Year Normal Monthly Precipitation

These scripts download 30-year normal monthly precipitation data (800 m) from PRISM, clips to a region of interest (ROI), and outputs a CSV with the mean precipitation for each month. "upsampled-raster-clip" upsamples the PRISM files to 80m resolution and then clips them more accurately to the ROI, outputting both a csv with partial pixel weighted means (most accurate) and 12 different 80m resolution geotiffs for each month. It has more requirements. 

## Requirements

- R  
- R packages: `prism`, `raster`, `sp`, `sf`
- Your shapefile (`ROI.shp` and associated files) in the project folder.  
- For "upsampled-raster-clip"
  - GDAL
  - R packages: `sf`, `exactextractr`
