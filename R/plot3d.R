# Author: Robert J. Hijmans, r.hijmans@gmail.com
# Date :  November 2009
# Version 0.9
# Licence GPL v3

if (!isGeneric("plot3D")) {
	setGeneric("plot3D", function(x,...)
		standardGeneric("plot3D"))
}	


setMethod("plot3D", signature(x='RasterLayer'), 
function(x, maxpixels=100000, zfac=1, drape=NULL, col, rev=FALSE, adjust=TRUE, ...) { 

# much of the below code was taken from example(surface3d) in the rgl package
	if (!require(rgl)){ 
		stop("to use this function you need to install the 'rgl' package") 
	}

	x <- sampleRegular(x, size=maxpixels, asRaster=TRUE)
	X <- xFromCol(x,1:ncol(x))
	Y <- yFromRow(x, nrow(x):1)
	Z <- t((getValues(x, format='matrix'))[nrow(x):1,])

	background <- min(Z, na.rm=TRUE) - 1
	Z[is.na(Z)] <- background

	zlim <- range(Z)
	zlen <- zlim[2] - zlim[1] + 1
	xlen <- max(X) - min(X)
	ylen <- max(Y) - min(Y)
	if (adjust) {
		adj <- 4*zlen/min(ylen,xlen)
		X <- X * adj
		Y <- Y * adj
	} 
	color <- NULL

	
	if (is.null(drape)) {
		if (missing(col)) {
			color <- x@legend@colortable
			if (length(color) < 1) {
				col <- terrain.colors
			}			
		}
		if (length(color) < 1) {
			if (missing(col)) {
				col <- terrain.colors			
			}
			colorlut <- col(zlen) # height color lookup table
			if (rev) { 
				colorlut <- rev(colorlut) 
			}
			color <- colorlut[ Z-zlim[1]+1 ] # assign colors to heights for each point
		}

		Z <- Z * zfac
		open3d()
		if (background==min(Z)) {
			trans <- Z
			trans[] <- 1.0
			trans[Z==background] <- 0
			surface3d(X, Y, Z, color=color, back="lines", alpha=trans, ...)
		} else {
			surface3d(X, Y, Z, color=color, back="lines", ...)
		}
		
	} else {
		x <- sampleRegular(drape, size=maxpixels, asRaster=TRUE)
		Zcol <- t((getValues(x, format='matrix'))[nrow(x):1,])
		background <- min(Zcol, na.rm=TRUE) - 1
		Zcol[is.na(Zcol)] <- background

		zlim <- range(Zcol)
		
		if (missing(col)) {
			color <- drape@legend@colortable
		}
		if ( length(color) < 1 ) {
			if (missing(col)) {
				col <- terrain.colors
			}
			zlen <- zlim[2] - zlim[1] + 1
			colorlut <- col(zlen) # height color lookup table
			if (rev) { 
				colorlut <- rev(colorlut) 
			}
			color <- colorlut[ Zcol-zlim[1]+1 ] # assign colors to heights for each point
		}
		Z <- Z * zfac
		
		open3d()
		if (background==min(Zcol)) {
			trans <- Zcol
			trans[] <- 1.0
			trans[Zcol==background] <- 0
			surface3d(X, Y, Z, color=color, back="lines", alpha=trans, ...)
		} else {
			surface3d(X, Y, Z, color=color, back="lines", ...)
		}
	
	}
}
)
