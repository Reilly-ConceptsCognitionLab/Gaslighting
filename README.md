
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Gaslighting

Gaslighting allows you to classify each text sample in a corpus based on
it’s similarity to gaslighting on 22 emotional dimensions. This is all
accomplished with a single call to the function ‘estimateGaslighting()’.

<!-- badges: start -->

## Installation

You can install the most up to date version of Gaslighting using
devtools:

``` r
devtools::install_github("https://github.com/Reilly-ConceptsCognitionLab/Gaslighting.git")
```

## Example data

Data supplied to ‘estimateGaslighting()’ must fit a specific format
requirement. Data must be in formatted as a data frame with a column
titled ‘Text’ with text data and a column titled ‘ID’ with a unique
identifier for each text sample. Any additional columns are treated as
metadata and will be preserved.

| ID | Text | Length |
|---:|:---|---:|
| 1 | The supervisor can be gaslighting the student worker by lying saying that there was money missing from the register and blaming the student as if they were the ones who took it, when really it was the supervisor who miscounted or took the money themselves. The student worker maybe questioning themselves trying to backtrack their steps to see if they did anything wrong, they can be trying to explain that they are not at fault, or they may eventually believe that the were at fault due to how much the supervisor is gaslighting them. | 94 |
| 2 | You will rejoice to hear that no disaster has accompanied the commencement of an enterprise which you have regarded with such evil forebodings. I arrived here yesterday, and my first task is to assure my dear sister of my welfare and increasing confidence in the success of my undertaking. | 49 |
| 3 | I had called upon my friend, Mr. Sherlock Holmes, one day in the autumn of last year and found him in deep conversation with a very stout, florid-faced, elderly gentleman with fiery red hair. With an apology for my intrusion, I was about to withdraw when Holmes pulled me abruptly into the room and closed the door behind me. | 59 |

## Calling ‘estimateGaslighting()’

Text is classified as gaslighting using the cosine similarity of the 22
dimension vector of affective ratings. This is then converted to the
cosine distance and normalized to on the distribution of cosine
distances from the training set. This allows each text sample to be
given a p-value, which is used to classify the text sample into one for
five groups:

1.  ‘Unlikely’ (p\<=0.05)
2.  ‘Weak’ (0.05\<p\<=0.15)
3.  ‘Moderate’ (0.15\<p\<=0.50)
4.  ‘Probably’ (0.50\<p\<=0.80)
5.  ‘Highly Likely’ (0.80\<p)

``` r
library(Gaslighting)
estimatedData <- Gaslighting::estimateGaslighting(exampleData)
knitr::kable(estimatedData)
```

| ID  |   cos_sim |  cos_dist | z_cos_dist | p_Gaslight | Is_It_Gaslighting | Length |
|:----|----------:|----------:|-----------:|-----------:|:------------------|-------:|
| 1   | 0.7628770 | 0.2371230 |  -1.178413 |   0.880684 | Highly Likely     |     94 |
| 2   | 0.4577507 | 0.5422493 |   1.333361 |   0.091207 | Weak              |     49 |
| 3   | 0.4304179 | 0.5695821 |   1.558362 |   0.059574 | Weak              |     59 |
