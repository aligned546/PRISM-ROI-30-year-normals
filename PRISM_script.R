# ---------------------------
# 1. Load required packages
# ---------------------------
install.packages(c("prism", "raster", "sp"))
library(prism)
library(raster)
library(sp)

# ---------------------------
# 2. Set your PRISM download directory
# ---------------------------
prism_set_dl_dir("./prism_data")

# ---------------------------
# 3. Download 30-year normal monthly precipitation (800m resolution)
# ---------------------------
get_prism_normals(
  type = "ppt",
  resolution = "800m",
  mon = 1:12,
  keepZip = FALSE
)

# ---------------------------
# 4. Load your region of interest shapefile
# ---------------------------
library(sf)
roi <- st_read("ROI.shp")

# ---------------------------
# 5. Find downloaded monthly normals
# ---------------------------
ppt_files <- prism_archive_subset("ppt", "monthly normals", resolution = "800m")

# ---------------------------
# 6. Loop through each month, clip & calculate mean
# ---------------------------
monthly_means <- data.frame(
  Month = 1:12,
  MeanPrecip_mm = NA_real_
)

for (i in 1:12) {
  # Get file path for month i
  pd_name <- ppt_files[i]
  raster_path <- pd_to_file(pd_name)
  
  # Load raster
  ppt_rast <- raster(raster_path)
  
  # Mask to ROI
  ppt_roi <- mask(ppt_rast, roi)
  ppt_roi <- crop(ppt_roi, roi)  # Optional: crop to bbox
  
  # Calculate mean, ignoring NAs
  monthly_mean <- cellStats(ppt_roi, stat = "mean", na.rm = TRUE)
  
  # Save result
  monthly_means$MeanPrecip_mm[i] <- monthly_mean
}

# ---------------------------
# 7. Save to CSV
# ---------------------------
write.csv(
  monthly_means,
  file = "ROI_30yr_monthly_precip.csv",
  row.names = FALSE
)

# ---------------------------
# Done!
# ---------------------------
print("✅ CSV with mean 30-year normal monthly precipitation saved as 'ROI_30yr_monthly_precip.csv'.")
