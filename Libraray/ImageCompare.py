from PIL import Image

class ImageCompare:

    def compare_images_and_return(self, img1, img2, diff_image_filename=''):

        try:
            self.compare_images(img1, img2, diff_image_filename)
            return True
        except:
            return False

    def compare_images(self, img1, img2, diff_image_filename=''):
        im1 = Image.open(img1)

        width = im1.size[0]
        height = im1.size[1]

        return self.compare_partial_images(img1, img2, 0, 0, width, height, diff_image_filename)

    def compare_partial_images(self, img1, img2, x, y, width, height, diff_image_filename=''):

        im1 = Image.open(img1)
        im2 = Image.open(img2)

        diff_img = Image.new(im1.mode, (width, height))

        if not im1.size == im2.size and im1.mode == im2.mode:
            raise AssertionError('Images size or mode are not same!')

        diff = 'False'

        originalWidth = im1.size[0]
        originalHeight = im1.size[1]

        if x + width > originalWidth or y + height > originalHeight:
            raise AssertionError('Requested parameters are outside the image size')

        i = 0
        j = 0

        for p in range(x, x + width):
            for q in range(y, y + height):
                pixel1 = im1.getpixel((p, q))
                pixel2 = im2.getpixel((p, q))

                if not (pixel1[0] == pixel2[0] and pixel1[1] == pixel2[1] and pixel1[2] == pixel2[2]):

                    diff_img.putpixel((i, j), (0, 0, 0))
                    diff = 'True'
                    #print("true")
                    #break
                else:
                    #print("diff ")
                    diff_img.putpixel((i, j), (255, 255, 255))
        j = j + 1
        i = i + 1
        j = 0

        if diff == 'True':

            if diff_image_filename != '':
                diff_img.save(diff_image_filename)
            raise AssertionError('Images are Different')
        else:
            return True

#
# Compare = ImageCompare()
# Compare.compare_images_and_return(r"C:\Users\CSS\Downloads\img3.jpg", r"C:\Users\CSS\Downloads\img2.jpg", "abc.jpg")
