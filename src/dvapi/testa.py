import requests
ender = "http://127.0.0.1:8080"

requests.post(f"{ender}/fala", json={"mensagem": "Ola mundo!"})
m = requests.get(f"{ender}/linha", json={"falando": True})
print(m.content)
