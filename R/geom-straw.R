#' Angled line segments between x-axis values
#'
#' \code{geom_straw} draws a sloping line between points (x, y) and
#' (xend, y), where y is an arbitrary height above x and below xend.  If x
#' equals xend then the line is vertical.
#'
#' This is useful for visualising the difference in time between two events
#' related to one object, e.g. scheduled and actual arrival.
#'
#' @section Aesthetics:
#' \aesthetics{geom}{segment}
#'
#' @inheritParams ggplot2::geom_segment
#' @seealso \code{\link{geom_segment}}, from which \code{geom_straw} inherits.
#' @export
#' @examples
#' # Plot a subset of the nycflights13 data
#' library(ggplot2)
#' ggplot(ggstraw::flights_example,
#'          aes(sched_dep_time, carrier, xend = dep_time, colour = late)) +
#'   geom_straw() +
#'   scale_colour_manual("Late", values = c("black", "red")) +
#'   xlab("") +
#'   ylab("Carrier") +
#'   ggtitle("Departure times from New York to Boston", sub = "Scheduled vs actual") +
#'   theme_minimal() +
#'   theme(panel.grid = element_blank())
geom_straw <- function(mapping = NULL, data = NULL, stat = "identity",
                        position = "identity", na.rm = FALSE, show.legend = NA,
                        inherit.aes = TRUE, ...) {
  layer(
    geom = GeomStraw, mapping = mapping, data = data, stat = stat,
    position = position, show.legend = show.legend, inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, ...)
  )
}

GeomStraw <- ggplot2::ggproto("GeomStraw", ggplot2::GeomSegment,
  required_aes = c("x", "y", "xend"),
  setup_data = function(data, params) {
    data$height <- data$height %||%
      params$height %||% (resolution(data$y, FALSE) * 0.5)
    transform(data,
      y = y - height / 2, yend = y + height / 2, height = NULL
    )
  }
)

"%||%" <- function(a, b) {
  if (!is.null(a)) a else b
}
