import time
import requests
from bs4 import BeautifulSoup

# URL du répertoire contenant l'image
url = 'https://cncholonge.fr/Cam/'

def get_latest_image_url():
    response = requests.get(url)
    soup = BeautifulSoup(response.text, 'html.parser')

    # Rechercher tous les liens <a> qui correspondent à un fichier commençant par "Image"
    for link in soup.find_all('a'):
        if link.get('href').startswith('Image'):
            return url + link.get('href')  # URL complète de l'image

    return None

def download_image(img_url):
    response = requests.get(img_url)
    filename = img_url.split('/')[-1]
    if response.status_code == 200:
        with open(filename, 'wb') as file:
            file.write(response.content)
        print(f"Image téléchargée : {filename}")
    else:
        print("Impossible de télécharger l'image")

# Intervalle entre les téléchargements (en secondes)
interval = 120

while True:
    img_url = get_latest_image_url()
    if img_url:
        print(f"Téléchargement de l'image depuis : {img_url}")
        download_image(img_url)
    else:
        print("Aucune image trouvée")
    time.sleep(interval)
