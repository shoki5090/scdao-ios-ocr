# import the necessary packages
from PIL import Image
import pytesseract
import cv2
import os


class ImageReader:
    """Take an input of Image Directory and loads on python"""
    def __init__(self, image_directory):
        """load or show the Imagefile"""
        self.image_directory = image_directory
        self.image = self.load_image_PIL()

    def load_image_PIL(self):
        """load image file"""
        img = Image.open(self.image_directory)
        
        return img

    def show_image(self):
        """show image"""
        self.image.show()

class ExtractText ():
    """Extract text out of image"""
    def __init__(self, image):
        self.image = image

    def extract_text(self):
        """Extract text from an image using tesseract"""
        text = pytesseract.image_to_string(self.image)
        # print(text)
        return text


if __name__ == "__main__":
    test_image = ImageReader("./img/test4.jpg")
    # test_image.show_image()
    text = ExtractText(test_image.image)
    print(text.extract_text())

