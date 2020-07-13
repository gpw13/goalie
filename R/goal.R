#' @noRd
assert_goals <- function(goals, len = length(goals)) {
  valid_goals <- as.character(goals) %in% as.character(1:17)
  if (!all(valid_goals)) {
    stop(sprintf("goals must be only be numeric or character values between 1 and 17, not %s", paste(goals[!valid_goals], collapse = ", ")), call. = FALSE)
  } else if (len != length(goals)) {
    stop(sprintf("goals must be of length %s, not %s", len, length(goals)), call. = FALSE)
  }
}
