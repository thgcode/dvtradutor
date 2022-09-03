import requests
ender = "http://127.0.0.1:8080"

requests.post(f"{ender}/fala", json={"mensagem": "Ola mundo!"})
for i in range(10):
    requests.post(f"{ender}/bip")
    requests.post(f"{ender}/clek")
m = requests.get(f"{ender}/linha", json={"falando": True})
print(m.content)
