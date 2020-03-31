# Functions available to all scripts
logger.file <-
  file.path(here::here("logs"), strftime(Sys.time(), "app_%Y-%m-%d.log"))
logger <-
  logger("DEBUG", appenders = list(
    console_appender(),
    file_appender(file = logger.file, append = T)
  ))

logger.info <- function(...) {
  log4r::info(logger = logger, sprintf(...))
}

logger.fatal <- function(...) {
  log4r::fatal(logger = logger, sprintf(...))
}

logger.error <- function(...) {
  log4r::error(logger = logger, sprintf(...))
}

logger.warn <- function(...) {
  log4r::warn(logger = logger, sprintf(...))
}

logger.debug <- function(...) {
  log4r::debug(logger = logger, sprintf(...))
}
