% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/wta_odds_match_lookup.R
\name{wta_odds_match_lookup}
\alias{wta_odds_match_lookup}
\title{WTA Match Odds Lookup Table}
\format{A data frame with 27,784 rows and 5 variables}
\description{
This dataset contains the match id and corresponding player and match id from the \code{wta_matches}.
}
\details{
\itemize{
\item id. Character id for the match
\item winner_id. Character id for the winning player as in \code{wta_matches}.
\item loser_id. Character id for the losing player as in \code{wta_matches}.
\item tourney_id. Character id for the tournament as in \code{wta_matches}.
\item match_id. Character id for the match id as in \code{wta_matches}.
}

If \code{match_id} is NA it means a certain match could not be found
}
