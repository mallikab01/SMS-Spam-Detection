# Install and load necessary libraries
packages <- c("tm", "SnowballC", "ggplot2", "wordcloud", "RColorBrewer", "randomForest", "caret")

install_if_missing <- function(p) { 
  if (!require(p, character.only=TRUE)) install.packages(p, dependencies=TRUE) 
  library(p, character.only=TRUE)
}

lapply(packages, install_if_missing)

# Load dataset from your local path
file_path <- "/Users/Mallika/Downloads/SMSSpamCollection"
data_text <- read.table(file_path, sep="\t", header=FALSE, stringsAsFactors=FALSE, quote="", encoding="UTF-8")

colnames(data_text) <- c("class", "text")
data_text$class <- factor(data_text$class)

# Remove non-ASCII characters
data_text$text <- iconv(data_text$text, from="UTF-8", to="ASCII", sub="")

# Display class distribution
print(prop.table(table(data_text$class)))

# Text preprocessing
corpus <- VCorpus(VectorSource(data_text$text))
corpus <- tm_map(corpus, content_transformer(tolower))
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, removeWords, stopwords("english"))
corpus <- tm_map(corpus, stemDocument)
corpus <- tm_map(corpus, stripWhitespace)

# Convert text to Document-Term Matrix
dtm <- DocumentTermMatrix(corpus)
dtm <- removeSparseTerms(dtm, 0.999)

# Convert word frequency to binary (presence/absence)
convert_count <- function(x) {
  y <- ifelse(x > 0, 1, 0)
  factor(y, levels=c(0,1), labels=c("No", "Yes"))
}

datasetNB <- apply(dtm, 2, convert_count)
dataset <- as.data.frame(datasetNB)

# Extract frequent words
freq <- sort(colSums(as.matrix(dtm)), decreasing=TRUE)
wf <- data.frame(word=names(freq), freq=freq)

# Plot word frequency
ggplot(wf[1:20, ], aes(x=reorder(word, freq), y=freq)) +
  geom_bar(stat="identity", fill="steelblue") +
  coord_flip() +
  xlab("Words") + ylab("Frequency") +
  ggtitle("Top 20 Words in Spam/Ham Messages")

# Generate word cloud
set.seed(123)
wordcloud(words=wf$word, freq=wf$freq, min.freq=1, max.words=200, colors=brewer.pal(8, "Dark2"))

# Add target class column
dataset$class <- data_text$class

# Split into training and test sets
set.seed(123)
trainIndex <- createDataPartition(dataset$class, p=0.75, list=FALSE)
trainData <- dataset[trainIndex, ]
testData <- dataset[-trainIndex, ]

# Train Random Forest model
model <- randomForest(class ~ ., data=trainData)

# Predict on test set
predictions <- predict(model, testData)

# Evaluate model performance
conf_matrix <- confusionMatrix(predictions, testData$class)
print(conf_matrix)