\name{vectorplot-methods}
\docType{methods}

\alias{vectorplot}
\alias{vectorplot,Raster-method}
\alias{streamplot}
\alias{streamplot,Raster-method}
\alias{streamplot,RasterStack-method}

\title{Vector plots of Raster objects.}
\description{

  \code{vectorplot} displays vector fields from Raster
  objects using arrows.

  \code{streamplot} displays streamlines with a procedure inspired by
  the FROLIC algorithm (see references): for each point (\emph{droplet})
  of a jittered regular grid, a short streamline portion
  (\emph{streamlet}) is calculated by integrating the underlying vector
  field at that point. The main color of each streamlet indicates local
  vector magnitude (\emph{slope}). Streamlets are composed of points
  whose sizes, positions and color degradation encode the local vector
  direction (\emph{aspect}).  }

\usage{
\S4method{vectorplot}{Raster}(object, layers,
            narrows=2e3, lwd.arrows=0.6, length=unit(5e-2, 'npc'),
            maxpixels=1e5, region=TRUE,  
            isField=FALSE, reverse=FALSE, unit='radians', ...)

\S4method{streamplot}{Raster}(object, layers,
            droplet = list(), streamlet = list(),
            par.settings=streamTheme(),
            isField = FALSE, reverse=FALSE, 
            parallel=TRUE, mc.cores=detectCores(), cl=NULL,
            ...)

\S4method{streamplot}{RasterStack}(object, layers,
            droplet = list(), streamlet = list(),
            par.settings=streamTheme(),
            isField = FALSE, reverse=FALSE, 
            parallel=TRUE, mc.cores=detectCores(), cl=NULL,
            ...)
}

\arguments{
  \item{object}{A Raster object. If \code{isField=FALSE} the vector
  field is calculated internally from the result of
  \code{\link{terrain}}. }
  \item{layers}{A numeric or character which should indicate the layers
    to be displayed.}
  \item{maxpixels}{A numeric, number of cells to be shown if
  \code{region=TRUE}.}
\item{narrows}{A numeric, number of arrows.}
  \item{lwd.arrows}{Numeric, width of the lines of the arrows}
  \item{length}{Unit, extent of the arrow head.}

\item{droplet}{A list whose elements define the droplet
  configuration:\itemize{ \item{cropExtent: Percentage of the object
  extent to be cropped (default .97) to avoid droplets at boundaries}
  \item{pc: Percentage of cells to be used for the streamlets
  calculation (default .5)}}}

\item{streamlet}{A list whose elements define the streamlet
  configuration:\itemize{ \item{L: length of the streamlet (number of
      points, default 10)}
    \item{h: streamlet calculation step (default \code{mean(res(object))}).}}}

\item{par.settings}{A list to define the graphical parameters. For
  \code{streamplot} there is an specific theme, \code{streamTheme}.}

\item{parallel}{Logical, TRUE (default) to use \code{\link{parallel}}
  package.}
\item{cl}{a cluster object. Read the help page of
  \code{\link{parLapply}} for details.}
\item{mc.cores}{The number of cores to use if \code{parallel=TRUE} and
  no \code{cl} is provided. Read the help page of \code{\link{mclapply}}
  for details.}
  \item{region}{Logical, if \code{TRUE} the region is displayed with
  \code{vectorplot} using \code{panel.levelplot.raster}}
\item{reverse}{Logical, TRUE if arrows or streamlets go against the direction
  of the gradient.}
  \item{isField}{Logical, if \code{TRUE} (the object is a vector field),
  \code{object} must be a Raster*
  with two layers, slope and aspect (in this order), following the
  philosophy of \code{\link{terrain}}.}
\item{unit}{Character, angle units of the \code{aspect} layer if
  \code{isField=TRUE}: 'radians' or 'degrees'.}
  \item{\dots}{Additional arguments for \code{\link{levelplot}}}
}

\references{
    R. Wegenkittl and E. Gröller, Fast Oriented Line Integral Convolution for Vector Field
     Visualization via the Internet, Proceedings IEEE Visualization ’97, 1997, \url{http://www.cg.tuwien.ac.at/research/vis-dyn-syst/frolic/frolic_crc.pdf}
  }
  
\author{Oscar Perpiñán Lamigueiro}

\seealso{\code{\link{panel.arrows}},
  \code{\link{levelplot}},
  \code{\link{terrain}},
  \code{\link{mclapply}},
  \code{\link{parLapply}}
}

\examples{
\dontrun{
proj <- CRS('+proj=longlat +datum=WGS84')

df <- expand.grid(x=seq(-2, 2, .01), y=seq(-2, 2, .01))
df$z <- with(df, (3*x^2 + y)*exp(-x^2-y^2))
r1 <- rasterFromXYZ(df, crs=proj)
df$z <- with(df, x*exp(-x^2-y^2))
r2 <- rasterFromXYZ(df, crs=proj)
df$z <- with(df, y*exp(-x^2-y^2))
r3 <- rasterFromXYZ(df, crs=proj)
s <- stack(r1, r2, r3)
names(s) <- c('R1', 'R2', 'R3')

vectorplot(r1)
vectorplot(r2, par.settings=RdBuTheme())
vectorplot(r3, par.settings=PuOrTheme())


## If no cluster is provided, streamplot uses parallel::mclapply except
## with Windows. Therefore, next code could spend a long time under
## Windows.
streamplot(r1)

## With a cluster
hosts <- rep('localhost', 4)
cl <- makeCluster(hosts)
streamplot(r2, cl=cl,
           par.settings=streamTheme(symbol=brewer.pal(n=5,
                                                      name='Reds')))
stopCluster(cl)

## Without parallel
streamplot(r3, parallel=FALSE,
           par.settings=streamTheme(symbol=brewer.pal(n=5,
                                                      name='Greens')))

## Configuration of droplets and streamlets
streamplot(s, layout=c(1, 3), droplet=list(pc=.2), streamlet=list(L=20),
           par.settings=streamTheme(cex=.6))
}

}

\keyword{methods}
\keyword{spatial}