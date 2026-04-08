import os
import tensorflow as tf
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras.applications import MobileNetV2
from tensorflow.keras.layers import Dense, GlobalAveragePooling2D, Dropout
from tensorflow.keras.models import Model
from tensorflow.keras.optimizers import Adam
import matplotlib.pyplot as plt
import numpy as np

# Path to the dataset
DATA_DIR = os.path.join(os.path.dirname(__file__), '..', 'data')
MODEL_DIR = os.path.join(os.path.dirname(__file__), '..', 'model')

# Hyperparameters
IMG_SIZE = (224, 224)
BATCH_SIZE = 16
EPOCHS = 20
LEARNING_RATE = 0.0001

def create_generators():
    # Data Augmentation for training
    train_datagen = ImageDataGenerator(
        rescale=1./255,
        rotation_range=20,
        width_shift_range=0.2,
        height_shift_range=0.2,
        shear_range=0.2,
        zoom_range=0.2,
        horizontal_flip=True,
        fill_mode='nearest',
        validation_split=0.2  # 80% train, 20% validation
    )

    # Generators
    train_generator = train_datagen.flow_from_directory(
        DATA_DIR,
        target_size=IMG_SIZE,
        batch_size=BATCH_SIZE,
        class_mode='binary',  # For 2 classes (Xuming vs Anisha)
        subset='training'
    )

    validation_generator = train_datagen.flow_from_directory(
        DATA_DIR,
        target_size=IMG_SIZE,
        batch_size=BATCH_SIZE,
        class_mode='binary',
        subset='validation'
    )
    
    return train_generator, validation_generator

def build_model():
    # Load MobileNetV2 pre-trained on ImageNet without the top layers
    base_model = MobileNetV2(weights='imagenet', include_top=False, input_shape=(224, 224, 3))
    
    # Freeze the base model
    base_model.trainable = False
    
    # Add custom top layers
    x = base_model.output
    x = GlobalAveragePooling2D()(x)
    x = Dense(128, activation='relu')(x)
    x = Dropout(0.5)(x)
    predictions = Dense(1, activation='sigmoid')(x)  # Sigmoid for binary classification
    
    model = Model(inputs=base_model.input, outputs=predictions)
    
    model.compile(optimizer=Adam(learning_rate=LEARNING_RATE),
                  loss='binary_crossentropy',
                  metrics=['accuracy'])
    
    return model

def train():
    if not os.path.exists(DATA_DIR):
        print(f"Error: {DATA_DIR} does not exist. Please provide images in data/xuming and data/anisha.")
        return

    # Check if we have enough images
    xuming_dir = os.path.join(DATA_DIR, 'xuming')
    anisha_dir = os.path.join(DATA_DIR, 'anisha')
    
    if not (os.path.exists(xuming_dir) and os.path.exists(anisha_dir)):
        print(f"Error: Missing directories for xuming or anisha.")
        return
        
    xuming_count = len(os.listdir(xuming_dir))
    anisha_count = len(os.listdir(anisha_dir))
    
    print(f"Found {xuming_count} images of Xuming and {anisha_count} images of Anisha.")
    
    if xuming_count == 0 or anisha_count == 0:
        print("Error: No images found in directories. Please add images before training.")
        return

    train_gen, val_gen = create_generators()
    
    model = build_model()
    
    # Train the model
    history = model.fit(
        train_gen,
        epochs=EPOCHS,
        validation_data=val_gen
    )
    
    # Save the model
    if not os.path.exists(MODEL_DIR):
        os.makedirs(MODEL_DIR)
        
    model.save(os.path.join(MODEL_DIR, 'model.h5'))
    print(f"Model saved to {MODEL_DIR}")
    
    # Convert to TFJS format for web inference
    import subprocess
    try:
        subprocess.run([
            'tensorflowjs_converter',
            '--input_format', 'keras',
            os.path.join(MODEL_DIR, 'model.h5'),
            os.path.join(MODEL_DIR, 'tfjs_model')
        ], check=True)
        print("Model converted to TensorFlow.js format.")
    except Exception as e:
        print(f"Error converting to TFJS: {e}")

if __name__ == "__main__":
    train()
