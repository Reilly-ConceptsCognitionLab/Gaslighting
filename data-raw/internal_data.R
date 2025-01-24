## code to prepare internal data for Gaslighting

# read in rda with the gaslighting base vecotr
bvecPath <- r"(C:\Users\tun27424\Downloads\basevec22.rda)"
# read in rda with the training distances
trainPath <- r"(C:\Users\tun27424\Downloads\train_dist.rda)"

# load both rdas
load(bvecPath)
load(trainPath)

# write to more descriptive names
gaslightBasevector <- basevec22
# rename and facotr columns
gaslightBasevector$ID <- as.factor(gaslightBasevector$ID)
colnames(gaslightBasevector)[1] <- "Dimension"
colnames(gaslightBasevector)[2] <- "Factor_Score"
# print
print(gaslightBasevector)

gaslightTrainDist <- train_dist
print(gaslightTrainDist)

usethis::use_data(gaslightBasevector, gaslightTrainDist,
                  internal = TRUE, overwrite = TRUE)
