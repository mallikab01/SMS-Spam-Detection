# SMS-Spam-Detection
📌 Project Description : 
This project uses a Random Forest Classifier to detect spam SMS messages. The dataset consists of labeled SMS texts categorized as either spam or ham. Natural Language Processing (NLP) techniques are used to clean and transform the text data. A Document-Term Matrix is created to represent text in numerical form, and the model is trained to classify messages accurately. Word frequencies are visualized using a word cloud.

📁 Dataset : 
SMSSpamCollection (tab-separated file with 2 columns: label and message)
Target variable: label (ham = not spam, spam = spam)

⚙️ Project Steps : 
1. Data Preprocessing
   - Loaded and read the dataset
   - Renamed columns and factorized target labels
   - Cleaned text: removed punctuation, numbers, stopwords
   - Converted text to lowercase, performed stemming
2. Text Transformation
   - Created corpus using tm package
   - Generated Document-Term Matrix (DTM)
   - Converted term counts to binary features using a custom convert_count function
   - Visualized most frequent words using a word cloud
3. Model Building
   - Split data into training and test sets (3:1 ratio)
   - Trained a Random Forest classifier
   - Predicted test data and evaluated performance
4. Evaluation
   - Displayed confusion matrix and accuracy
   - Achieved high accuracy in spam classification
   - Word cloud revealed high-frequency terms like “call”, “free”, “win”, and “claim”
📊 Output :
output image is uploaded in the files.
