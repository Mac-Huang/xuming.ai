import os
import shutil
import random
from sklearn.model_selection import train_test_split

DATA_DIR = os.path.join(os.path.dirname(__file__), '..', 'data')
RAW_XUMING = os.path.join(DATA_DIR, 'xuming')
RAW_ANISHA = os.path.join(DATA_DIR, 'anisha')

TRAIN_DIR = os.path.join(DATA_DIR, 'train')
VAL_DIR = os.path.join(DATA_DIR, 'val')

def split_class(class_name, source_dir):
    files = [f for f in os.listdir(source_dir) if f.lower().endswith(('.png', '.jpg', '.jpeg'))]
    if not files:
        print(f"No images found for {class_name} in {source_dir}")
        return

    train_files, val_files = train_test_split(files, test_size=0.2, random_state=42)

    # Create directories
    os.makedirs(os.path.join(TRAIN_DIR, class_name), exist_ok=True)
    os.makedirs(os.path.join(VAL_DIR, class_name), exist_ok=True)

    # Copy files
    for f in train_files:
        shutil.copy(os.path.join(source_dir, f), os.path.join(TRAIN_DIR, class_name, f))
    
    for f in val_files:
        shutil.copy(os.path.join(source_dir, f), os.path.join(VAL_DIR, class_name, f))
    
    print(f"Split {class_name}: {len(train_files)} train, {len(val_files)} val")

def main():
    if not os.path.exists(RAW_XUMING) or not os.path.exists(RAW_ANISHA):
        print("Raw image directories not found. Please ensure data/xuming and data/anisha exist.")
        return

    split_class('xuming', RAW_XUMING)
    split_class('anisha', RAW_ANISHA)

if __name__ == "__main__":
    main()
