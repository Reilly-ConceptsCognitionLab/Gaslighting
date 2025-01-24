#' estimateGaslight
#'
#' Computes cosine distance from each input text to the base gaslighting vector
#'
#' @name estimateGaslight
#' @param textData a text data frame meeting format requirements
#' @return a table of cosine distances one for every document
#' @importFrom Lex2Emo transformText
#' @imoprtFrom dplyr select
#' @importFrom magrittr %>%
#' @importFrom dplyr group_by
#' @importFrom dplyr mutate
#' @importFrom dplyr ungroup
#' @importFrom dplyr summarize
#' @importFrom tidyr pivot_longer
#' @importFrom dplyr filter
#' @importFrom lsa cosine
#' @export


estimateGaslight <- function(textData) {
  #cosine dist each document vs basevector
  #load("lookup/basevec22.rda")
  #load("lookup/gaslightTrainDist.rda")

  transformedText <- Lex2Emo::transformText(textData)

  #textData$ID <- as.factor(x$ID)
  #dataframe should not contain basevec
  z <- textData %>%
    dplyr::group_by(ID) %>%
    dplyr::summarize(cos_sim = lsa::cosine(gaslightBasevector$Mean_EmoSalience, Mean_EmoSalience)) %>%
    ungroup()
  #convert cosine similarity to cosine distance using 1-observed cosine similarity
  z <- z %>%
    dplyr::group_by(ID) %>%
    mutate(cos_dist = 1-cos_sim) %>%
    ungroup()
  # compute mean and sd of cosine distances
  m_dist <- mean(gaslightTrainDist$cos_dist)
  sd_dist <- sd(gaslightTrainDist$cos_dist)
  z <- z %>% #z-score one-sided distance from zero (perfect gaslighting)
    dplyr::mutate(z_cos_dist = (cos_dist-mean(gaslightTrainDist$cos_dist))/sd(gaslightTrainDist$cos_dist),
           p_gas = pnorm(z_cos_dist, mean=0, sd=1, lower.tail = F),
           p_Gaslight = round(p_gas, digits = 6)) %>%
    dplyr::select(!p_gas) %>%
    dplyr::mutate(Is_It_Gaslighting =
                    ifelse(p_Gaslight<=.05, 'Unlikely',
                           ifelse(p_Gaslight >.05 &  p_Gaslight <=.15, "Weak",
                                  ifelse(p_Gaslight >.15 &  p_Gaslight <=.50, "Moderate",
                                         ifelse(p_Gaslight >.50 &  p_Gaslight <=.80, "Probably",
                                                'Highly Likely')))))

  return(z)
}
