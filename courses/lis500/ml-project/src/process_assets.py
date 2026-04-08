import os
import cv2
import PIL.Image
from pillow_heif import register_heif_opener
import shutil

register_heif_opener()

SOURCE_DIR = os.path.join(os.path.dirname(__file__), '..', 'data', 'xuming', 'images_and_videos')
TARGET_DIR = os.path.join(os.path.dirname(__file__), '..', 'data', 'xuming')

def extract_frame(video_path, output_path):
    cap = cv2.VideoCapture(video_path)
    if not cap.isOpened():
        print(f"Could not open video {video_path}")
        return False
    
    # Get total frames
    total_frames = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
    # Extract middle frame
    cap.set(cv2.CAP_PROP_POS_FRAMES, total_frames // 2)
    
    ret, frame = cap.read()
    if ret:
        cv2.imwrite(output_path, frame)
        cap.release()
        return True
    
    cap.release()
    return False

def convert_heic(heic_path, output_path):
    try:
        image = PIL.Image.open(heic_path)
        image.save(output_path, "JPEG")
        return True
    except Exception as e:
        print(f"Error converting {heic_path}: {e}")
        return False

def main():
    if not os.path.exists(SOURCE_DIR):
        print(f"Source directory {SOURCE_DIR} not found.")
        return

    files = os.listdir(SOURCE_DIR)
    processed_count = 0

    for filename in files:
        file_path = os.path.join(SOURCE_DIR, filename)
        base_name = os.path.splitext(filename)[0]
        ext = os.path.splitext(filename)[1].lower()

        target_path = os.path.join(TARGET_DIR, f"{base_name}.jpg")

        if ext in ('.mov', '.mp4'):
            print(f"Processing video: {filename}")
            if extract_frame(file_path, target_path):
                processed_count += 1
        elif ext == '.heic':
            print(f"Converting HEIC: {filename}")
            if convert_heic(file_path, target_path):
                processed_count += 1
        elif ext in ('.jpg', '.jpeg', '.png'):
            print(f"Copying image: {filename}")
            shutil.copy(file_path, target_path)
            processed_count += 1

    print(f"Finished! Processed {processed_count} files into {TARGET_DIR}")

if __name__ == "__main__":
    main()
