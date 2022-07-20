# numpy and pillow are used in these file
from typing import List
import numpy as np
import os
from PIL import Image

# getting the working directory and creating paths for each layer i.e, three groups
directory = os.getcwd()
group1 = os.path.join(directory, "group1")
group2 = os.path.join(directory, "group2")
group3 = os.path.join(directory, "group3")

# also creating path for final generating images
images_path = os.path.join(directory, "images")

# Listing all attributes in each group by creating list with the name of image files
group1_attributes = os.listdir(group1)
group2_attributes = os.listdir(group2)
group3_attributes = os.listdir(group3)

# creating rarity for each attributes of group corresponding to the list of attributes above
# note: these weights are only for total of 10 images 
group1_weights = [3,3,2,2]
group2_weights = [4,3,3]
group3_weights = [4,4,2]

# this is a sample variable contains 1 to 10, used to pick 2 random digits
li = [1,2,3,4,5,6,7,8,9,10]

# creating paths for base and chain images
base_path = os.path.join(directory,"base copy.png")
chain_path = os.path.join(directory,"chain.png")

# main function which creates images depending on rarity and randomly, initialized with a variable 
def generate_Image(total = 10):

    # 1) we are creating a list contains the attributes of group with repetition corresponding to weights mentioned
    # which generates list used for image generation, but we can't use it directly because 
    # repeat() returns list in order, so we generate a list contains same items in these list but arranged 
    # in randomly without changing the rarity
    total_group1 = np.repeat(group1_attributes,group1_weights)    
    total_group2 = np.repeat(group2_attributes,group2_weights)  
    total_group3 = np.repeat(group3_attributes,group3_weights)  

    # 2) we are using random.choice to generate same list but randomly without repetition(replace = false)
    # size @param returns the exact no of items from list which should be less than list size to get no repetition
    randomTotal_group1 = list(np.random.choice(total_group1,size = total,replace = False))
    randomTotal_group2 = list(np.random.choice(total_group2,size = total,replace = False))
    randomTotal_group3 = list(np.random.choice(total_group3,size = total,replace = False))

    # as we discussed above about @var li contains 1 to 10 numbers in list , we use li list to get a list containing 
    # two random numbers from 1 to 10, because chain image should present only in 2/10 images
    random_chain = list(np.random.choice(li,size = 2,replace = False))

    # loop runs @var total time which produces no 10 number of images
    while (total > 0):

        # opening all Image attributes using paths
        base = Image.open(base_path)
        chain = Image.open(chain_path)
        img1 = Image.open(os.path.join(group1, randomTotal_group1[total - 1]))
        img2 = Image.open(os.path.join(group2, randomTotal_group2[total - 1]))
        img3 = Image.open(os.path.join(group3, randomTotal_group3[total - 1]))

        # prints every image attributes
        print(randomTotal_group1[total - 1], "        " ,randomTotal_group2[total - 1],"        " ,randomTotal_group3[total - 1])
        # now we are using the random_chain list that contains two numbers , these two numbers will be matched with
        # image count, if image count matches the list of two numbers then chain will be included in the final image
        if(random_chain.count(total)) :
            base = Image.alpha_composite(base,chain)
            # prints if image count matches with the random numbers
            print("chain.png")
        
        # using alpha_composite to merge two images
        i1 = Image.alpha_composite(base,img1)
        i2 = Image.alpha_composite(i1,img2)
        final = Image.alpha_composite(i2,img3)
        final.save( images_path + "/img" + str(total)  + ".png")

        # decrementing totalImages @var to loop until the 10 images generated
        total -= 1

# calling generate_Image function
generate_Image()