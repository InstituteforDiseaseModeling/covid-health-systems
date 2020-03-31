# Add any project specific configuration here.
add.config(
  apply.override = FALSE
)

# Add project specific configuration that can be overridden from load.project()
add.config(
  apply.override = TRUE
)

loc.output <- here::here("output")
loc.logs <- here::here("logs")

# Configure logger
logger.file <- file.path(loc.logs, strftime(Sys.time(), "app_%Y-%m-%d.log"))
logger <-
  logger("DEBUG", appenders = list(
    console_appender(),
    file_appender(file = logger.file, append = T)
  ))
