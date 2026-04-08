import os
from PIL import Image
import random

TARGET_DIR = os.path.join(os.path.dirname(__file__), '..', 'data', 'xuming')
TARGET_COUNT = 100

def augment():
    # Get all current jpg files
    files = [f for f in os.listdir(TARGET_DIR) if f.lower().endswith('.jpg')]
    current_count = len(files)
    
    if current_count >= TARGET_COUNT:
        print(f"Already have {current_count} images. No augmentation needed.")
        return
    
    needed = TARGET_COUNT - current_count
    print(f"Currently have {current_count} images. Augmenting {needed} more...")
    
    # Randomly pick images to augment
    to_augment = random.sample(files, needed)
    
    for i, filename in enumerate(to_augment):
        img_path = os.path.join(TARGET_DIR, filename)
        img = Image.open(img_path)
        
        # Horizontal flip
        flipped_img = img.transpose(Image.FLIP_LEFT_RIGHT)
        
        # Save as a new file
        new_filename = f"aug_{i}_{filename}"
        flipped_img.save(os.path.join(TARGET_DIR, new_filename), "JPEG")
        
    print(f"Successfully added {needed} augmented images.")

if __name__ == "__main__":
    augment()
