import io
import imageio
from tqdm import tqdm
import requests
from PIL import Image
import os
import json


def get_cat_bounded(url):
    """ Make a cat gif :D"""

    api_return = requests.get(url)
    if api_return.status_code==200:
        api_text = json.loads(api_return.text)
        while (api_text[0]['width']<=450 or api_text[0]['width']>=600) or \
              (api_text[0]['height']<=350 or api_text[0]['height']>=450):
            api_return = requests.get(url)
            if api_return.status_code==200:
                api_text = json.loads(api_return.text)
        r = requests.get(api_text[0]['url'])
        return Image.open(io.BytesIO(r.content))


url = 'https://api.thecatapi.com/v1/images/search'
images = []
for _ in tqdm(range(0, 50)):
    images.append(get_cat_bounded(url))
imageio.mimsave(os.path.join(os.getcwd(), '..', 'figures', 'cats.gif'), images, fps=1)
