## code to prepare internal data for Gaslighting

# read in rda with the gaslighting base vecotr
bvecPath <- r"(C:\Users\bensa\OneDrive - Temple University\Ben R\Gaslight_Total\Gaslight_development\lookup_data\basevec22.rda)"
# read in rda with the training distances
trainPath <- r"(C:\Users\bensa\OneDrive - Temple University\Ben R\Gaslight_Total\Gaslight_development\lookup_data\train_dist.rda)"

# load both rdas
load(bvecPath)
load(trainPath)

# write to more descriptive names
gaslightBasevector <- basevec22
# rename and facotr columns
gaslightBasevector$ID <- as.factor(gaslightBasevector$ID)
colnames(gaslightBasevector)[1] <- "Dimension"
# print
print(gaslightBasevector)

gaslightTrainDist <- train_dist
print(gaslightTrainDist)

usethis::use_data(gaslightBasevector, gaslightTrainDist,
                  internal = TRUE, overwrite = TRUE)
