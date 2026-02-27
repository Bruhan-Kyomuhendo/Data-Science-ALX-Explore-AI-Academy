import pandas as pd
import numpy as np
import faiss
from surprise import Dataset, Reader
from lightfm import LightFM
from lightfm.data import Dataset as LFM_Dataset
from sklearn.decomposition import TruncatedSVD
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.preprocessing import StandardScaler
from scipy.sparse import hstack
import joblib
import lightgbm as lgb
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_squared_error
from multiprocessing import Pool

DATA_PATH = '/content/drive/MyDrive/Data_science/DS_Course/Unsupervised_learning/'

def load_data(sample_size=50000, val_size=0.2):
    movies = pd.read_csv(f"{DATA_PATH}movies.csv")
    genome_scores = pd.read_csv(f"{DATA_PATH}genome_scores.csv")
    genome_tags = pd.read_csv(f"{DATA_PATH}genome_tags.csv")
    imdb_data = pd.read_csv(f"{DATA_PATH}imdb_data.csv")
    links = pd.read_csv(f"{DATA_PATH}links.csv")
    tags = pd.read_csv(f"{DATA_PATH}tags.csv")
    train = pd.read_csv(f"{DATA_PATH}train.csv").sample(sample_size, random_state=42)
    test = pd.read_csv(f"{DATA_PATH}test.csv")
    
    train_df, val_df = train_test_split(train, test_size=val_size, random_state=42)
    
    genome = genome_scores.merge(genome_tags, on='tagId')
    genome_pivot = genome.pivot(index='movieId', columns='tag', values='relevance').fillna(0)
    
    movies = movies.merge(imdb_data, on='movieId', how='left')
    movies = movies.merge(links, on='movieId', how='left')
    
    return train_df, val_df, test, movies, genome_pivot, tags

def create_hybrid_features(movies_df, genome_df, tags_df):
    vectorizer = TfidfVectorizer()
    tfidf_matrix = vectorizer.fit_transform(movies_df['genres'].fillna(''))
    
    n_components = min(50, tfidf_matrix.shape[1])
    svd = TruncatedSVD(n_components=n_components)
    genre_features = svd.fit_transform(tfidf_matrix)
    
    genome_features = genome_df.reindex(movies_df['movieId']).fillna(0).values
    
    features = np.hstack([genre_features, genome_features])
    
    scaler = StandardScaler()
    feature_matrix = scaler.fit_transform(features)
    
    return feature_matrix, movies_df

class HybridRecommender:
    def __init__(self):
        self.cf_model = None
        self.content_index = None
        self.movie_map = None
        self.lgb_model = None

    def fit(self, train_df, feature_matrix, movies):
        self.cf_model = self.train_collaborative_model(train_df)
        self.content_index = self.train_content_model(feature_matrix)
        self.movie_map = movies[['movieId']]
        
        x_train = []
        y_train = []
        for _, row in train_df.iterrows():
            movie_idx = self.movie_map.index[self.movie_map['movieId'] == row['movieId']][0]
            _, indices = self.content_index.search(np.array([feature_matrix[movie_idx]]), 10)
            content_score = np.mean(indices[0])
            x_train.append([content_score])
            y_train.append(row['rating'])
        
        x_train = np.array(x_train)
        y_train = np.array(y_train)
        self.lgb_model = lgb.LGBMRegressor()
        self.lgb_model.fit(x_train, y_train)

    def train_collaborative_model(self, train_df):
        dataset = LFM_Dataset()
        dataset.fit(train_df['userId'], train_df['movieId'])
        interactions, _ = dataset.build_interactions(train_df[['userId', 'movieId', 'rating']].values)
        model = LightFM(loss='warp')
        model.fit(interactions, epochs=10, num_threads=4)
        return model
    
    def train_content_model(self, feature_matrix):
        feature_matrix = np.array(feature_matrix).astype('float32')
        index = faiss.IndexFlatL2(feature_matrix.shape[1])
        index.add(feature_matrix)
        return index

    def evaluate(self, val_df):
        y_true = val_df['rating'].values
        y_pred = val_df.apply(lambda row: self.predict_rating(row['userId'], row['movieId']), axis=1)
        rmse = np.sqrt(mean_squared_error(y_true, y_pred))
        print(f"Validation RMSE: {rmse}")
        return rmse
    
    def predict_rating(self, user_id, movie_id):
        movie_idx = self.movie_map.index[self.movie_map['movieId'] == movie_id][0]
        _, indices = self.content_index.search(np.array([feature_matrix[movie_idx]]), 10)
        content_score = np.mean(indices[0])
        return self.lgb_model.predict(np.array([[content_score]]))[0]

def generate_submission(recommender, test_df):
    test_df['predicted_rating'] = test_df.apply(lambda row: recommender.predict_rating(row['userId'], row['movieId']), axis=1)
    test_df[['userId', 'movieId', 'predicted_rating']].to_csv('submission.csv', index=False)

if __name__ == "__main__":
    train_df, val_df, test_df, movies_df, genome_df, tags_df = load_data(sample_size=30000, val_size=0.2)
    feature_matrix, movies_df = create_hybrid_features(movies_df, genome_df, tags_df)
    recommender = HybridRecommender()
    recommender.fit(train_df, feature_matrix, movies_df)
    joblib.dump(recommender, 'hybrid_recommender.pkl')
    recommender.evaluate(val_df)
    generate_submission(recommender, test_df)
