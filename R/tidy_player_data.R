#' Tidy Player Data
#' 
#' This function tidy's the player's name to by uniform across all imported data
#' 
#' @param data A data table containing player data
#' 
#' @example 
#'  atp_rankings <- tidy_rankings_data(atp_rankings)
#' 
#' @export
#' 
tidy_player_data <- function(data){
	
	names(data) <- c(
	"player_id", 
	"first_name",
	"last_name",
	"hand",
	"birth_date",
	"country_code"
	)
	
	# Blanks
	data <- data[!(data$first_name == "" & data$last_name == ""),]
	
	blank_first <- data$first_name == "" | is.na(data$first_name)
	blank_last <- data$last_name == "" | is.na(data$last_name)
	
	data$invalid <- blank_first | blank_last
	
	# Create full name and date
	data$name <- paste(data$first_name, data$last_name)
	data$dob <- lubridate::ymd(data$birth_date)
	data$hand[data$hand == ""] <- "U"

data
}
