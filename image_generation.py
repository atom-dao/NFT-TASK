import random
from PIL import Image
import os
import json


#storing all the attributes categorically
backs=[
r"./back/aura.PNG",
r"./back/axe.PNG",
r"./back/skateboard.PNG",
r"./back/wings.PNG",
]
  
bodys=[
r"./body/hoodie.png",
r"./body/overshirt.png",
r"./body/tshirt.PNG",
]

heads=[
r"./head/bandana.PNG",
r"./head/cap.PNG",
r"./head/facemask.PNG",
]
 
necks=[
r"./neck/blank.png",
r"./neck/chain.png",
]


#image used as a the background
base= Image.open("./base/bg.PNG")

#for loop for image generation
for x in range(10):

    #giving random chances to the images the generated images may not have the exact randomness but for large distribution can come close to normal
    back=random.choices(backs,weights=(30,30,20,20))[0]
    body=random.choices(bodys,weights=(40,30,30))[0]
    head= random.choices(heads, weights= (40,40,20))[0]
    neck= random.choices(necks, weights= (80,20))[0]

    #generating metadata for the images using a dictonary and storing into JSON file
    meta = {}
    meta['Background: '] = 'Sample'

    #extracting file name 
    new = os.path.basename(back)
    #removing .png   from the end   
    meta['Back: '] = new[:-4]


    new = os.path.basename(body)
    meta['Body: '] = new[:-4]


    new = os.path.basename(head)
    meta['Head: '] = new[:-4]


    new = os.path.basename(neck)
    meta['Neck: '] = new[:-4]


#layering the images 
        
    img1= Image.open(back)
    
    L1=Image.alpha_composite(base,img1)

    img2 = Image.open(body)

    L2=Image.alpha_composite(L1,img2)

    img3 = Image.open(head)

    L3=Image.alpha_composite(L2,img3)

    img4 = Image.open(neck)

    L4=Image.alpha_composite(L3,img4)

    L4.save(f'final{x}.png')

    #metadeta dump to JSON 

    f = open(f'metadata{x}.json', 'w') 
    f.write(json.dumps(meta))
    f.close()



    

