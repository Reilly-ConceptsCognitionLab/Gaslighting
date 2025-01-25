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

  # clean and transform using call to dependency
  cleanText <- Lex2Emo::transformText(textData)
  # replace column name with match for pre-computed data
  colnames(cleanText)[colnames(cleanText) == "Factor_Score"] <- "Mean_EmoSalience"

  #cosine dist each document vs basevector
  load(r"(C:\Users\bensa\OneDrive - Temple University\Ben R\Gaslight_Total\Gaslight_development\lookup_data\basevec22.rda)")
  load(r"(C:\Users\bensa\OneDrive - Temple University\Ben R\Gaslight_Total\Gaslight_development\lookup_data\train_dist.rda)")

  #dataframe should not contain basevec
  cosData <- cleanText %>%
    dplyr::group_by(ID) %>%
    dplyr::summarize(cos_sim = lsa::cosine(basevec22$Mean_EmoSalience, Mean_EmoSalience), .groups = "drop")

  #convert cosine similarity to cosine distance using 1-observed cosine similarity
  conDistData <- cosData %>%
    dplyr::group_by(ID) %>%
    dplyr::mutate(cos_dist = 1-cos_sim) %>%
    dplyr::ungroup()
  # get mean and sd of training cosine distances
  m_dist <- mean(train_dist$cos_dist)
  sd_dist <- sd((train_dist$cos_dist))
  # norm the cosine distances to the training distribution
  normedData <- conDistData %>%
    dplyr::mutate(z_cos_dist = (cos_dist-mean(train_dist$cos_dist))/sd(train_dist$cos_dist),
                  p_gas = pnorm(z_cos_dist, mean=0, sd=1, lower.tail = F), #z-score one-sided distance from zero (perfect gaslighting)
                  p_Gaslight = round(p_gas, digits = 6)) %>%
    dplyr::select(!p_gas) %>% # classify each text sample
    dplyr::mutate(Is_It_Gaslighting =
                    ifelse(p_Gaslight<=.05, 'Unlikely',
                           ifelse(p_Gaslight >.05 &  p_Gaslight <=.15, "Weak",
                                  ifelse(p_Gaslight >.15 &  p_Gaslight <=.50, "Moderate",
                                         ifelse(p_Gaslight >.50 &  p_Gaslight <=.80, "Probably",
                                                'Highly Likely')))))

  return(normedData)
}
